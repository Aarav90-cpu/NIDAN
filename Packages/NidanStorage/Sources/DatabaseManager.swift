import Foundation
import GRDB
import NidanModels
import NidanCore

public struct SessionUser: Sendable {
    public let id: UUID
    public let name: String
    public let role: UserRole
}

public struct DiagnosticQuestionPrompt: Codable, Identifiable, Sendable {
    public let id: UUID
    public let text: String
    public let options: [String]
    public let difficultyLevel: Int
}

public struct DiagnosticAnswerInput: Sendable {
    public let questionID: UUID
    public let answer: String

    public init(questionID: UUID, answer: String) {
        self.questionID = questionID
        self.answer = answer
    }
}

public struct DiagnosticAttemptResult: Codable, Sendable {
    public let attemptID: UUID
    public let score: Int
    public let correctCount: Int
    public let questionCount: Int
    public let state: String
    public let recommendation: String
}

public struct EnrollmentScope: Codable, Sendable {
    public let classes: [String]
    public let subjects: [String]

    public init(classes: [String] = [], subjects: [String] = []) {
        self.classes = classes
        self.subjects = subjects
    }
}

public struct SchoolClassSummary: Codable, Sendable {
    public let id: UUID
    public let name: String
    public let grade: String
    public let division: String
    public let students: [SchoolStudentSummary]
    public let studentCount: Int
    public let averageMarkPercent: Int?
    public let openDoubtCount: Int
    public let pendingWorkCount: Int
    public let chapterCompletionPercent: Int?
}

public struct SchoolStudentSummary: Codable, Sendable {
    public let id: UUID
    public let name: String
}

public struct SchoolNoticeSummary: Codable, Sendable {
    public let id: UUID
    public let title: String
    public let body: String
    public let className: String?
    public let authorName: String
    public let createdAt: Date
}

public struct SchoolAssignmentSummary: Codable, Sendable {
    public let id: UUID
    public let className: String
    public let title: String
    public let instructions: String
    public let subject: String
    public let chapter: String?
    public let dueAt: Date
    public let studentCount: Int
    public let submittedCount: Int
    public let averageMarkPercent: Int?
}

public struct AssignmentSubmissionSummary: Codable, Sendable {
    public let studentID: UUID
    public let studentName: String
    public let status: String
    public let submittedAt: Date?
    public let mark: Int?
    public let maximumMark: Int?
    public let teacherFeedback: String?
}

public struct SchoolMarkSummary: Codable, Sendable {
    public let studentName: String
    public let className: String
    public let subject: String
    public let assessmentTitle: String
    public let mark: Int
    public let maximumMark: Int
    public let recordedAt: Date
}

public struct SchoolDoubtSummary: Codable, Sendable {
    public let id: UUID
    public let studentName: String
    public let className: String
    public let subject: String
    public let topic: String
    public let message: String
    public let status: String
    public let createdAt: Date
}

public struct SchoolChapterSummary: Codable, Sendable {
    public let className: String
    public let subject: String
    public let chapter: String
    public let completionPercent: Int
    public let updatedAt: Date
}

public struct StaffProgressSummary: Codable, Sendable {
    public let teacherName: String
    public let classes: [String]
    public let subjects: [String]
    public let worksheetsCreated: Int
    public let chapterUpdates: Int
    public let marksRecorded: Int
}

public struct SchoolDashboard: Codable, Sendable {
    public let role: UserRole
    public let name: String
    public let classes: [SchoolClassSummary]
    public let notices: [SchoolNoticeSummary]
    public let assignments: [SchoolAssignmentSummary]
    public let marks: [SchoolMarkSummary]
    public let doubts: [SchoolDoubtSummary]
    public let chapters: [SchoolChapterSummary]
    public let staff: [StaffProgressSummary]
}

public struct StudentAssignmentSummary: Codable, Sendable {
    public let id: UUID
    public let title: String
    public let instructions: String
    public let subject: String
    public let chapter: String?
    public let dueAt: Date
    public let status: String
    public let mark: Int?
    public let maximumMark: Int?
    public let teacherFeedback: String?
}

public struct StudentDashboard: Codable, Sendable {
    public let name: String
    public let classes: [StudentClassSummary]
    public let assignments: [StudentAssignmentSummary]
    public let notices: [SchoolNoticeSummary]
    public let marks: [SchoolMarkSummary]
    public let doubts: [StudentDoubtSummary]
    public let diagnosticAttemptCount: Int
    public let latestDiagnosticScore: Int?
}

public struct StudentDoubtSummary: Codable, Sendable {
    public let id: UUID
    public let className: String
    public let subject: String
    public let topic: String
    public let message: String
    public let status: String
    public let createdAt: Date
    public let responseMessage: String?
    public let responseTeacherName: String?
    public let respondedAt: Date?
}

public struct StudentClassSummary: Codable, Sendable {
    public let id: UUID
    public let name: String
}

public struct AssignmentCreation: Sendable {
    public let classID: UUID
    public let title: String
    public let instructions: String
    public let subject: String
    public let chapter: String?
    public let dueAt: Date

    public init(classID: UUID, title: String, instructions: String, subject: String, chapter: String?, dueAt: Date) {
        self.classID = classID
        self.title = title
        self.instructions = instructions
        self.subject = subject
        self.chapter = chapter
        self.dueAt = dueAt
    }
}

public struct NoticeCreation: Sendable {
    public let classID: UUID?
    public let title: String
    public let body: String

    public init(classID: UUID?, title: String, body: String) {
        self.classID = classID
        self.title = title
        self.body = body
    }
}

public struct MarkCreation: Sendable {
    public let studentID: UUID
    public let classID: UUID
    public let subject: String
    public let assessmentTitle: String
    public let mark: Int
    public let maximumMark: Int

    public init(studentID: UUID, classID: UUID, subject: String, assessmentTitle: String, mark: Int, maximumMark: Int) {
        self.studentID = studentID
        self.classID = classID
        self.subject = subject
        self.assessmentTitle = assessmentTitle
        self.mark = mark
        self.maximumMark = maximumMark
    }
}

public struct ChapterProgressUpdate: Sendable {
    public let classID: UUID
    public let subject: String
    public let chapter: String
    public let completionPercent: Int

    public init(classID: UUID, subject: String, chapter: String, completionPercent: Int) {
        self.classID = classID
        self.subject = subject
        self.chapter = chapter
        self.completionPercent = completionPercent
    }
}

public struct DoubtCreation: Sendable {
    public let classID: UUID
    public let subject: String
    public let topic: String
    public let message: String

    public init(classID: UUID, subject: String, topic: String, message: String) {
        self.classID = classID
        self.subject = subject
        self.topic = topic
        self.message = message
    }
}

private struct DiagnosticQuestionSeed: Sendable {
    let id: String
    let text: String
    let options: [String]
    let correctAnswer: String
    let difficultyLevel: Int
}

public final class DatabaseManager: StorageProvider, Sendable {
    private static let diagnosticSubjectID = "10000000-0000-4000-8000-000000000001"
    private static let diagnosticSkillID = "10000000-0000-4000-8000-000000000002"
    private static let diagnosticAssessmentID = "10000000-0000-4000-8000-000000000003"
    private static let diagnosticQuestions = [
        DiagnosticQuestionSeed(id: "10000000-0000-4000-8000-000000000101", text: "Which number is irrational?", options: ["3/4", "0.25", "sqrt(2)", "0.333..."], correctAnswer: "sqrt(2)", difficultyLevel: 1),
        DiagnosticQuestionSeed(id: "10000000-0000-4000-8000-000000000102", text: "Write 0.375 as a fraction in simplest form.", options: ["3/8", "3/5", "5/8", "375/10"], correctAnswer: "3/8", difficultyLevel: 1),
        DiagnosticQuestionSeed(id: "10000000-0000-4000-8000-000000000103", text: "What is the decimal form of 13/40?", options: ["0.0325", "0.325", "3.25", "0.34"], correctAnswer: "0.325", difficultyLevel: 2),
        DiagnosticQuestionSeed(id: "10000000-0000-4000-8000-000000000104", text: "Which statement about 0.1010010001... is correct when the gaps keep increasing?", options: ["It is terminating", "It is repeating", "It is irrational", "It is an integer"], correctAnswer: "It is irrational", difficultyLevel: 2),
        DiagnosticQuestionSeed(id: "10000000-0000-4000-8000-000000000105", text: "Simplify 5sqrt(3) + 2sqrt(3).", options: ["7sqrt(3)", "7sqrt(6)", "10sqrt(3)", "7"], correctAnswer: "7sqrt(3)", difficultyLevel: 3),
        DiagnosticQuestionSeed(id: "10000000-0000-4000-8000-000000000106", text: "Which value is equal to 1/sqrt(5) after rationalising the denominator?", options: ["sqrt(5)", "sqrt(5)/5", "5sqrt(5)", "1/5"], correctAnswer: "sqrt(5)/5", difficultyLevel: 3),
        DiagnosticQuestionSeed(id: "10000000-0000-4000-8000-000000000107", text: "Between which consecutive integers does sqrt(30) lie?", options: ["4 and 5", "5 and 6", "6 and 7", "7 and 8"], correctAnswer: "5 and 6", difficultyLevel: 4),
        DiagnosticQuestionSeed(id: "10000000-0000-4000-8000-000000000108", text: "If x = sqrt(3) + sqrt(2), what is x squared?", options: ["5", "5 + 2sqrt(6)", "6 + sqrt(5)", "sqrt(5)"], correctAnswer: "5 + 2sqrt(6)", difficultyLevel: 5)
    ]

    public let dbPool: DatabasePool
    
    public init(path: String) throws {
        var configuration = Configuration()
        
        // Use our central NidanLogger to log database queries.
        // NidanStorage is aware of NidanCore, but NidanCore is not aware of NidanStorage.
        configuration.prepareDatabase { db in
            db.trace { message in
                CurrentEnvironment.current.logger.debug("SQLite: \(message)")
            }
        }
        
        self.dbPool = try DatabasePool(path: path, configuration: configuration)
        try migrator.migrate(dbPool)
    }
    
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("v1_initial_schema") { db in
            // Old students table... we will leave it for GRDB to execute if it hasn't, 
            // but we'll create the new one in v2
            try db.create(table: "students") { t in
                t.column("id", .text).primaryKey()
                t.column("name", .text).notNull()
                t.column("role", .text).notNull() 
            }
            
            // Table: subjects
            try db.create(table: "subjects") { t in
                t.column("id", .text).primaryKey()
                t.column("name", .text).notNull()
                t.column("description", .text)
            }
            
            // Table: skills
            try db.create(table: "skills") { t in
                t.column("id", .text).primaryKey()
                t.column("name", .text).notNull()
                t.column("subjectId", .text).notNull().references("subjects", onDelete: .cascade)
                t.column("prerequisiteIds", .text)
            }
            
            // Table: assessments
            try db.create(table: "assessments") { t in
                t.column("id", .text).primaryKey()
                t.column("title", .text).notNull()
                t.column("skillId", .text).notNull().references("skills", onDelete: .cascade)
            }
            
            // Table: questions
            try db.create(table: "questions") { t in
                t.column("id", .text).primaryKey()
                t.column("assessmentId", .text).notNull().references("assessments", onDelete: .cascade)
                t.column("body", .text).notNull()
                t.column("type", .text).notNull()
            }
            
            // Table: assignments
            try db.create(table: "assignments") { t in
                t.column("id", .text).primaryKey()
                t.column("studentId", .text).notNull().references("students", onDelete: .cascade)
                t.column("assessmentId", .text).notNull().references("assessments", onDelete: .cascade)
                t.column("dueDate", .datetime).notNull()
                t.column("isCompleted", .boolean).notNull().defaults(to: false)
            }
            
            // Table: submissions
            try db.create(table: "submissions") { t in
                t.column("id", .text).primaryKey()
                t.column("assignmentId", .text).notNull().references("assignments", onDelete: .cascade)
                t.column("submittedAt", .datetime).notNull()
                t.column("score", .double)
            }
            
            // Table: progress
            try db.create(table: "progress") { t in
                t.column("id", .text).primaryKey()
                t.column("studentId", .text).notNull().references("students", onDelete: .cascade)
                t.column("courseId", .text).notNull() 
                t.column("percentComplete", .double).notNull()
            }
            
            // Table: content
            try db.create(table: "content") { t in
                t.column("id", .text).primaryKey()
                t.column("title", .text).notNull()
                t.column("url", .text)
                t.column("body", .text)
                t.column("type", .text).notNull()
            }
            
            // Table: sync_state
            try db.create(table: "sync_state") { t in
                t.column("id", .text).primaryKey()
                t.column("lastSync", .datetime)
                t.column("isSyncing", .boolean).notNull().defaults(to: false)
                t.column("version", .integer).notNull().defaults(to: 1)
            }
            
            // Table: settings
            try db.create(table: "settings") { t in
                t.column("key", .text).primaryKey()
                t.column("value", .text).notNull()
            }
        }
        
        migrator.registerMigration("v2_realistic_schema") { db in
            // Drop old table to replace with flexible users
            try db.drop(table: "students")
            
            try db.create(table: "users") { t in
                t.column("id", .text).primaryKey()
                t.column("name", .text).notNull()
                t.column("role", .text).notNull()
                t.column("studentClass", .text)
                t.column("division", .text)
                t.column("englishTeacher", .text)
                t.column("ictTeacher", .text)
                t.column("classTeacher", .text)
                t.column("teacherRole", .text)
                t.column("classTeacherOf", .text)
                t.column("subjectsTaught", .text) // JSON array string
                t.column("classesTaught", .text) // JSON array string
                t.column("isDeviceOwner", .boolean).notNull().defaults(to: false)
            }
            
            // Re-create assignments to point to users instead of students
            try db.drop(table: "assignments")
            try db.create(table: "assignments") { t in
                t.column("id", .text).primaryKey()
                t.column("studentId", .text).notNull().references("users", onDelete: .cascade)
                t.column("assessmentId", .text).notNull().references("assessments", onDelete: .cascade)
                t.column("dueDate", .datetime).notNull()
                t.column("isCompleted", .boolean).notNull().defaults(to: false)
            }
        }

        migrator.registerMigration("v3_enrollment_codes") { db in
            try db.create(table: "enrollment_codes") { t in
                t.column("codeHash", .text).primaryKey()
                t.column("role", .text).notNull()
                t.column("expiresAt", .datetime).notNull()
                t.column("redeemedAt", .datetime)
            }
        }

        migrator.registerMigration("v4_user_sessions") { db in
            try db.create(table: "user_sessions") { t in
                t.column("tokenHash", .text).primaryKey()
                t.column("userId", .text).notNull().references("users", onDelete: .cascade)
                t.column("expiresAt", .datetime).notNull()
                t.column("revokedAt", .datetime)
            }
        }

        migrator.registerMigration("v5_diagnostic_attempts") { db in
            try db.execute(sql: "ALTER TABLE questions ADD COLUMN optionsJSON TEXT NOT NULL DEFAULT '[]'")
            try db.execute(sql: "ALTER TABLE questions ADD COLUMN correctAnswer TEXT")
            try db.execute(sql: "ALTER TABLE questions ADD COLUMN difficultyLevel INTEGER NOT NULL DEFAULT 50")

            try db.create(table: "assessment_attempts") { t in
                t.column("id", .text).primaryKey()
                t.column("studentId", .text).notNull().references("users", onDelete: .cascade)
                t.column("assessmentId", .text).notNull().references("assessments", onDelete: .cascade)
                t.column("score", .integer).notNull()
                t.column("completedAt", .datetime).notNull()
            }
            try db.create(table: "question_responses") { t in
                t.column("id", .text).primaryKey()
                t.column("attemptId", .text).notNull().references("assessment_attempts", onDelete: .cascade)
                t.column("questionId", .text).notNull().references("questions", onDelete: .cascade)
                t.column("studentId", .text).notNull().references("users", onDelete: .cascade)
                t.column("answerText", .text).notNull()
                t.column("isCorrect", .boolean).notNull()
                t.column("submittedAt", .datetime).notNull()
            }
        }

        migrator.registerMigration("v6_school_management") { db in
            try db.create(table: "school_classes") { t in
                t.column("id", .text).primaryKey()
                t.column("name", .text).notNull().unique()
                t.column("grade", .text).notNull()
                t.column("division", .text).notNull()
            }
            try db.create(table: "class_memberships") { t in
                t.column("studentId", .text).notNull().references("users", onDelete: .cascade)
                t.column("classId", .text).notNull().references("school_classes", onDelete: .cascade)
                t.column("joinedAt", .datetime).notNull()
                t.primaryKey(["studentId", "classId"])
            }
            try db.create(table: "teacher_class_assignments") { t in
                t.column("teacherId", .text).notNull().references("users", onDelete: .cascade)
                t.column("classId", .text).notNull().references("school_classes", onDelete: .cascade)
                t.column("subject", .text).notNull()
                t.primaryKey(["teacherId", "classId", "subject"])
            }
            try db.create(table: "class_assignments") { t in
                t.column("id", .text).primaryKey()
                t.column("classId", .text).notNull().references("school_classes", onDelete: .cascade)
                t.column("createdBy", .text).notNull().references("users", onDelete: .restrict)
                t.column("title", .text).notNull()
                t.column("instructions", .text).notNull()
                t.column("subject", .text).notNull()
                t.column("chapter", .text)
                t.column("dueAt", .datetime).notNull()
                t.column("createdAt", .datetime).notNull()
            }
            try db.create(table: "student_assignment_records") { t in
                t.column("assignmentId", .text).notNull().references("class_assignments", onDelete: .cascade)
                t.column("studentId", .text).notNull().references("users", onDelete: .cascade)
                t.column("status", .text).notNull().defaults(to: "assigned")
                t.column("mark", .integer)
                t.column("teacherFeedback", .text)
                t.column("submittedAt", .datetime)
                t.column("markedAt", .datetime)
                t.primaryKey(["assignmentId", "studentId"])
            }
            try db.create(table: "school_notices") { t in
                t.column("id", .text).primaryKey()
                t.column("authorId", .text).notNull().references("users", onDelete: .restrict)
                t.column("classId", .text).references("school_classes", onDelete: .cascade)
                t.column("title", .text).notNull()
                t.column("body", .text).notNull()
                t.column("createdAt", .datetime).notNull()
            }
            try db.create(table: "chapter_progress") { t in
                t.column("classId", .text).notNull().references("school_classes", onDelete: .cascade)
                t.column("subject", .text).notNull()
                t.column("chapter", .text).notNull()
                t.column("completionPercent", .integer).notNull().defaults(to: 0)
                t.column("updatedBy", .text).notNull().references("users", onDelete: .restrict)
                t.column("updatedAt", .datetime).notNull()
                t.primaryKey(["classId", "subject", "chapter"])
            }
            try db.create(table: "student_marks") { t in
                t.column("id", .text).primaryKey()
                t.column("studentId", .text).notNull().references("users", onDelete: .cascade)
                t.column("classId", .text).notNull().references("school_classes", onDelete: .cascade)
                t.column("enteredBy", .text).notNull().references("users", onDelete: .restrict)
                t.column("subject", .text).notNull()
                t.column("assessmentTitle", .text).notNull()
                t.column("mark", .integer).notNull()
                t.column("maximumMark", .integer).notNull()
                t.column("recordedAt", .datetime).notNull()
            }
            try db.create(table: "student_doubts") { t in
                t.column("id", .text).primaryKey()
                t.column("studentId", .text).notNull().references("users", onDelete: .cascade)
                t.column("classId", .text).notNull().references("school_classes", onDelete: .cascade)
                t.column("subject", .text).notNull()
                t.column("topic", .text).notNull()
                t.column("message", .text).notNull()
                t.column("status", .text).notNull().defaults(to: "open")
                t.column("createdAt", .datetime).notNull()
            }
            try db.create(table: "doubt_responses") { t in
                t.column("id", .text).primaryKey()
                t.column("doubtId", .text).notNull().references("student_doubts", onDelete: .cascade)
                t.column("teacherId", .text).notNull().references("users", onDelete: .restrict)
                t.column("message", .text).notNull()
                t.column("createdAt", .datetime).notNull()
            }

            try db.create(index: "student_assignment_records_by_student", on: "student_assignment_records", columns: ["studentId", "status"])
            try db.create(index: "student_marks_by_class", on: "student_marks", columns: ["classId", "recordedAt"])
            try db.create(index: "student_doubts_by_class", on: "student_doubts", columns: ["classId", "status", "createdAt"])
        }

        migrator.registerMigration("v7_enrollment_scopes") { db in
            try db.execute(sql: "ALTER TABLE enrollment_codes ADD COLUMN scopeJSON TEXT NOT NULL DEFAULT '{\"classes\":[],\"subjects\":[]}'")
        }

        migrator.registerMigration("v8_assignment_mark_maximum") { db in
            try db.execute(sql: "ALTER TABLE student_assignment_records ADD COLUMN maximumMark INTEGER")
        }
        
        return migrator
    }
    
    // MARK: - StorageProvider Implementation
    
    public func getStudent(id: UUID) async throws -> Student? {
        // Implementation stub for now
        return nil
    }

    public func saveStudent(_ student: Student) async throws {
        try await saveStudent(student, isDeviceOwner: false)
    }
    
    public func saveStudent(_ student: Student, isDeviceOwner: Bool) async throws {
        try await dbPool.write { db in
            try db.execute(
                sql: """
                INSERT INTO users (id, name, role, studentClass, division, englishTeacher, ictTeacher, classTeacher, isDeviceOwner) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) 
                ON CONFLICT(id) DO UPDATE SET 
                name=excluded.name, studentClass=excluded.studentClass, division=excluded.division,
                englishTeacher=excluded.englishTeacher, ictTeacher=excluded.ictTeacher, classTeacher=excluded.classTeacher
                """,
                arguments: [student.id.uuidString, student.name, student.role.rawValue, student.studentClass, student.division, student.englishTeacher, student.ictTeacher, student.classTeacher, isDeviceOwner]
            )
        }
    }
    
    public func saveTeacher(_ teacher: Teacher, isDeviceOwner: Bool = false) async throws {
        try await dbPool.write { db in
            let subjectsData = try? JSONEncoder().encode(teacher.subjectsTaught)
            let subjectsString = subjectsData != nil ? String(data: subjectsData!, encoding: .utf8) : nil
            
            let classesData = try? JSONEncoder().encode(teacher.classesTaught)
            let classesString = classesData != nil ? String(data: classesData!, encoding: .utf8) : nil
            
            try db.execute(
                sql: """
                INSERT INTO users (id, name, role, teacherRole, classTeacherOf, subjectsTaught, classesTaught, isDeviceOwner) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?) 
                ON CONFLICT(id) DO UPDATE SET 
                name=excluded.name, teacherRole=excluded.teacherRole, classTeacherOf=excluded.classTeacherOf,
                subjectsTaught=excluded.subjectsTaught, classesTaught=excluded.classesTaught
                """,
                arguments: [teacher.id.uuidString, teacher.name, teacher.role.rawValue, teacher.teacherRole, teacher.classTeacherOf, subjectsString, classesString, isDeviceOwner]
            )
        }
    }

    public func createEnrollmentCode(
        codeHash: String,
        role: UserRole,
        scope: EnrollmentScope = EnrollmentScope(),
        expiresAt: Date
    ) async throws {
        let scopeJSON = String(decoding: try JSONEncoder().encode(scope), as: UTF8.self)
        try await dbPool.write { db in
            try db.execute(
                sql: "INSERT INTO enrollment_codes (codeHash, role, expiresAt, scopeJSON) VALUES (?, ?, ?, ?)",
                arguments: [codeHash, role.rawValue, expiresAt, scopeJSON]
            )
        }
    }

    public func enrollStudent(
        _ student: Student,
        codeHash: String,
        sessionTokenHash: String,
        sessionExpiresAt: Date
    ) async throws -> Bool {
        try await consumeEnrollmentCode(
            codeHash: codeHash,
            role: .student,
            sessionTokenHash: sessionTokenHash,
            sessionExpiresAt: sessionExpiresAt
        ) { db, isDeviceOwner, scope in
            let className = "\(student.studentClass ?? "")\(student.division ?? "")"
            guard scope.classes.contains(className) else {
                throw NidanError.unauthorized("The enrollment code is not approved for this class.")
            }
            let classID = try Self.ensureClass(
                name: className,
                grade: student.studentClass ?? "",
                division: student.division ?? "",
                in: db
            )
            try db.execute(
                sql: "INSERT INTO users (id, name, role, studentClass, division, englishTeacher, ictTeacher, classTeacher, isDeviceOwner) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
                arguments: [student.id.uuidString, student.name, student.role.rawValue, student.studentClass, student.division, student.englishTeacher, student.ictTeacher, student.classTeacher, isDeviceOwner]
            )
            try db.execute(
                sql: "INSERT INTO class_memberships (studentId, classId, joinedAt) VALUES (?, ?, ?)",
                arguments: [student.id.uuidString, classID, Date()]
            )
            return student.id
        }
    }

    public func enrollTeacher(
        _ teacher: Teacher,
        codeHash: String,
        sessionTokenHash: String,
        sessionExpiresAt: Date
    ) async throws -> Bool {
        let subjects = String(decoding: try JSONEncoder().encode(teacher.subjectsTaught ?? []), as: UTF8.self)
        let classes = String(decoding: try JSONEncoder().encode(teacher.classesTaught ?? []), as: UTF8.self)

        return try await consumeEnrollmentCode(
            codeHash: codeHash,
            role: .teacher,
            sessionTokenHash: sessionTokenHash,
            sessionExpiresAt: sessionExpiresAt
        ) { db, isDeviceOwner, scope in
            let requestedClasses = teacher.classesTaught ?? []
            let requestedSubjects = teacher.subjectsTaught ?? []
            guard !requestedClasses.isEmpty,
                  !requestedSubjects.isEmpty,
                  Set(requestedClasses).isSubset(of: Set(scope.classes)),
                  Set(requestedSubjects).isSubset(of: Set(scope.subjects)) else {
                throw NidanError.unauthorized("The enrollment code does not grant the requested teaching scope.")
            }
            try db.execute(
                sql: "INSERT INTO users (id, name, role, teacherRole, classTeacherOf, subjectsTaught, classesTaught, isDeviceOwner) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
                arguments: [teacher.id.uuidString, teacher.name, teacher.role.rawValue, teacher.teacherRole, teacher.classTeacherOf, subjects, classes, isDeviceOwner]
            )
            for className in requestedClasses {
                let (grade, division) = try Self.parseClassName(className)
                let classID = try Self.ensureClass(name: className, grade: grade, division: division, in: db)
                for subject in requestedSubjects {
                    try db.execute(
                        sql: "INSERT INTO teacher_class_assignments (teacherId, classId, subject) VALUES (?, ?, ?)",
                        arguments: [teacher.id.uuidString, classID, subject]
                    )
                }
            }
            return teacher.id
        }
    }

    public func enrollSchoolLeader(
        id: UUID,
        name: String,
        role: UserRole,
        codeHash: String,
        sessionTokenHash: String,
        sessionExpiresAt: Date
    ) async throws -> Bool {
        guard role == .vicePrincipal || role == .principal else { return false }
        return try await consumeEnrollmentCode(
            codeHash: codeHash,
            role: role,
            sessionTokenHash: sessionTokenHash,
            sessionExpiresAt: sessionExpiresAt
        ) { db, isDeviceOwner, scope in
            guard scope.classes.isEmpty, scope.subjects.isEmpty else {
                throw NidanError.validationFailed("Leadership enrollment codes must not contain teacher scopes.")
            }
            try db.execute(
                sql: "INSERT INTO users (id, name, role, isDeviceOwner) VALUES (?, ?, ?, ?)",
                arguments: [id.uuidString, name, role.rawValue, isDeviceOwner]
            )
            return id
        }
    }

    public func authenticatedUser(sessionTokenHash: String, now: Date = Date()) async throws -> SessionUser? {
        try await dbPool.read { db in
            guard let row = try Row.fetchOne(
                db,
                sql: "SELECT users.id, users.name, users.role FROM user_sessions JOIN users ON users.id = user_sessions.userId WHERE user_sessions.tokenHash = ? AND user_sessions.revokedAt IS NULL AND user_sessions.expiresAt > ?",
                arguments: [sessionTokenHash, now]
            ),
            let idString: String = row["id"],
            let id = UUID(uuidString: idString),
            let name: String = row["name"],
            let roleString: String = row["role"],
            let role = UserRole(rawValue: roleString) else {
                return nil
            }

            return SessionUser(id: id, name: name, role: role)
        }
    }

    public func schoolDashboard(for user: SessionUser) async throws -> SchoolDashboard {
        guard user.role != .student else {
            throw NidanError.unauthorized("Student dashboards use student-specific APIs.")
        }

        return try await dbPool.read { db in
            let classRows: [Row]
            if user.role == .teacher {
                classRows = try Row.fetchAll(
                    db,
                    sql: "SELECT DISTINCT c.id, c.name, c.grade, c.division FROM school_classes c JOIN teacher_class_assignments tca ON tca.classId = c.id WHERE tca.teacherId = ? ORDER BY c.grade, c.division",
                    arguments: [user.id.uuidString]
                )
            } else {
                classRows = try Row.fetchAll(db, sql: "SELECT id, name, grade, division FROM school_classes ORDER BY grade, division")
            }

            var classIDs: [String] = []
            var classNames: [String: String] = [:]
            var classSummaries: [SchoolClassSummary] = []
            var assignments: [SchoolAssignmentSummary] = []
            var marks: [SchoolMarkSummary] = []
            var doubts: [SchoolDoubtSummary] = []
            var chapters: [SchoolChapterSummary] = []

            for row in classRows {
                guard let id: String = row["id"],
                      let uuid = UUID(uuidString: id),
                      let name: String = row["name"],
                      let grade: String = row["grade"],
                      let division: String = row["division"] else { continue }
                classIDs.append(id)
                classNames[id] = name

                let studentCount = try Int.fetchOne(
                    db,
                    sql: "SELECT COUNT(*) FROM class_memberships WHERE classId = ?",
                    arguments: [id]
                ) ?? 0
                let rosterRows = try Row.fetchAll(
                    db,
                    sql: "SELECT u.id, u.name FROM class_memberships m JOIN users u ON u.id = m.studentId WHERE m.classId = ? ORDER BY u.name",
                    arguments: [id]
                )
                let students = rosterRows.compactMap { rosterRow -> SchoolStudentSummary? in
                    guard let studentID: String = rosterRow["id"],
                          let studentUUID = UUID(uuidString: studentID),
                          let studentName: String = rosterRow["name"] else { return nil }
                    return SchoolStudentSummary(id: studentUUID, name: studentName)
                }
                let averageMark = try Int.fetchOne(
                    db,
                    sql: "SELECT CAST(AVG(mark * 100.0 / maximumMark) AS INTEGER) FROM student_marks WHERE classId = ? AND maximumMark > 0 AND (? != 'teacher' OR subject IN (SELECT subject FROM teacher_class_assignments WHERE teacherId = ? AND classId = ?))",
                    arguments: [id, user.role.rawValue, user.id.uuidString, id]
                )
                let openDoubts = try Int.fetchOne(
                    db,
                    sql: "SELECT COUNT(*) FROM student_doubts WHERE classId = ? AND status = 'open' AND (? != 'teacher' OR subject IN (SELECT subject FROM teacher_class_assignments WHERE teacherId = ? AND classId = ?))",
                    arguments: [id, user.role.rawValue, user.id.uuidString, id]
                ) ?? 0
                let pendingWork = try Int.fetchOne(
                    db,
                    sql: "SELECT COUNT(*) FROM student_assignment_records r JOIN class_assignments a ON a.id = r.assignmentId WHERE a.classId = ? AND r.status = 'assigned' AND (? != 'teacher' OR a.subject IN (SELECT subject FROM teacher_class_assignments WHERE teacherId = ? AND classId = ?))",
                    arguments: [id, user.role.rawValue, user.id.uuidString, id]
                ) ?? 0
                let chapterAverage = try Int.fetchOne(
                    db,
                    sql: "SELECT CAST(AVG(completionPercent) AS INTEGER) FROM chapter_progress WHERE classId = ? AND (? != 'teacher' OR subject IN (SELECT subject FROM teacher_class_assignments WHERE teacherId = ? AND classId = ?))",
                    arguments: [id, user.role.rawValue, user.id.uuidString, id]
                )
                classSummaries.append(SchoolClassSummary(
                    id: uuid,
                    name: name,
                    grade: grade,
                    division: division,
                    students: students,
                    studentCount: studentCount,
                    averageMarkPercent: averageMark,
                    openDoubtCount: openDoubts,
                    pendingWorkCount: pendingWork,
                    chapterCompletionPercent: chapterAverage
                ))

                let assignmentRows = try Row.fetchAll(
                    db,
                    sql: "SELECT a.id, a.title, a.instructions, a.subject, a.chapter, a.dueAt, COUNT(r.studentId) AS studentCount, SUM(CASE WHEN r.status IN ('submitted', 'marked') THEN 1 ELSE 0 END) AS submittedCount, CAST(AVG(CASE WHEN r.mark IS NOT NULL AND r.maximumMark > 0 THEN r.mark * 100.0 / r.maximumMark END) AS INTEGER) AS averageMark FROM class_assignments a LEFT JOIN student_assignment_records r ON r.assignmentId = a.id WHERE a.classId = ? AND (? != 'teacher' OR a.subject IN (SELECT subject FROM teacher_class_assignments WHERE teacherId = ? AND classId = ?)) GROUP BY a.id ORDER BY a.dueAt LIMIT 100",
                    arguments: [id, user.role.rawValue, user.id.uuidString, id]
                )
                for assignment in assignmentRows {
                    guard let assignmentID: String = assignment["id"],
                          let assignmentUUID = UUID(uuidString: assignmentID),
                          let title: String = assignment["title"],
                          let instructions: String = assignment["instructions"],
                          let subject: String = assignment["subject"],
                          let dueAt: Date = assignment["dueAt"] else { continue }
                    assignments.append(SchoolAssignmentSummary(
                        id: assignmentUUID,
                        className: name,
                        title: title,
                        instructions: instructions,
                        subject: subject,
                        chapter: assignment["chapter"],
                        dueAt: dueAt,
                        studentCount: assignment["studentCount"] ?? 0,
                        submittedCount: assignment["submittedCount"] ?? 0,
                        averageMarkPercent: assignment["averageMark"]
                    ))
                }

                let markRows = try Row.fetchAll(
                    db,
                    sql: "SELECT u.name AS studentName, m.subject, m.assessmentTitle, m.mark, m.maximumMark, m.recordedAt FROM student_marks m JOIN users u ON u.id = m.studentId WHERE m.classId = ? AND (? != 'teacher' OR m.subject IN (SELECT subject FROM teacher_class_assignments WHERE teacherId = ? AND classId = ?)) ORDER BY m.recordedAt DESC LIMIT 100",
                    arguments: [id, user.role.rawValue, user.id.uuidString, id]
                )
                for mark in markRows {
                    guard let studentName: String = mark["studentName"],
                          let subject: String = mark["subject"],
                          let assessmentTitle: String = mark["assessmentTitle"],
                          let value: Int = mark["mark"],
                          let maximum: Int = mark["maximumMark"],
                          let recordedAt: Date = mark["recordedAt"] else { continue }
                    marks.append(SchoolMarkSummary(studentName: studentName, className: name, subject: subject, assessmentTitle: assessmentTitle, mark: value, maximumMark: maximum, recordedAt: recordedAt))
                }

                let doubtRows = try Row.fetchAll(
                    db,
                    sql: "SELECT d.id, u.name AS studentName, d.subject, d.topic, d.message, d.status, d.createdAt FROM student_doubts d JOIN users u ON u.id = d.studentId WHERE d.classId = ? AND (? != 'teacher' OR d.subject IN (SELECT subject FROM teacher_class_assignments WHERE teacherId = ? AND classId = ?)) ORDER BY CASE d.status WHEN 'open' THEN 0 ELSE 1 END, d.createdAt DESC LIMIT 100",
                    arguments: [id, user.role.rawValue, user.id.uuidString, id]
                )
                for doubt in doubtRows {
                    guard let doubtID: String = doubt["id"],
                          let doubtUUID = UUID(uuidString: doubtID),
                          let studentName: String = doubt["studentName"],
                          let subject: String = doubt["subject"],
                          let topic: String = doubt["topic"],
                          let message: String = doubt["message"],
                          let status: String = doubt["status"],
                          let createdAt: Date = doubt["createdAt"] else { continue }
                    doubts.append(SchoolDoubtSummary(id: doubtUUID, studentName: studentName, className: name, subject: subject, topic: topic, message: message, status: status, createdAt: createdAt))
                }

                let chapterRows = try Row.fetchAll(
                    db,
                    sql: "SELECT subject, chapter, completionPercent, updatedAt FROM chapter_progress WHERE classId = ? AND (? != 'teacher' OR subject IN (SELECT subject FROM teacher_class_assignments WHERE teacherId = ? AND classId = ?)) ORDER BY subject, chapter",
                    arguments: [id, user.role.rawValue, user.id.uuidString, id]
                )
                for chapter in chapterRows {
                    guard let subject: String = chapter["subject"],
                          let title: String = chapter["chapter"],
                          let percent: Int = chapter["completionPercent"],
                          let updatedAt: Date = chapter["updatedAt"] else { continue }
                    chapters.append(SchoolChapterSummary(className: name, subject: subject, chapter: title, completionPercent: percent, updatedAt: updatedAt))
                }
            }

            let noticeRows = try Row.fetchAll(
                db,
                sql: "SELECT n.id, n.title, n.body, n.classId, u.name AS authorName, n.createdAt FROM school_notices n JOIN users u ON u.id = n.authorId ORDER BY n.createdAt DESC LIMIT 100"
            )
            let notices = noticeRows.compactMap { row -> SchoolNoticeSummary? in
                guard let id: String = row["id"], let uuid = UUID(uuidString: id),
                      let title: String = row["title"], let body: String = row["body"],
                      let authorName: String = row["authorName"], let createdAt: Date = row["createdAt"] else { return nil }
                let classID: String? = row["classId"]
                if let classID, !classIDs.contains(classID) { return nil }
                return SchoolNoticeSummary(id: uuid, title: title, body: body, className: classID.flatMap { classNames[$0] }, authorName: authorName, createdAt: createdAt)
            }

            let staffRows = try Row.fetchAll(
                db,
                sql: "SELECT u.id, u.name, (SELECT group_concat(DISTINCT c.name) FROM teacher_class_assignments tca JOIN school_classes c ON c.id = tca.classId WHERE tca.teacherId = u.id) AS classNames, (SELECT group_concat(DISTINCT tca.subject) FROM teacher_class_assignments tca WHERE tca.teacherId = u.id) AS subjects, (SELECT COUNT(*) FROM class_assignments a WHERE a.createdBy = u.id) AS worksheetsCreated, (SELECT COUNT(*) FROM chapter_progress cp WHERE cp.updatedBy = u.id) AS chapterUpdates, (SELECT COUNT(*) FROM student_marks sm WHERE sm.enteredBy = u.id) AS marksRecorded FROM users u WHERE u.role = 'teacher' AND (? != 'teacher' OR u.id = ?) ORDER BY u.name LIMIT 200",
                arguments: [user.role.rawValue, user.id.uuidString]
            )
            let staff = staffRows.compactMap { row -> StaffProgressSummary? in
                guard let name: String = row["name"] else { return nil }
                let classesValue: String? = row["classNames"]
                let subjectsValue: String? = row["subjects"]
                return StaffProgressSummary(
                    teacherName: name,
                    classes: classesValue?.split(separator: ",").map(String.init) ?? [],
                    subjects: subjectsValue?.split(separator: ",").map(String.init) ?? [],
                    worksheetsCreated: row["worksheetsCreated"] ?? 0,
                    chapterUpdates: row["chapterUpdates"] ?? 0,
                    marksRecorded: row["marksRecorded"] ?? 0
                )
            }

            return SchoolDashboard(role: user.role, name: user.name, classes: classSummaries, notices: notices, assignments: assignments, marks: marks, doubts: doubts, chapters: chapters, staff: staff)
        }
    }

    public func studentDashboard(for student: SessionUser) async throws -> StudentDashboard {
        guard student.role == .student else { throw NidanError.unauthorized("Student role is required.") }
        return try await dbPool.read { db in
            let classRows = try Row.fetchAll(
                db,
                sql: "SELECT c.id, c.name FROM class_memberships m JOIN school_classes c ON c.id = m.classId WHERE m.studentId = ? ORDER BY c.grade, c.division",
                arguments: [student.id.uuidString]
            )
            let classIDs = classRows.compactMap { $0["id"] as String? }
            let classes = classRows.compactMap { row -> StudentClassSummary? in
                guard let idString: String = row["id"], let id = UUID(uuidString: idString),
                      let name: String = row["name"] else { return nil }
                return StudentClassSummary(id: id, name: name)
            }
            guard !classIDs.isEmpty else {
                let attemptCount = try Int.fetchOne(db, sql: "SELECT COUNT(*) FROM assessment_attempts WHERE studentId = ?", arguments: [student.id.uuidString]) ?? 0
                let latestScore = try Int.fetchOne(db, sql: "SELECT score FROM assessment_attempts WHERE studentId = ? ORDER BY completedAt DESC LIMIT 1", arguments: [student.id.uuidString])
                return StudentDashboard(name: student.name, classes: [], assignments: [], notices: [], marks: [], doubts: [], diagnosticAttemptCount: attemptCount, latestDiagnosticScore: latestScore)
            }

            let assignmentRows = try Row.fetchAll(
                db,
                sql: "SELECT a.id, a.title, a.instructions, a.subject, a.chapter, a.dueAt, r.status, r.mark, r.maximumMark, r.teacherFeedback FROM student_assignment_records r JOIN class_assignments a ON a.id = r.assignmentId WHERE r.studentId = ? ORDER BY a.dueAt LIMIT 100",
                arguments: [student.id.uuidString]
            )
            let assignments = assignmentRows.compactMap { row -> StudentAssignmentSummary? in
                guard let idString: String = row["id"], let id = UUID(uuidString: idString),
                      let title: String = row["title"], let instructions: String = row["instructions"],
                      let subject: String = row["subject"], let dueAt: Date = row["dueAt"],
                      let status: String = row["status"] else { return nil }
                return StudentAssignmentSummary(id: id, title: title, instructions: instructions, subject: subject, chapter: row["chapter"], dueAt: dueAt, status: status, mark: row["mark"], maximumMark: row["maximumMark"], teacherFeedback: row["teacherFeedback"])
            }

            let noticeRows = try Row.fetchAll(
                db,
                sql: "SELECT n.id, n.title, n.body, n.classId, u.name AS authorName, n.createdAt FROM school_notices n JOIN users u ON u.id = n.authorId WHERE n.classId IS NULL OR n.classId IN (SELECT classId FROM class_memberships WHERE studentId = ?) ORDER BY n.createdAt DESC LIMIT 100",
                arguments: [student.id.uuidString]
            )
            let notices = noticeRows.compactMap { row -> SchoolNoticeSummary? in
                guard let idString: String = row["id"], let id = UUID(uuidString: idString),
                      let title: String = row["title"], let body: String = row["body"],
                      let authorName: String = row["authorName"], let createdAt: Date = row["createdAt"] else { return nil }
                let classID: String? = row["classId"]
                let className = classID.flatMap { id in
                    classRows.first(where: { ($0["id"] as String?) == id })?[
                        "name"
                    ] as String?
                }
                return SchoolNoticeSummary(id: id, title: title, body: body, className: className, authorName: authorName, createdAt: createdAt)
            }

            let markRows = try Row.fetchAll(
                db,
                sql: "SELECT c.name AS className, subject, assessmentTitle, mark, maximumMark, recordedAt FROM student_marks m JOIN school_classes c ON c.id = m.classId WHERE studentId = ? ORDER BY recordedAt DESC LIMIT 100",
                arguments: [student.id.uuidString]
            )
            let marks = markRows.compactMap { row -> SchoolMarkSummary? in
                guard let className: String = row["className"], let subject: String = row["subject"],
                      let assessmentTitle: String = row["assessmentTitle"], let mark: Int = row["mark"],
                      let maximumMark: Int = row["maximumMark"], let recordedAt: Date = row["recordedAt"] else { return nil }
                return SchoolMarkSummary(studentName: student.name, className: className, subject: subject, assessmentTitle: assessmentTitle, mark: mark, maximumMark: maximumMark, recordedAt: recordedAt)
            }

            let doubtRows = try Row.fetchAll(
                db,
                sql: "SELECT d.id, c.name AS className, d.subject, d.topic, d.message, d.status, d.createdAt, (SELECT dr.message FROM doubt_responses dr WHERE dr.doubtId = d.id ORDER BY dr.createdAt DESC LIMIT 1) AS responseMessage, (SELECT u.name FROM doubt_responses dr JOIN users u ON u.id = dr.teacherId WHERE dr.doubtId = d.id ORDER BY dr.createdAt DESC LIMIT 1) AS responseTeacherName, (SELECT dr.createdAt FROM doubt_responses dr WHERE dr.doubtId = d.id ORDER BY dr.createdAt DESC LIMIT 1) AS respondedAt FROM student_doubts d JOIN school_classes c ON c.id = d.classId WHERE d.studentId = ? ORDER BY d.createdAt DESC LIMIT 100",
                arguments: [student.id.uuidString]
            )
            let doubts = doubtRows.compactMap { row -> StudentDoubtSummary? in
                guard let idString: String = row["id"], let id = UUID(uuidString: idString),
                      let className: String = row["className"], let subject: String = row["subject"],
                      let topic: String = row["topic"], let message: String = row["message"],
                      let status: String = row["status"], let createdAt: Date = row["createdAt"] else { return nil }
                return StudentDoubtSummary(id: id, className: className, subject: subject, topic: topic, message: message, status: status, createdAt: createdAt, responseMessage: row["responseMessage"], responseTeacherName: row["responseTeacherName"], respondedAt: row["respondedAt"])
            }
            let attemptCount = try Int.fetchOne(db, sql: "SELECT COUNT(*) FROM assessment_attempts WHERE studentId = ?", arguments: [student.id.uuidString]) ?? 0
            let latestScore = try Int.fetchOne(db, sql: "SELECT score FROM assessment_attempts WHERE studentId = ? ORDER BY completedAt DESC LIMIT 1", arguments: [student.id.uuidString])
            return StudentDashboard(name: student.name, classes: classes, assignments: assignments, notices: notices, marks: marks, doubts: doubts, diagnosticAttemptCount: attemptCount, latestDiagnosticScore: latestScore)
        }
    }

    public func createClassAssignment(_ assignment: AssignmentCreation, by user: SessionUser, now: Date = Date()) async throws -> UUID {
        guard user.role != .vicePrincipal && user.role != .student else {
            throw NidanError.unauthorized("Only teachers and principals may create academic assignments.")
        }
        guard (1...160).contains(assignment.title.trimmingCharacters(in: .whitespacesAndNewlines).count),
              (1...4000).contains(assignment.instructions.trimmingCharacters(in: .whitespacesAndNewlines).count),
              (1...60).contains(assignment.subject.trimmingCharacters(in: .whitespacesAndNewlines).count),
              assignment.dueAt > now else {
            throw NidanError.validationFailed("Assignment details are invalid or the due date has passed.")
        }
        let assignmentID = UUID()
        try await dbPool.write { db in
            try Self.requireClassAccess(db, user: user, classID: assignment.classID, subject: assignment.subject)
            try db.execute(
                sql: "INSERT INTO class_assignments (id, classId, createdBy, title, instructions, subject, chapter, dueAt, createdAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
                arguments: [assignmentID.uuidString, assignment.classID.uuidString, user.id.uuidString, assignment.title.trimmingCharacters(in: .whitespacesAndNewlines), assignment.instructions.trimmingCharacters(in: .whitespacesAndNewlines), assignment.subject.trimmingCharacters(in: .whitespacesAndNewlines), assignment.chapter, assignment.dueAt, now]
            )
            try db.execute(
                sql: "INSERT INTO student_assignment_records (assignmentId, studentId) SELECT ?, studentId FROM class_memberships WHERE classId = ?",
                arguments: [assignmentID.uuidString, assignment.classID.uuidString]
            )
        }
        return assignmentID
    }

    public func assignmentSubmissions(assignmentID: UUID, for user: SessionUser) async throws -> [AssignmentSubmissionSummary] {
        try await dbPool.read { db in
            guard let assignment = try Row.fetchOne(
                db,
                sql: "SELECT classId, subject FROM class_assignments WHERE id = ?",
                arguments: [assignmentID.uuidString]
            ), let classIDString: String = assignment["classId"],
               let classID = UUID(uuidString: classIDString),
               let subject: String = assignment["subject"] else {
                throw NidanError.notFound("Assignment not found.")
            }
            try Self.requireClassAccess(db, user: user, classID: classID, subject: subject)
            let rows = try Row.fetchAll(
                db,
                sql: "SELECT u.id AS studentId, u.name AS studentName, r.status, r.submittedAt, r.mark, r.maximumMark, r.teacherFeedback FROM student_assignment_records r JOIN users u ON u.id = r.studentId WHERE r.assignmentId = ? AND (? != 'teacher' OR EXISTS (SELECT 1 FROM class_memberships cm WHERE cm.classId = ? AND cm.studentId = r.studentId)) ORDER BY u.name LIMIT 500",
                arguments: [assignmentID.uuidString, user.role.rawValue, classIDString]
            )
            return rows.compactMap { row in
                guard let studentIDString: String = row["studentId"],
                      let studentID = UUID(uuidString: studentIDString),
                      let studentName: String = row["studentName"],
                      let status: String = row["status"] else { return nil }
                return AssignmentSubmissionSummary(studentID: studentID, studentName: studentName, status: status, submittedAt: row["submittedAt"], mark: row["mark"], maximumMark: row["maximumMark"], teacherFeedback: row["teacherFeedback"])
            }
        }
    }

    public func submitPaperAssignment(assignmentID: UUID, by student: SessionUser, at date: Date = Date()) async throws {
        guard student.role == .student else { throw NidanError.unauthorized("Only students can submit their assigned work.") }
        try await dbPool.write { db in
            try db.execute(
                sql: "UPDATE student_assignment_records SET status = 'submitted', submittedAt = ? WHERE assignmentId = ? AND studentId = ? AND status = 'assigned' AND EXISTS (SELECT 1 FROM class_assignments a JOIN class_memberships m ON m.classId = a.classId WHERE a.id = student_assignment_records.assignmentId AND m.studentId = student_assignment_records.studentId)",
                arguments: [date, assignmentID.uuidString, student.id.uuidString]
            )
            guard db.changesCount == 1 else { throw NidanError.notFound("The assigned work is unavailable or already submitted.") }
        }
    }

    public func markAssignment(
        assignmentID: UUID,
        studentID: UUID,
        mark: Int,
        maximumMark: Int,
        feedback: String?,
        by teacher: SessionUser,
        at date: Date = Date()
    ) async throws {
        guard teacher.role == .teacher || teacher.role == .principal else {
            throw NidanError.unauthorized("Only the assigned teacher or principal may mark an assignment.")
        }
        guard maximumMark > 0, maximumMark <= 1000, mark >= 0, mark <= maximumMark,
              (feedback?.count ?? 0) <= 2000 else {
            throw NidanError.validationFailed("The mark or feedback is outside the allowed range.")
        }
        try await dbPool.write { db in
            guard let assignment = try Row.fetchOne(
                db,
                sql: "SELECT classId, subject, title FROM class_assignments WHERE id = ?",
                arguments: [assignmentID.uuidString]
            ), let classIDString: String = assignment["classId"],
               let classID = UUID(uuidString: classIDString),
               let subject: String = assignment["subject"],
               let assignmentTitle: String = assignment["title"] else {
                throw NidanError.notFound("Assignment not found.")
            }
            try Self.requireClassAccess(db, user: teacher, classID: classID, subject: subject)
            try db.execute(
                sql: "UPDATE student_assignment_records SET status = 'marked', mark = ?, maximumMark = ?, teacherFeedback = ?, markedAt = ? WHERE assignmentId = ? AND studentId = ? AND status = 'submitted'",
                arguments: [mark, maximumMark, feedback, date, assignmentID.uuidString, studentID.uuidString]
            )
            guard db.changesCount == 1 else { throw NidanError.notFound("A submitted worksheet for this student was not found.") }
            try db.execute(
                sql: "INSERT INTO student_marks (id, studentId, classId, enteredBy, subject, assessmentTitle, mark, maximumMark, recordedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
                arguments: [UUID().uuidString, studentID.uuidString, classID.uuidString, teacher.id.uuidString, subject, assignmentTitle, mark, maximumMark, date]
            )
        }
    }

    public func createSchoolNotice(_ notice: NoticeCreation, by author: SessionUser, at date: Date = Date()) async throws -> UUID {
        let title = notice.title.trimmingCharacters(in: .whitespacesAndNewlines)
        let body = notice.body.trimmingCharacters(in: .whitespacesAndNewlines)
        guard (1...160).contains(title.count), (1...4000).contains(body.count), author.role != .student else {
            throw NidanError.validationFailed("Notice details are invalid or the role cannot publish notices.")
        }
        let id = UUID()
        try await dbPool.write { db in
            if author.role == .vicePrincipal && notice.classID == nil {
                throw NidanError.unauthorized("Vice-principals may publish class notices; only the principal may publish school-wide notices.")
            }
            if let classID = notice.classID {
                try Self.requireClassAccess(db, user: author, classID: classID, subject: nil)
            } else if author.role == .teacher {
                throw NidanError.unauthorized("Teachers must target a class they teach.")
            }
            try db.execute(
                sql: "INSERT INTO school_notices (id, authorId, classId, title, body, createdAt) VALUES (?, ?, ?, ?, ?, ?)",
                arguments: [id.uuidString, author.id.uuidString, notice.classID?.uuidString, title, body, date]
            )
        }
        return id
    }

    public func recordStudentMark(_ record: MarkCreation, by teacher: SessionUser, at date: Date = Date()) async throws -> UUID {
        guard teacher.role == .teacher || teacher.role == .principal else {
            throw NidanError.unauthorized("Only teachers and principals may record marks.")
        }
        guard record.maximumMark > 0, record.maximumMark <= 1000,
              (0...record.maximumMark).contains(record.mark),
              (1...60).contains(record.subject.count),
              (1...160).contains(record.assessmentTitle.count) else {
            throw NidanError.validationFailed("Mark details are invalid.")
        }
        let id = UUID()
        try await dbPool.write { db in
            try Self.requireClassAccess(db, user: teacher, classID: record.classID, subject: record.subject)
            guard try Int.fetchOne(
                db,
                sql: "SELECT COUNT(*) FROM class_memberships WHERE classId = ? AND studentId = ?",
                arguments: [record.classID.uuidString, record.studentID.uuidString]
            ) == 1 else {
                throw NidanError.notFound("Student is not in this class.")
            }
            try db.execute(
                sql: "INSERT INTO student_marks (id, studentId, classId, enteredBy, subject, assessmentTitle, mark, maximumMark, recordedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
                arguments: [id.uuidString, record.studentID.uuidString, record.classID.uuidString, teacher.id.uuidString, record.subject, record.assessmentTitle, record.mark, record.maximumMark, date]
            )
        }
        return id
    }

    public func updateChapterProgress(_ update: ChapterProgressUpdate, by teacher: SessionUser, at date: Date = Date()) async throws {
        guard teacher.role == .teacher || teacher.role == .principal else {
            throw NidanError.unauthorized("Only teachers and principals may update chapter coverage.")
        }
        guard (0...100).contains(update.completionPercent),
              (1...60).contains(update.subject.count),
              (1...160).contains(update.chapter.count) else {
            throw NidanError.validationFailed("Chapter progress details are invalid.")
        }
        try await dbPool.write { db in
            try Self.requireClassAccess(db, user: teacher, classID: update.classID, subject: update.subject)
            try db.execute(
                sql: "INSERT INTO chapter_progress (classId, subject, chapter, completionPercent, updatedBy, updatedAt) VALUES (?, ?, ?, ?, ?, ?) ON CONFLICT(classId, subject, chapter) DO UPDATE SET completionPercent = excluded.completionPercent, updatedBy = excluded.updatedBy, updatedAt = excluded.updatedAt",
                arguments: [update.classID.uuidString, update.subject, update.chapter, update.completionPercent, teacher.id.uuidString, date]
            )
        }
    }

    public func createStudentDoubt(_ doubt: DoubtCreation, by student: SessionUser, at date: Date = Date()) async throws -> UUID {
        let topic = doubt.topic.trimmingCharacters(in: .whitespacesAndNewlines)
        let message = doubt.message.trimmingCharacters(in: .whitespacesAndNewlines)
        guard student.role == .student,
              (1...120).contains(topic.count), (1...2000).contains(message.count),
              (1...60).contains(doubt.subject.count) else {
            throw NidanError.validationFailed("Doubt details are invalid.")
        }
        let id = UUID()
        try await dbPool.write { db in
            guard try Int.fetchOne(
                db,
                sql: "SELECT COUNT(*) FROM class_memberships WHERE classId = ? AND studentId = ?",
                arguments: [doubt.classID.uuidString, student.id.uuidString]
            ) == 1 else {
                throw NidanError.unauthorized("Students may only ask questions in their own class.")
            }
            let assignedTeachers = try Int.fetchOne(
                db,
                sql: "SELECT COUNT(*) FROM teacher_class_assignments WHERE classId = ? AND subject = ?",
                arguments: [doubt.classID.uuidString, doubt.subject]
            ) ?? 0
            guard assignedTeachers > 0 else {
                throw NidanError.validationFailed("No teacher is assigned to this subject in the selected class.")
            }
            try db.execute(
                sql: "INSERT INTO student_doubts (id, studentId, classId, subject, topic, message, createdAt) VALUES (?, ?, ?, ?, ?, ?, ?)",
                arguments: [id.uuidString, student.id.uuidString, doubt.classID.uuidString, doubt.subject, topic, message, date]
            )
        }
        return id
    }

    public func respondToDoubt(doubtID: UUID, message: String, by teacher: SessionUser, at date: Date = Date()) async throws {
        let response = message.trimmingCharacters(in: .whitespacesAndNewlines)
        guard (1...2000).contains(response.count), teacher.role != .student else {
            throw NidanError.validationFailed("A teacher response is required.")
        }
        try await dbPool.write { db in
            guard let doubt = try Row.fetchOne(
                db,
                sql: "SELECT classId, subject FROM student_doubts WHERE id = ? AND status = 'open'",
                arguments: [doubtID.uuidString]
            ), let classIDString: String = doubt["classId"],
               let classID = UUID(uuidString: classIDString),
               let subject: String = doubt["subject"] else {
                throw NidanError.notFound("Open doubt not found.")
            }
            try Self.requireClassAccess(db, user: teacher, classID: classID, subject: subject)
            try db.execute(
                sql: "INSERT INTO doubt_responses (id, doubtId, teacherId, message, createdAt) VALUES (?, ?, ?, ?, ?)",
                arguments: [UUID().uuidString, doubtID.uuidString, teacher.id.uuidString, response, date]
            )
            try db.execute(sql: "UPDATE student_doubts SET status = 'answered' WHERE id = ?", arguments: [doubtID.uuidString])
        }
    }

    private static func requireClassAccess(_ db: Database, user: SessionUser, classID: UUID, subject: String?) throws {
        switch user.role {
        case .principal, .vicePrincipal:
            return
        case .teacher:
            let count: Int
            if let subject {
                count = try Int.fetchOne(
                    db,
                    sql: "SELECT COUNT(*) FROM teacher_class_assignments WHERE teacherId = ? AND classId = ? AND subject = ?",
                    arguments: [user.id.uuidString, classID.uuidString, subject]
                ) ?? 0
            } else {
                count = try Int.fetchOne(
                    db,
                    sql: "SELECT COUNT(*) FROM teacher_class_assignments WHERE teacherId = ? AND classId = ?",
                    arguments: [user.id.uuidString, classID.uuidString]
                ) ?? 0
            }
            guard count > 0 else { throw NidanError.unauthorized("This class or subject is outside the teacher's assignment.") }
        case .student:
            throw NidanError.unauthorized("Student role cannot perform this staff action.")
        }
    }

    public func revokeSession(sessionTokenHash: String, at date: Date = Date()) async throws {
        try await dbPool.write { db in
            try db.execute(
                sql: "UPDATE user_sessions SET revokedAt = ? WHERE tokenHash = ? AND revokedAt IS NULL",
                arguments: [date, sessionTokenHash]
            )
        }
    }

    public func seedDiagnosticQuestionBank() async throws {
        try await dbPool.write { db in
            try db.execute(
                sql: "INSERT OR IGNORE INTO subjects (id, name, description) VALUES (?, ?, ?)",
                arguments: [Self.diagnosticSubjectID, "Mathematics", "Grade 9 Number Systems"]
            )
            try db.execute(
                sql: "INSERT OR IGNORE INTO skills (id, name, subjectId, prerequisiteIds) VALUES (?, ?, ?, ?)",
                arguments: [Self.diagnosticSkillID, "Number Systems", Self.diagnosticSubjectID, "[]"]
            )
            try db.execute(
                sql: "INSERT OR IGNORE INTO assessments (id, title, skillId) VALUES (?, ?, ?)",
                arguments: [Self.diagnosticAssessmentID, "Grade 9 Number Systems Diagnostic", Self.diagnosticSkillID]
            )

            for question in Self.diagnosticQuestions {
                let options = String(decoding: try JSONEncoder().encode(question.options), as: UTF8.self)
                try db.execute(
                    sql: "INSERT OR IGNORE INTO questions (id, assessmentId, body, type, optionsJSON, correctAnswer, difficultyLevel) VALUES (?, ?, ?, ?, ?, ?, ?)",
                    arguments: [question.id, Self.diagnosticAssessmentID, question.text, "multipleChoice", options, question.correctAnswer, question.difficultyLevel]
                )
            }
        }
    }

    public func diagnosticQuestions(for studentID: UUID, limit: Int = 5) async throws -> [DiagnosticQuestionPrompt] {
        try await dbPool.read { db in
            let recentAverage = try Double.fetchOne(
                db,
                sql: "SELECT AVG(score) FROM (SELECT score FROM assessment_attempts WHERE studentId = ? AND assessmentId = ? ORDER BY completedAt DESC LIMIT 3)",
                arguments: [studentID.uuidString, Self.diagnosticAssessmentID]
            )
            let targetDifficulty: Int
            switch recentAverage ?? 0 {
            case ..<40: targetDifficulty = 1
            case ..<70: targetDifficulty = 2
            case ..<90: targetDifficulty = 4
            default: targetDifficulty = 5
            }

            let rows = try Row.fetchAll(
                db,
                sql: "SELECT id, body, optionsJSON, difficultyLevel FROM questions WHERE assessmentId = ? AND correctAnswer IS NOT NULL ORDER BY abs(difficultyLevel - ?), random() LIMIT ?",
                arguments: [Self.diagnosticAssessmentID, targetDifficulty, max(1, min(limit, 10))]
            )

            return try rows.map { row in
                guard let idString: String = row["id"],
                      let id = UUID(uuidString: idString),
                      let text: String = row["body"],
                      let optionsJSON: String = row["optionsJSON"],
                      let difficultyLevel: Int = row["difficultyLevel"] else {
                    throw NidanError.databaseError("A diagnostic question row is malformed.")
                }
                let options = try JSONDecoder().decode([String].self, from: Data(optionsJSON.utf8))
                return DiagnosticQuestionPrompt(id: id, text: text, options: options, difficultyLevel: difficultyLevel)
            }
        }
    }

    public func submitDiagnosticAttempt(
        studentID: UUID,
        answers: [DiagnosticAnswerInput],
        completedAt: Date = Date()
    ) async throws -> DiagnosticAttemptResult {
        guard (1...10).contains(answers.count),
              Set(answers.map(\.questionID)).count == answers.count else {
            throw NidanError.validationFailed("Submit between one and ten unique diagnostic answers.")
        }

        return try await dbPool.write { db in
            var scoredAnswers: [(DiagnosticAnswerInput, Bool)] = []
            for answer in answers {
                let submittedText = answer.answer.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !submittedText.isEmpty, submittedText.count <= 500,
                      let row = try Row.fetchOne(
                        db,
                        sql: "SELECT correctAnswer, optionsJSON FROM questions WHERE id = ? AND assessmentId = ?",
                        arguments: [answer.questionID.uuidString, Self.diagnosticAssessmentID]
                      ),
                      let correctAnswer: String = row["correctAnswer"],
                      let optionsJSON: String = row["optionsJSON"] else {
                    throw NidanError.validationFailed("An answer is empty, too long, or references an unavailable question.")
                }
                let options = try JSONDecoder().decode([String].self, from: Data(optionsJSON.utf8))
                guard options.contains(where: { $0.caseInsensitiveCompare(submittedText) == .orderedSame }) else {
                    throw NidanError.validationFailed("An answer must match one of the offered choices.")
                }
                let normalizedAnswer = DiagnosticAnswerInput(questionID: answer.questionID, answer: submittedText)
                scoredAnswers.append((normalizedAnswer, correctAnswer.caseInsensitiveCompare(submittedText) == .orderedSame))
            }

            let correctCount = scoredAnswers.filter { $0.1 }.count
            let score = Int((Double(correctCount) / Double(scoredAnswers.count) * 100).rounded())
            let attemptID = UUID()
            try db.execute(
                sql: "INSERT INTO assessment_attempts (id, studentId, assessmentId, score, completedAt) VALUES (?, ?, ?, ?, ?)",
                arguments: [attemptID.uuidString, studentID.uuidString, Self.diagnosticAssessmentID, score, completedAt]
            )
            for (answer, isCorrect) in scoredAnswers {
                try db.execute(
                    sql: "INSERT INTO question_responses (id, attemptId, questionId, studentId, answerText, isCorrect, submittedAt) VALUES (?, ?, ?, ?, ?, ?, ?)",
                    arguments: [UUID().uuidString, attemptID.uuidString, answer.questionID.uuidString, studentID.uuidString, answer.answer, isCorrect, completedAt]
                )
            }

            let state: String
            let recommendation: String
            switch score {
            case ..<40:
                state = "struggling"
                recommendation = "Review foundational number-system concepts with guided examples."
            case ..<70:
                state = "partial mastery"
                recommendation = "Continue with guided practice on rational and irrational numbers."
            case ..<90:
                state = "developing mastery"
                recommendation = "Practice standard number-system problems and explain each step."
            default:
                state = "mastery"
                recommendation = "Try a challenge problem or move to the next prerequisite skill."
            }

            return DiagnosticAttemptResult(
                attemptID: attemptID,
                score: score,
                correctCount: correctCount,
                questionCount: scoredAnswers.count,
                state: state,
                recommendation: recommendation
            )
        }
    }

    private func consumeEnrollmentCode(
        codeHash: String,
        role: UserRole,
        sessionTokenHash: String,
        sessionExpiresAt: Date,
        insertUser: @Sendable (Database, Bool, EnrollmentScope) throws -> UUID
    ) async throws -> Bool {
        try await dbPool.write { db in
            let now = Date()
            guard let invitation = try Row.fetchOne(
                db,
                sql: "SELECT role, expiresAt, scopeJSON FROM enrollment_codes WHERE codeHash = ? AND redeemedAt IS NULL",
                arguments: [codeHash]
            ),
            let invitedRole: String = invitation["role"],
            let expiresAt: Date = invitation["expiresAt"],
            let scopeJSON: String = invitation["scopeJSON"],
            let scopeData = scopeJSON.data(using: .utf8),
            let scope = try? JSONDecoder().decode(EnrollmentScope.self, from: scopeData),
            invitedRole == role.rawValue,
            expiresAt > now else {
                return false
            }

            let existingOwnerCount = try Int.fetchOne(
                db,
                sql: "SELECT COUNT(*) FROM users WHERE isDeviceOwner = 1"
            ) ?? 0

            try db.execute(
                sql: "UPDATE enrollment_codes SET redeemedAt = ? WHERE codeHash = ? AND role = ? AND redeemedAt IS NULL AND expiresAt > ?",
                arguments: [now, codeHash, role.rawValue, now]
            )
            guard db.changesCount == 1 else { return false }

            let userId = try insertUser(db, existingOwnerCount == 0, scope)
            try db.execute(
                sql: "INSERT INTO user_sessions (tokenHash, userId, expiresAt) VALUES (?, ?, ?)",
                arguments: [sessionTokenHash, userId.uuidString, sessionExpiresAt]
            )
            return true
        }
    }

    private static func parseClassName(_ name: String) throws -> (String, String) {
        let grade = String(name.prefix { $0.isNumber })
        let division = String(name.dropFirst(grade.count))
        guard !grade.isEmpty, !division.isEmpty,
              name.count <= 20,
              grade.allSatisfy(\.isNumber),
              division.allSatisfy({ $0.isLetter || $0.isNumber }) else {
            throw NidanError.validationFailed("Classes must use a grade and division such as 9A.")
        }
        return (grade, division)
    }

    private static func ensureClass(name: String, grade: String, division: String, in db: Database) throws -> String {
        try db.execute(
            sql: "INSERT OR IGNORE INTO school_classes (id, name, grade, division) VALUES (?, ?, ?, ?)",
            arguments: [UUID().uuidString, name, grade, division]
        )
        guard let id = try String.fetchOne(db, sql: "SELECT id FROM school_classes WHERE name = ?", arguments: [name]) else {
            throw NidanError.databaseError("The approved class could not be resolved.")
        }
        return id
    }
    
    public func saveCourse(_ course: Course) async throws {
        // Mapped to "subjects" table for simplicity per plan schema
        try await dbPool.write { db in
            try db.execute(
                sql: "INSERT INTO subjects (id, name, description) VALUES (?, ?, ?) ON CONFLICT(id) DO UPDATE SET name=excluded.name",
                arguments: [course.id.uuidString, course.name, ""]
            )
        }
    }
    
    public func saveSkill(_ skill: Skill) async throws {
        try await dbPool.write { db in
            try db.execute(
                sql: "INSERT INTO skills (id, name, subjectId, prerequisiteIds) VALUES (?, ?, ?, ?) ON CONFLICT(id) DO UPDATE SET name=excluded.name",
                arguments: [skill.id.uuidString, skill.name, skill.subjectId.uuidString, "[]"]
            )
        }
    }
    
    public func saveAssessment(_ assessment: Assessment) async throws {
        try await dbPool.write { db in
            try db.execute(
                sql: "INSERT INTO assessments (id, title, skillId) VALUES (?, ?, ?) ON CONFLICT(id) DO UPDATE SET title=excluded.title",
                arguments: [assessment.id.uuidString, assessment.title, assessment.skillId.uuidString]
            )
        }
    }
    
    public func saveAssignment(_ assignment: Assignment) async throws {
        try await dbPool.write { db in
            try db.execute(
                sql: "INSERT INTO assignments (id, studentId, assessmentId, dueDate, isCompleted) VALUES (?, ?, ?, ?, ?) ON CONFLICT(id) DO UPDATE SET isCompleted=excluded.isCompleted",
                arguments: [assignment.id.uuidString, assignment.studentId.uuidString, assignment.assessmentId.uuidString, assignment.dueDate, assignment.isCompleted]
            )
        }
    }
    
    public func saveProgress(_ progress: NidanModels.Progress) async throws {
        try await dbPool.write { db in
            try db.execute(
                sql: "INSERT INTO progress (id, studentId, courseId, percentComplete) VALUES (?, ?, ?, ?) ON CONFLICT(id) DO UPDATE SET percentComplete=excluded.percentComplete",
                arguments: [progress.id.uuidString, progress.studentId.uuidString, progress.courseId.uuidString, progress.percentComplete]
            )
        }
    }
    
    // MARK: - Seeding Synthetic Data
    public func seedRealisticData() async throws {
        let hasSeeded = try await dbPool.read { db in
            try Int.fetchOne(db, sql: "SELECT COUNT(*) FROM users WHERE role = 'student'") ?? 0
        }
        
        guard hasSeeded == 0 else { return } // Already seeded
        
        let demoStudents = (1...10).map { String(format: "Demo Student %02d", $0) }

        for name in demoStudents {
            let student = Student(id: UUID(), name: name, studentClass: "9", division: "A", englishTeacher: "Demo English Teacher", ictTeacher: "Demo ICT Teacher", classTeacher: "Demo Class Teacher")
            try await saveStudent(student, isDeviceOwner: false)
        }
    }

    public func seedDemoSchoolData() async throws {
        try await dbPool.write { db in
            let hasSeeded = try Int.fetchOne(
                db,
                sql: "SELECT COUNT(*) FROM settings WHERE key = 'demo_school_seed_v1'"
            ) ?? 0
            guard hasSeeded == 0 else { return }
            let existingUsers = try Int.fetchOne(db, sql: "SELECT COUNT(*) FROM users") ?? 0
            guard existingUsers == 0 else { return }

            let teacherID = UUID(uuidString: "20000000-0000-4000-8000-000000000001")!
            let vicePrincipalID = UUID(uuidString: "20000000-0000-4000-8000-000000000002")!
            let principalID = UUID(uuidString: "20000000-0000-4000-8000-000000000003")!
            let class9AID = UUID(uuidString: "20000000-0000-4000-8000-000000000101")!
            let class9BID = UUID(uuidString: "20000000-0000-4000-8000-000000000102")!
            let classDefinitions = [(class9AID, "9A", "9", "A"), (class9BID, "9B", "9", "B")]

            try db.execute(sql: "INSERT OR IGNORE INTO users (id, name, role, isDeviceOwner) VALUES (?, ?, ?, ?)", arguments: [teacherID.uuidString, "Demo Teacher", UserRole.teacher.rawValue, false])
            try db.execute(sql: "INSERT OR IGNORE INTO users (id, name, role, isDeviceOwner) VALUES (?, ?, ?, ?)", arguments: [vicePrincipalID.uuidString, "Demo Vice-Principal", UserRole.vicePrincipal.rawValue, false])
            try db.execute(sql: "INSERT OR IGNORE INTO users (id, name, role, isDeviceOwner) VALUES (?, ?, ?, ?)", arguments: [principalID.uuidString, "Demo Principal", UserRole.principal.rawValue, false])

            for (id, name, grade, division) in classDefinitions {
                try db.execute(sql: "INSERT OR IGNORE INTO school_classes (id, name, grade, division) VALUES (?, ?, ?, ?)", arguments: [id.uuidString, name, grade, division])
                try db.execute(sql: "INSERT OR IGNORE INTO teacher_class_assignments (teacherId, classId, subject) VALUES (?, ?, ?)", arguments: [teacherID.uuidString, id.uuidString, "Mathematics"])
                try db.execute(sql: "INSERT OR IGNORE INTO teacher_class_assignments (teacherId, classId, subject) VALUES (?, ?, ?)", arguments: [teacherID.uuidString, id.uuidString, "Science"])
            }

            var studentIDs: [(UUID, UUID)] = []
            for index in 1...12 {
                let studentID = UUID()
                let classID = index <= 6 ? class9AID : class9BID
                studentIDs.append((studentID, classID))
                try db.execute(
                    sql: "INSERT INTO users (id, name, role, studentClass, division, isDeviceOwner) VALUES (?, ?, ?, ?, ?, ?)",
                    arguments: [studentID.uuidString, String(format: "Demo Student %02d", index), UserRole.student.rawValue, "9", index <= 6 ? "A" : "B", false]
                )
                try db.execute(
                    sql: "INSERT INTO class_memberships (studentId, classId, joinedAt) VALUES (?, ?, ?)",
                    arguments: [studentID.uuidString, classID.uuidString, Date()]
                )
            }

            for (classID, className, _, _) in classDefinitions {
                let assignmentID = UUID()
                try db.execute(
                    sql: "INSERT INTO class_assignments (id, classId, createdBy, title, instructions, subject, chapter, dueAt, createdAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
                    arguments: [assignmentID.uuidString, classID.uuidString, teacherID.uuidString, "\(className) Number Systems Worksheet", "Complete the assigned problems on paper and submit the worksheet in class.", "Mathematics", "Number Systems", Date().addingTimeInterval(3 * 24 * 60 * 60), Date()]
                )
                try db.execute(
                    sql: "INSERT INTO student_assignment_records (assignmentId, studentId) SELECT ?, studentId FROM class_memberships WHERE classId = ?",
                    arguments: [assignmentID.uuidString, classID.uuidString]
                )

                try db.execute(
                    sql: "INSERT INTO chapter_progress (classId, subject, chapter, completionPercent, updatedBy, updatedAt) VALUES (?, ?, ?, ?, ?, ?)",
                    arguments: [classID.uuidString, "Mathematics", "Number Systems", className == "9A" ? 68 : 52, teacherID.uuidString, Date()]
                )
                try db.execute(
                    sql: "INSERT INTO chapter_progress (classId, subject, chapter, completionPercent, updatedBy, updatedAt) VALUES (?, ?, ?, ?, ?, ?)",
                    arguments: [classID.uuidString, "Science", "The Fundamental Unit of Life", className == "9A" ? 42 : 35, teacherID.uuidString, Date()]
                )

                try db.execute(
                    sql: "INSERT INTO school_notices (id, authorId, classId, title, body, createdAt) VALUES (?, ?, ?, ?, ?, ?)",
                    arguments: [UUID().uuidString, teacherID.uuidString, classID.uuidString, "Mathematics worksheet due", "Bring your completed Number Systems worksheet to the next mathematics class.", Date()]
                )
            }

            for (index, entry) in studentIDs.enumerated() {
                guard index % 3 == 0 else { continue }
                try db.execute(
                    sql: "INSERT INTO student_marks (id, studentId, classId, enteredBy, subject, assessmentTitle, mark, maximumMark, recordedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
                    arguments: [UUID().uuidString, entry.0.uuidString, entry.1.uuidString, teacherID.uuidString, "Mathematics", "Number Systems Class Test", 12 + (index % 5), 20, Date()]
                )
            }

            if let firstStudent = studentIDs.first {
                try db.execute(
                    sql: "INSERT INTO student_doubts (id, studentId, classId, subject, topic, message, createdAt) VALUES (?, ?, ?, ?, ?, ?, ?)",
                    arguments: [UUID().uuidString, firstStudent.0.uuidString, firstStudent.1.uuidString, "Mathematics", "Irrational numbers", "I am not sure how to identify whether a decimal expansion repeats.", Date()]
                )
            }

            try db.execute(sql: "INSERT INTO settings (key, value) VALUES ('demo_school_seed_v1', 'complete')")
        }
    }
}
