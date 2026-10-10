import Foundation
import XCTest
import NidanModels
@testable import NidanStorage

final class SchoolWorkflowTests: XCTestCase {
    func testTeacherAssignmentHandInMarkAndStudentRecordFlow() async throws {
        let databaseURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("nidan-school-workflow-\(UUID().uuidString).sqlite")
        defer { try? FileManager.default.removeItem(at: databaseURL) }

        let database = try DatabaseManager(path: databaseURL.path)
        try await database.seedDemoSchoolData()

        let teacherID = UUID(uuidString: "20000000-0000-4000-8000-000000000001")!
        let teacher = SessionUser(id: teacherID, name: "Demo Teacher", role: .teacher)
        let teacherDashboard = try await database.schoolDashboard(for: teacher)
        XCTAssertEqual(teacherDashboard.classes.count, 2)
        XCTAssertTrue(teacherDashboard.classes.allSatisfy { !$0.students.isEmpty })

        let classID = teacherDashboard.classes[0].id
        let student = try XCTUnwrap(teacherDashboard.classes[0].students.first)
        let assignmentID = try await database.createClassAssignment(
            AssignmentCreation(
                classID: classID,
                title: "In-class paper worksheet",
                instructions: "Complete and hand in on paper.",
                subject: "Mathematics",
                chapter: "Number Systems",
                dueAt: Date().addingTimeInterval(3600)
            ),
            by: teacher
        )

        let studentUser = SessionUser(id: student.id, name: student.name, role: .student)
        var studentDashboard = try await database.studentDashboard(for: studentUser)
        XCTAssertTrue(studentDashboard.assignments.contains { $0.id == assignmentID && $0.status == "assigned" })

        try await database.submitPaperAssignment(assignmentID: assignmentID, by: studentUser)
        var submissions = try await database.assignmentSubmissions(assignmentID: assignmentID, for: teacher)
        XCTAssertEqual(submissions.first(where: { $0.studentID == student.id })?.status, "submitted")

        try await database.markAssignment(assignmentID: assignmentID, studentID: student.id, mark: 16, maximumMark: 20, feedback: "Show the calculation steps.", by: teacher)
        submissions = try await database.assignmentSubmissions(assignmentID: assignmentID, for: teacher)
        XCTAssertEqual(submissions.first(where: { $0.studentID == student.id })?.status, "marked")
        studentDashboard = try await database.studentDashboard(for: studentUser)
        XCTAssertTrue(studentDashboard.assignments.contains { $0.id == assignmentID && $0.mark == 16 && $0.maximumMark == 20 })
        XCTAssertTrue(studentDashboard.marks.contains { $0.assessmentTitle == "In-class paper worksheet" && $0.mark == 16 })

        let doubtID = try await database.createStudentDoubt(
            DoubtCreation(classID: classID, subject: "Mathematics", topic: "Fractions", message: "How do I compare these fractions?"),
            by: studentUser
        )
        try await database.respondToDoubt(doubtID: doubtID, message: "Convert them to a common denominator first.", by: teacher)
        studentDashboard = try await database.studentDashboard(for: studentUser)
        XCTAssertTrue(studentDashboard.doubts.contains { $0.id == doubtID && $0.responseMessage == "Convert them to a common denominator first." })

        do {
            try await database.updateChapterProgress(
                ChapterProgressUpdate(classID: classID, subject: "History", chapter: "Ancient Civilizations", completionPercent: 20),
                by: teacher
            )
            XCTFail("Teacher should not update chapter progress for an unassigned subject.")
        } catch NidanError.unauthorized {
        }

        do {
            _ = try await database.createSchoolNotice(
                NoticeCreation(classID: nil, title: "Unauthorized broadcast", body: "Teacher broadcast"),
                by: teacher
            )
            XCTFail("Teachers should not publish whole-school notices.")
        } catch NidanError.unauthorized {
        }

        do {
            _ = try await database.createClassAssignment(
                AssignmentCreation(classID: UUID(), title: "Out-of-scope", instructions: "No access", subject: "Mathematics", chapter: nil, dueAt: Date().addingTimeInterval(3600)),
                by: teacher
            )
            XCTFail("Teacher should not create work outside assigned classes.")
        } catch NidanError.unauthorized {
        }
    }

    func testVicePrincipalCannotPublishSchoolWideNotice() async throws {
        let databaseURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("nidan-notice-scope-\(UUID().uuidString).sqlite")
        defer { try? FileManager.default.removeItem(at: databaseURL) }

        let database = try DatabaseManager(path: databaseURL.path)
        try await database.seedDemoSchoolData()
        let vicePrincipal = SessionUser(
            id: UUID(uuidString: "20000000-0000-4000-8000-000000000002")!,
            name: "Demo Vice-Principal",
            role: .vicePrincipal
        )
        let vicePrincipalDashboard = try await database.schoolDashboard(for: vicePrincipal)
        let student = try XCTUnwrap(vicePrincipalDashboard.classes.first?.students.first)
        let principal = SessionUser(
            id: UUID(uuidString: "20000000-0000-4000-8000-000000000003")!,
            name: "Demo Principal",
            role: .principal
        )

        do {
            _ = try await database.createSchoolNotice(NoticeCreation(classID: nil, title: "School notice", body: "Whole school message"), by: vicePrincipal)
            XCTFail("Vice-principal should not publish a whole-school notice.")
        } catch NidanError.unauthorized {
        }

        do {
            _ = try await database.createClassAssignment(
                AssignmentCreation(classID: vicePrincipalDashboard.classes[0].id, title: "Unauthorized assignment", instructions: "No academic edit", subject: "Mathematics", chapter: nil, dueAt: Date().addingTimeInterval(3600)),
                by: vicePrincipal
            )
            XCTFail("Vice-principal should not create or alter academic assignments.")
        } catch NidanError.unauthorized {
        }

        _ = try await database.createSchoolNotice(NoticeCreation(classID: nil, title: "School notice", body: "Whole school message"), by: principal)
        let studentDashboard = try await database.studentDashboard(
            for: SessionUser(id: student.id, name: student.name, role: .student)
        )
        XCTAssertTrue(studentDashboard.notices.contains { $0.title == "School notice" })
    }

    func testTeacherDashboardIsLimitedToAssignedClassAndSubject() async throws {
        let databaseURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("nidan-teacher-scope-\(UUID().uuidString).sqlite")
        defer { try? FileManager.default.removeItem(at: databaseURL) }

        let database = try DatabaseManager(path: databaseURL.path)
        try await database.seedDemoSchoolData()
        let demoDashboard = try await database.schoolDashboard(
            for: SessionUser(id: UUID(uuidString: "20000000-0000-4000-8000-000000000001")!, name: "Demo Teacher", role: .teacher)
        )
        let class9AID = UUID(uuidString: "20000000-0000-4000-8000-000000000101")!
        let class9BID = UUID(uuidString: "20000000-0000-4000-8000-000000000102")!
        let targetClass = try XCTUnwrap(demoDashboard.classes.first(where: { $0.id == class9AID }))
        let student = try XCTUnwrap(targetClass.students.first)
        let studentUser = SessionUser(id: student.id, name: student.name, role: .student)
        let teacherID = UUID()
        try await database.dbPool.write { db in
            try db.execute(
                sql: "INSERT INTO teacher_class_assignments (teacherId, classId, subject) VALUES (?, ?, ?)",
                arguments: [teacherID.uuidString, class9AID.uuidString, "Mathematics"]
            )
        }

        let scopedTeacher = SessionUser(id: teacherID, name: "Math Teacher", role: .teacher)
        try await database.createClassAssignment(
            AssignmentCreation(classID: class9AID, title: "Scoped worksheet", instructions: "Paper work", subject: "Mathematics", chapter: nil, dueAt: Date().addingTimeInterval(3600)),
            by: scopedTeacher
        )
        try await database.createSchoolNotice(
            NoticeCreation(classID: class9BID, title: "Other class notice", body: "Not authorized"),
            by: SessionUser(id: UUID(uuidString: "20000000-0000-4000-8000-000000000001")!, name: "Demo Teacher", role: .teacher)
        )
        try await database.createStudentDoubt(
            DoubtCreation(classID: class9AID, subject: "Science", topic: "Cells", message: "Question outside math scope"),
            by: studentUser
        )

        let scopedDashboard = try await database.schoolDashboard(for: scopedTeacher)
        XCTAssertEqual(scopedDashboard.classes.map(\.name), ["9A"])
        XCTAssertEqual(scopedDashboard.assignments.map(\.title), ["Scoped worksheet"])
        XCTAssertTrue(scopedDashboard.doubts.isEmpty)
        XCTAssertTrue(scopedDashboard.notices.isEmpty)
    }
}
