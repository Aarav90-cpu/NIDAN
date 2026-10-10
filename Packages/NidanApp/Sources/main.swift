import Vapor
import NidanStorage
import NidanModels
import NidanCore
import Foundation

private func enrollmentCode() -> String {
    var generator = SystemRandomNumberGenerator()
    let bytes = (0..<32).map { _ in UInt8.random(in: .min ... .max, using: &generator) }
    return Data(bytes).base64EncodedString()
        .replacingOccurrences(of: "+", with: "-")
        .replacingOccurrences(of: "/", with: "_")
        .replacingOccurrences(of: "=", with: "")
}

private func enrollmentCodeHash(_ code: String) -> String {
    SHA256.hash(data: Data(code.utf8)).map { String(format: "%02x", $0) }.joined()
}

private func optionalTrimmed(_ value: String?) -> String? {
    guard let value = value?.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty else {
        return nil
    }
    return value
}

private let sessionCookieName = "nidan_session"
private let sessionLifetime = 7 * 24 * 60 * 60

private struct DatabaseStorageKey: StorageKey {
    typealias Value = DatabaseManager
}

private struct AuthenticatedUserStorageKey: StorageKey {
    typealias Value = SessionUser
}

private struct SessionAuthenticationMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        guard let database = request.application.storage[DatabaseStorageKey.self],
              let token = request.cookies[sessionCookieName]?.string,
              (1...128).contains(token.count),
              let user = try await database.authenticatedUser(sessionTokenHash: enrollmentCodeHash(token)) else {
            throw Abort(.unauthorized)
        }

        request.storage[AuthenticatedUserStorageKey.self] = user
        return try await next.respond(to: request)
    }
}

private struct AuthenticatedMeResponse: Content {
    var status: String
    var id: UUID
    var name: String
    var role: UserRole
}

private struct StudentDashboardResponse: Content {
    var name: String
    var classes: [StudentClassSummary]
    var assignments: [StudentAssignmentSummary]
    var notices: [SchoolNoticeSummary]
    var marks: [SchoolMarkSummary]
    var doubts: [StudentDoubtSummary]
    var diagnosticAttemptCount: Int
    var latestDiagnosticScore: Int?

    init(_ dashboard: StudentDashboard) {
        name = dashboard.name
        classes = dashboard.classes
        assignments = dashboard.assignments
        notices = dashboard.notices
        marks = dashboard.marks
        doubts = dashboard.doubts
        diagnosticAttemptCount = dashboard.diagnosticAttemptCount
        latestDiagnosticScore = dashboard.latestDiagnosticScore
    }
}

private struct SchoolDashboardResponse: Content {
    var role: UserRole
    var name: String
    var classes: [SchoolClassSummary]
    var notices: [SchoolNoticeSummary]
    var assignments: [SchoolAssignmentSummary]
    var marks: [SchoolMarkSummary]
    var doubts: [SchoolDoubtSummary]
    var chapters: [SchoolChapterSummary]
    var staff: [StaffProgressSummary]

    init(_ dashboard: SchoolDashboard) {
        role = dashboard.role
        name = dashboard.name
        classes = dashboard.classes
        notices = dashboard.notices
        assignments = dashboard.assignments
        marks = dashboard.marks
        doubts = dashboard.doubts
        chapters = dashboard.chapters
        staff = dashboard.staff
    }
}

private func servePage(_ request: Request, from directory: String, named fileName: String) async throws -> Response {
    let path = URL(fileURLWithPath: directory).appendingPathComponent(fileName).path
    return try await request.fileio.asyncStreamFile(at: path)
}

private struct DiagnosticQuestionResponse: Content {
    var id: UUID
    var text: String
    var options: [String]
}

private struct DiagnosticAnswerPayload: Content {
    var questionId: UUID
    var answer: String
}

private struct DiagnosticSubmissionPayload: Content {
    var answers: [DiagnosticAnswerPayload]
}

private struct DiagnosticAttemptResponse: Content {
    var attemptId: UUID
    var score: Int
    var correctCount: Int
    var questionCount: Int
    var state: String
    var recommendation: String
}

private struct AssignmentCreatePayload: Content {
    var classId: UUID
    var title: String
    var instructions: String
    var subject: String
    var chapter: String?
    var dueAt: Date
}

private struct NoticeCreatePayload: Content {
    var classId: UUID?
    var title: String
    var body: String
}

private struct MarkCreatePayload: Content {
    var studentId: UUID
    var classId: UUID
    var subject: String
    var assessmentTitle: String
    var mark: Int
    var maximumMark: Int
}

private struct AssignmentMarkPayload: Content {
    var studentId: UUID
    var mark: Int
    var maximumMark: Int
    var feedback: String?
}

private struct ChapterProgressPayload: Content {
    var classId: UUID
    var subject: String
    var chapter: String
    var completionPercent: Int
}

private struct DoubtCreatePayload: Content {
    var classId: UUID
    var subject: String
    var topic: String
    var message: String
}

private struct DoubtResponsePayload: Content {
    var message: String
}

private struct StudentSubmitAssignmentPayload: Content {
    var completedInClass: Bool
}

private struct CreatedRecordResponse: Content {
    var id: UUID
}

private struct AssignmentSubmissionResponse: Content {
    var studentId: UUID
    var studentName: String
    var status: String
    var submittedAt: Date?
    var mark: Int?
    var maximumMark: Int?
    var teacherFeedback: String?
}

private struct EnrollmentCodeCreatePayload: Content {
    var role: UserRole
    var classes: [String]
    var subjects: [String]
}

private struct EnrollmentCodeResponse: Content {
    var code: String
    var role: UserRole
    var expiresAt: Date
}

@main
struct NidanApp {
    static func main() async throws {
        var env = try Vapor.Environment.detect()
        try LoggingSystem.bootstrap(from: &env)

        let sourceFile = URL(fileURLWithPath: #filePath)
        let projectRoot = sourceFile
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        let dbPath = projectRoot.appendingPathComponent("nidan.sqlite").path

        let arguments = Array(CommandLine.arguments.dropFirst())
        if arguments.first == "issue-enrollment-code" {
            guard arguments.count >= 2,
                  let role = UserRole(rawValue: arguments[1]),
                role == .student || role == .teacher || role == .vicePrincipal || role == .principal else {
                throw Abort(.badRequest, reason: "Usage: NidanApp issue-enrollment-code <student|teacher|vicePrincipal|principal> [--classes 9A,9B] [--subjects Mathematics,Science]")
            }

            var classes: [String] = []
            var subjects: [String] = []
            for optionIndex in stride(from: 2, to: arguments.count, by: 2) {
                guard optionIndex + 1 < arguments.count else {
                    throw Abort(.badRequest, reason: "Enrollment scope options require values.")
                }
                let values = arguments[optionIndex + 1].split(separator: ",").map(String.init)
                switch arguments[optionIndex] {
                case "--classes": classes = values
                case "--subjects": subjects = values
                default: throw Abort(.badRequest, reason: "Unknown enrollment scope option.")
                }
            }
            if role == .student && (classes.count != 1 || !subjects.isEmpty) {
                throw Abort(.badRequest, reason: "Student enrollment requires exactly one --classes value and no --subjects.")
            }
            if role == .teacher && (classes.isEmpty || subjects.isEmpty) {
                throw Abort(.badRequest, reason: "Teacher enrollment requires --classes and --subjects.")
            }
            if (role == .vicePrincipal || role == .principal) && (!classes.isEmpty || !subjects.isEmpty) {
                throw Abort(.badRequest, reason: "Leadership enrollment codes cannot have class or subject scopes.")
            }

            let code = enrollmentCode()
            let db = try DatabaseManager(path: dbPath)
            try await db.createEnrollmentCode(
                codeHash: enrollmentCodeHash(code),
                role: role,
                scope: EnrollmentScope(classes: classes, subjects: subjects),
                expiresAt: Date().addingTimeInterval(24 * 60 * 60)
            )
            print("One-time enrollment code, valid for 24 hours: \(code)")
            return
        }
        
        let app = try await Application.make(env)
        
        app.http.server.configuration.hostname = ProcessInfo.processInfo.environment["NIDAN_BIND_HOST"] ?? "127.0.0.1"
        app.http.server.configuration.port = Int(ProcessInfo.processInfo.environment["NIDAN_API_PORT"] ?? "8080") ?? 8080
        
        // Compute the absolute path to Frontend/dist securely
        let publicDir = projectRoot.appendingPathComponent("Frontend/dist/").path
        app.middleware.use(FileMiddleware(publicDirectory: publicDir))
        
        // Initialize Core Data Systems
        let db = try DatabaseManager(path: dbPath)
        if ProcessInfo.processInfo.environment["NIDAN_DEMO_SEED"] == "1" {
            try await db.seedDemoSchoolData()
        }
        try await db.seedDiagnosticQuestionBank()
        
        // Make db available to routes (simple global for this prototype)
        app.storage[DatabaseStorageKey.self] = db
        
        // Setup simple API routes
        let api = app.grouped("api")
        api.get("status") { req async -> String in
            return "NIDAN Core Online"
        }

        let authenticatedAPI = api.grouped(SessionAuthenticationMiddleware())
        authenticatedAPI.get("me") { req async throws -> AuthenticatedMeResponse in
            guard let user = req.storage[AuthenticatedUserStorageKey.self] else {
                throw Abort(.unauthorized)
            }
            return AuthenticatedMeResponse(status: "registered", id: user.id, name: user.name, role: user.role)
        }

        authenticatedAPI.post("logout") { req async throws -> Response in
            guard let db = req.application.storage[DatabaseStorageKey.self] else {
                throw Abort(.internalServerError)
            }
            guard let token = req.cookies[sessionCookieName]?.string else { throw Abort(.unauthorized) }
            try await db.revokeSession(sessionTokenHash: enrollmentCodeHash(token))
            let response = Response(status: .noContent)
            response.cookies[sessionCookieName] = .expired
            return response
        }

        authenticatedAPI.get("diagnostic", "questions") { req async throws -> [DiagnosticQuestionResponse] in
            guard let user = req.storage[AuthenticatedUserStorageKey.self], user.role == .student else {
                throw Abort(.forbidden)
            }
            guard let db = req.application.storage[DatabaseStorageKey.self] else {
                throw Abort(.internalServerError)
            }
            let questions = try await db.diagnosticQuestions(for: user.id)
            return questions.map {
                DiagnosticQuestionResponse(id: $0.id, text: $0.text, options: $0.options)
            }
        }

        authenticatedAPI.post("diagnostic", "attempts") { req async throws -> DiagnosticAttemptResponse in
            guard let user = req.storage[AuthenticatedUserStorageKey.self], user.role == .student else {
                throw Abort(.forbidden)
            }
            guard let db = req.application.storage[DatabaseStorageKey.self] else {
                throw Abort(.internalServerError)
            }
            let payload = try req.content.decode(DiagnosticSubmissionPayload.self)
            let answers = payload.answers.map {
                DiagnosticAnswerInput(questionID: $0.questionId, answer: $0.answer)
            }
            do {
                let result = try await db.submitDiagnosticAttempt(studentID: user.id, answers: answers)
                return DiagnosticAttemptResponse(
                    attemptId: result.attemptID,
                    score: result.score,
                    correctCount: result.correctCount,
                    questionCount: result.questionCount,
                    state: result.state,
                    recommendation: result.recommendation
                )
            } catch NidanError.validationFailed(let message) {
                throw Abort(.badRequest, reason: message)
            }
        }

        let v1API = authenticatedAPI.grouped("v1")
        v1API.get("student", "dashboard") { req async throws -> StudentDashboardResponse in
            guard let user = req.storage[AuthenticatedUserStorageKey.self], user.role == .student else { throw Abort(.forbidden) }
            guard let db = req.application.storage[DatabaseStorageKey.self] else { throw Abort(.internalServerError) }
            return StudentDashboardResponse(try await db.studentDashboard(for: user))
        }

        v1API.post("student", "assignments", ":assignmentID", "submit") { req async throws -> HTTPStatus in
            guard let user = req.storage[AuthenticatedUserStorageKey.self], user.role == .student else { throw Abort(.forbidden) }
            guard let db = req.application.storage[DatabaseStorageKey.self],
                  let assignmentID = req.parameters.get("assignmentID", as: UUID.self) else { throw Abort(.badRequest) }
            let payload = try req.content.decode(StudentSubmitAssignmentPayload.self)
            guard payload.completedInClass else { throw Abort(.badRequest, reason: "Confirm that the paper worksheet was handed to the teacher in class.") }
            do {
                try await db.submitPaperAssignment(assignmentID: assignmentID, by: user)
                return .noContent
            } catch let error as NidanError {
                throw Abort(.badRequest, reason: error.localizedDescription)
            }
        }

        v1API.post("student", "doubts") { req async throws -> CreatedRecordResponse in
            guard let user = req.storage[AuthenticatedUserStorageKey.self], user.role == .student else { throw Abort(.forbidden) }
            guard let db = req.application.storage[DatabaseStorageKey.self] else { throw Abort(.internalServerError) }
            let payload = try req.content.decode(DoubtCreatePayload.self)
            do {
                let id = try await db.createStudentDoubt(DoubtCreation(classID: payload.classId, subject: payload.subject, topic: payload.topic, message: payload.message), by: user)
                return CreatedRecordResponse(id: id)
            } catch let error as NidanError {
                throw Abort(.badRequest, reason: error.localizedDescription)
            }
        }

        v1API.get("school", "dashboard") { req async throws -> SchoolDashboardResponse in
            guard let user = req.storage[AuthenticatedUserStorageKey.self],
                  user.role == .teacher || user.role == .vicePrincipal || user.role == .principal else {
                throw Abort(.forbidden)
            }
            guard let db = req.application.storage[DatabaseStorageKey.self] else { throw Abort(.internalServerError) }
            return SchoolDashboardResponse(try await db.schoolDashboard(for: user))
        }

        v1API.post("school", "enrollment-codes") { req async throws -> EnrollmentCodeResponse in
            guard let user = req.storage[AuthenticatedUserStorageKey.self], user.role == .principal else { throw Abort(.forbidden) }
            guard let db = req.application.storage[DatabaseStorageKey.self] else { throw Abort(.internalServerError) }
            let payload = try req.content.decode(EnrollmentCodeCreatePayload.self)
            let classes = payload.classes.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            let subjects = payload.subjects.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            guard classes.count <= 50, subjects.count <= 50,
                  classes.allSatisfy({ className in
                      let grade = className.prefix(while: { $0.isNumber })
                      let division = className.dropFirst(grade.count)
                      return !grade.isEmpty && !division.isEmpty && className.count <= 20 && division.allSatisfy({ $0.isLetter || $0.isNumber })
                  }),
                  subjects.allSatisfy({ !$0.isEmpty && $0.count <= 60 }) else {
                throw Abort(.badRequest, reason: "Enrollment scope contains invalid values.")
            }
            switch payload.role {
            case .student where classes.count != 1 || !subjects.isEmpty:
                throw Abort(.badRequest, reason: "Student codes require one class and no subjects.")
            case .teacher where classes.isEmpty || subjects.isEmpty:
                throw Abort(.badRequest, reason: "Teacher codes require at least one class and subject.")
              case .vicePrincipal where !classes.isEmpty || !subjects.isEmpty,
                  .principal where !classes.isEmpty || !subjects.isEmpty:
                throw Abort(.badRequest, reason: "Leadership codes cannot contain teaching scopes.")
            default:
                break
            }
            let code = enrollmentCode()
            let expiresAt = Date().addingTimeInterval(24 * 60 * 60)
            try await db.createEnrollmentCode(
                codeHash: enrollmentCodeHash(code),
                role: payload.role,
                scope: EnrollmentScope(classes: classes, subjects: subjects),
                expiresAt: expiresAt
            )
            return EnrollmentCodeResponse(code: code, role: payload.role, expiresAt: expiresAt)
        }

        v1API.post("assignments") { req async throws -> CreatedRecordResponse in
            guard let user = req.storage[AuthenticatedUserStorageKey.self], user.role != .student else { throw Abort(.forbidden) }
            guard let db = req.application.storage[DatabaseStorageKey.self] else { throw Abort(.internalServerError) }
            let payload = try req.content.decode(AssignmentCreatePayload.self)
            do {
                let id = try await db.createClassAssignment(
                    AssignmentCreation(classID: payload.classId, title: payload.title, instructions: payload.instructions, subject: payload.subject, chapter: payload.chapter, dueAt: payload.dueAt),
                    by: user
                )
                return CreatedRecordResponse(id: id)
            } catch let error as NidanError {
                throw Abort(error.localizedDescription.contains("Unauthorized") ? .forbidden : .badRequest, reason: error.localizedDescription)
            }
        }

        v1API.get("assignments", ":assignmentID", "submissions") { req async throws -> [AssignmentSubmissionResponse] in
            guard let user = req.storage[AuthenticatedUserStorageKey.self], user.role != .student else { throw Abort(.forbidden) }
            guard let db = req.application.storage[DatabaseStorageKey.self],
                  let assignmentID = req.parameters.get("assignmentID", as: UUID.self) else { throw Abort(.badRequest) }
            do {
                return try await db.assignmentSubmissions(assignmentID: assignmentID, for: user).map {
                    AssignmentSubmissionResponse(studentId: $0.studentID, studentName: $0.studentName, status: $0.status, submittedAt: $0.submittedAt, mark: $0.mark, maximumMark: $0.maximumMark, teacherFeedback: $0.teacherFeedback)
                }
            } catch let error as NidanError {
                throw Abort(error.localizedDescription.contains("Unauthorized") ? .forbidden : .badRequest, reason: error.localizedDescription)
            }
        }

        v1API.post("assignments", ":assignmentID", "marks") { req async throws -> HTTPStatus in
            guard let user = req.storage[AuthenticatedUserStorageKey.self], user.role != .student else { throw Abort(.forbidden) }
            guard let db = req.application.storage[DatabaseStorageKey.self],
                  let assignmentID = req.parameters.get("assignmentID", as: UUID.self) else { throw Abort(.badRequest) }
            let payload = try req.content.decode(AssignmentMarkPayload.self)
            do {
                try await db.markAssignment(assignmentID: assignmentID, studentID: payload.studentId, mark: payload.mark, maximumMark: payload.maximumMark, feedback: payload.feedback, by: user)
                return .noContent
            } catch let error as NidanError {
                throw Abort(error.localizedDescription.contains("Unauthorized") ? .forbidden : .badRequest, reason: error.localizedDescription)
            }
        }

        v1API.post("notices") { req async throws -> CreatedRecordResponse in
            guard let user = req.storage[AuthenticatedUserStorageKey.self], user.role != .student else { throw Abort(.forbidden) }
            guard let db = req.application.storage[DatabaseStorageKey.self] else { throw Abort(.internalServerError) }
            let payload = try req.content.decode(NoticeCreatePayload.self)
            do {
                let id = try await db.createSchoolNotice(NoticeCreation(classID: payload.classId, title: payload.title, body: payload.body), by: user)
                return CreatedRecordResponse(id: id)
            } catch let error as NidanError {
                throw Abort(error.localizedDescription.contains("Unauthorized") ? .forbidden : .badRequest, reason: error.localizedDescription)
            }
        }

        v1API.post("chapter-progress") { req async throws -> HTTPStatus in
            guard let user = req.storage[AuthenticatedUserStorageKey.self], user.role != .student else { throw Abort(.forbidden) }
            guard let db = req.application.storage[DatabaseStorageKey.self] else { throw Abort(.internalServerError) }
            let payload = try req.content.decode(ChapterProgressPayload.self)
            do {
                try await db.updateChapterProgress(ChapterProgressUpdate(classID: payload.classId, subject: payload.subject, chapter: payload.chapter, completionPercent: payload.completionPercent), by: user)
                return .noContent
            } catch let error as NidanError {
                throw Abort(error.localizedDescription.contains("Unauthorized") ? .forbidden : .badRequest, reason: error.localizedDescription)
            }
        }

        v1API.post("marks") { req async throws -> CreatedRecordResponse in
            guard let user = req.storage[AuthenticatedUserStorageKey.self], user.role != .student else { throw Abort(.forbidden) }
            guard let db = req.application.storage[DatabaseStorageKey.self] else { throw Abort(.internalServerError) }
            let payload = try req.content.decode(MarkCreatePayload.self)
            do {
                let id = try await db.recordStudentMark(MarkCreation(studentID: payload.studentId, classID: payload.classId, subject: payload.subject, assessmentTitle: payload.assessmentTitle, mark: payload.mark, maximumMark: payload.maximumMark), by: user)
                return CreatedRecordResponse(id: id)
            } catch let error as NidanError {
                throw Abort(error.localizedDescription.contains("Unauthorized") ? .forbidden : .badRequest, reason: error.localizedDescription)
            }
        }

        v1API.post("doubts") { req async throws -> CreatedRecordResponse in
            guard let user = req.storage[AuthenticatedUserStorageKey.self], user.role == .student else { throw Abort(.forbidden) }
            guard let db = req.application.storage[DatabaseStorageKey.self] else { throw Abort(.internalServerError) }
            let payload = try req.content.decode(DoubtCreatePayload.self)
            do {
                let id = try await db.createStudentDoubt(DoubtCreation(classID: payload.classId, subject: payload.subject, topic: payload.topic, message: payload.message), by: user)
                return CreatedRecordResponse(id: id)
            } catch let error as NidanError {
                throw Abort(.badRequest, reason: error.localizedDescription)
            }
        }

        v1API.post("doubts", ":doubtID", "responses") { req async throws -> HTTPStatus in
            guard let user = req.storage[AuthenticatedUserStorageKey.self], user.role != .student else { throw Abort(.forbidden) }
            guard let db = req.application.storage[DatabaseStorageKey.self],
                  let doubtID = req.parameters.get("doubtID", as: UUID.self) else { throw Abort(.badRequest) }
            let payload = try req.content.decode(DoubtResponsePayload.self)
            do {
                try await db.respondToDoubt(doubtID: doubtID, message: payload.message, by: user)
                return .noContent
            } catch let error as NidanError {
                throw Abort(error.localizedDescription.contains("Unauthorized") ? .forbidden : .badRequest, reason: error.localizedDescription)
            }
        }
        
        api.post("onboarding") { req async throws -> Response in
            guard let db = req.application.storage[DatabaseStorageKey.self] else {
                throw Abort(.internalServerError)
            }
            
            // Accept JSON payload from frontend
            struct OnboardingRequest: Content {
                var role: String
                var name: String
                var enrollmentCode: String
                var studentClass: String?
                var division: String?
                var englishTeacher: String?
                var ictTeacher: String?
                var classTeacher: String?
                
                var teacherRole: String?
                var classTeacherOf: String?
                var subjectsTaught: [String]?
                var classesTaught: [String]?
            }
            
            let payload = try req.content.decode(OnboardingRequest.self)

            let name = payload.name.trimmingCharacters(in: .whitespacesAndNewlines)
            let code = payload.enrollmentCode.trimmingCharacters(in: .whitespacesAndNewlines)
            guard (1...120).contains(name.count), (1...128).contains(code.count) else {
                throw Abort(.badRequest, reason: "A name and valid enrollment code are required.")
            }

            let codeHash = enrollmentCodeHash(code)
            let sessionToken = enrollmentCode()
            let sessionTokenHash = enrollmentCodeHash(sessionToken)
            let sessionExpiresAt = Date().addingTimeInterval(TimeInterval(sessionLifetime))
            let enrolled: Bool
            if payload.role == UserRole.student.rawValue {
                guard let studentClass = optionalTrimmed(payload.studentClass), studentClass.count <= 20,
                      let division = optionalTrimmed(payload.division), division.count <= 20 else {
                    throw Abort(.badRequest, reason: "Class and division are required.")
                }

                let student = Student(
                    id: UUID(),
                    name: name,
                    studentClass: studentClass,
                    division: division,
                    englishTeacher: optionalTrimmed(payload.englishTeacher),
                    ictTeacher: optionalTrimmed(payload.ictTeacher),
                    classTeacher: optionalTrimmed(payload.classTeacher)
                )
                enrolled = try await db.enrollStudent(
                    student,
                    codeHash: codeHash,
                    sessionTokenHash: sessionTokenHash,
                    sessionExpiresAt: sessionExpiresAt
                )
            } else if payload.role == UserRole.teacher.rawValue {
                let teacherRole = optionalTrimmed(payload.teacherRole)
                let subjects = (payload.subjectsTaught ?? []).map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
                let classes = (payload.classesTaught ?? []).map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
                guard teacherRole == "Class Teacher" || teacherRole == "Supportive Teacher",
                      subjects.count <= 16, classes.count <= 16,
                      !subjects.isEmpty, !classes.isEmpty,
                      subjects.allSatisfy({ $0.count <= 60 }),
                      classes.allSatisfy({ $0.count <= 60 }),
                      teacherRole != "Class Teacher" || optionalTrimmed(payload.classTeacherOf) != nil else {
                    throw Abort(.badRequest, reason: "Teacher role, subjects, and teaching classes are required.")
                }

                let teacher = Teacher(
                    id: UUID(),
                    name: name,
                    teacherRole: teacherRole,
                    classTeacherOf: optionalTrimmed(payload.classTeacherOf),
                    subjectsTaught: subjects,
                    classesTaught: classes
                )
                enrolled = try await db.enrollTeacher(
                    teacher,
                    codeHash: codeHash,
                    sessionTokenHash: sessionTokenHash,
                    sessionExpiresAt: sessionExpiresAt
                )
            } else if payload.role == UserRole.vicePrincipal.rawValue || payload.role == UserRole.principal.rawValue,
                      let role = UserRole(rawValue: payload.role) {
                enrolled = try await db.enrollSchoolLeader(
                    id: UUID(),
                    name: name,
                    role: role,
                    codeHash: codeHash,
                    sessionTokenHash: sessionTokenHash,
                    sessionExpiresAt: sessionExpiresAt
                )
            } else {
                throw Abort(.badRequest, reason: "Role must be student or teacher.")
            }

            guard enrolled else {
                throw Abort(.unauthorized, reason: "Enrollment code is invalid, expired, already used, or for a different role.")
            }
            
            let response = Response(status: .ok, body: .init(string: "{\"status\": \"success\"}"))
            response.cookies[sessionCookieName] = HTTPCookies.Value(
                string: sessionToken,
                expires: sessionExpiresAt,
                maxAge: sessionLifetime,
                path: "/",
                isSecure: req.application.environment == .production,
                isHTTPOnly: true,
                sameSite: .strict
            )
            return response
        }
        
        // Explicit root route
        app.get { req async throws -> Response in
            try await servePage(req, from: publicDir, named: "index.html")
        }
        
        // Diagnostic route
        app.get("diagnostic") { req async throws -> Response in
            try await servePage(req, from: publicDir, named: "diagnostic.html")
        }

        // Learning route
        app.get("learning") { req async throws -> Response in
            try await servePage(req, from: publicDir, named: "learning.html")
        }

        // Assignments route
        app.get("assignments") { req async throws -> Response in
            try await servePage(req, from: publicDir, named: "assignments.html")
        }

        // Progress route
        app.get("progress") { req async throws -> Response in
            try await servePage(req, from: publicDir, named: "progress.html")
        }

        // Roadmap route
        app.get("roadmap") { req async throws -> Response in
            try await servePage(req, from: publicDir, named: "roadmap.html")
        }

        // Library route
        app.get("library") { req async throws -> Response in
            try await servePage(req, from: publicDir, named: "library.html")
        }

        // Settings route
        app.get("settings") { req async throws -> Response in
            try await servePage(req, from: publicDir, named: "settings.html")
        }

        app.get("teacher.html") { req async throws -> Response in
            try await servePage(req, from: publicDir, named: "teacher.html")
        }

        app.get("leadership.html") { req async throws -> Response in
            try await servePage(req, from: publicDir, named: "leadership.html")
        }
        
        // Catch-all route for SPA fallback to index.html
        app.get(.catchall) { req async throws -> Response in
            try await servePage(req, from: publicDir, named: "index.html")
        }
        
        print("Starting NIDAN Core Server...")
        print("Serving static files from: \(publicDir)")
        
        do {
            try await app.execute()
        } catch {
            print("Execution failed: \(error)")
        }
        try await app.asyncShutdown()
    }
}
