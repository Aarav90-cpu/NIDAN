import Foundation
import XCTest
import NidanModels
@testable import NidanStorage

final class EnrollmentCodeTests: XCTestCase {
    func testCodeIsRoleBoundAndCanOnlyBeUsedOnce() async throws {
        let databaseURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("nidan-enrollment-\(UUID().uuidString).sqlite")
        defer { try? FileManager.default.removeItem(at: databaseURL) }

        let database = try DatabaseManager(path: databaseURL.path)
        let codeHash = "test-code-hash"
        try await database.createEnrollmentCode(
            codeHash: codeHash,
            role: .teacher,
            scope: EnrollmentScope(classes: ["9A"], subjects: ["Science", "Math"]),
            expiresAt: Date().addingTimeInterval(60)
        )

        let wrongRoleAttempt = try await database.enrollStudent(
            Student(name: "Synthetic Student", studentClass: "9", division: "A"),
            codeHash: codeHash,
            sessionTokenHash: "wrong-role-session",
            sessionExpiresAt: Date().addingTimeInterval(60)
        )
        XCTAssertFalse(wrongRoleAttempt)

        let teacher = Teacher(
            name: "Synthetic Teacher",
            teacherRole: "Supportive Teacher",
            subjectsTaught: ["Science"],
            classesTaught: ["9A"]
        )
        let sessionTokenHash = "teacher-session"
        let sessionExpiresAt = Date().addingTimeInterval(60)
        let firstUse = try await database.enrollTeacher(
            teacher,
            codeHash: codeHash,
            sessionTokenHash: sessionTokenHash,
            sessionExpiresAt: sessionExpiresAt
        )
        let replay = try await database.enrollTeacher(
            Teacher(name: "Second Synthetic Teacher", subjectsTaught: ["Math"], classesTaught: ["9A"]),
            codeHash: codeHash,
            sessionTokenHash: "replay-session",
            sessionExpiresAt: sessionExpiresAt
        )
        let sessionUser = try await database.authenticatedUser(sessionTokenHash: sessionTokenHash)

        XCTAssertTrue(firstUse)
        XCTAssertFalse(replay)
        XCTAssertEqual(sessionUser?.id, teacher.id)
        XCTAssertEqual(sessionUser?.role, .teacher)

        try await database.revokeSession(sessionTokenHash: sessionTokenHash)
        let revokedUser = try await database.authenticatedUser(sessionTokenHash: sessionTokenHash)
        XCTAssertNil(revokedUser)
    }

    func testExpiredCodeCannotBeUsed() async throws {
        let databaseURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("nidan-expired-enrollment-\(UUID().uuidString).sqlite")
        defer { try? FileManager.default.removeItem(at: databaseURL) }

        let database = try DatabaseManager(path: databaseURL.path)
        let codeHash = "expired-code-hash"
        try await database.createEnrollmentCode(
            codeHash: codeHash,
            role: .student,
            scope: EnrollmentScope(classes: ["9A"]),
            expiresAt: Date().addingTimeInterval(-1)
        )

        let result = try await database.enrollStudent(
            Student(name: "Synthetic Student", studentClass: "9", division: "A"),
            codeHash: codeHash,
            sessionTokenHash: "expired-session",
            sessionExpiresAt: Date().addingTimeInterval(60)
        )

        XCTAssertFalse(result)
    }

    func testExpiredSessionCannotAuthenticate() async throws {
        let databaseURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("nidan-expired-session-\(UUID().uuidString).sqlite")
        defer { try? FileManager.default.removeItem(at: databaseURL) }

        let database = try DatabaseManager(path: databaseURL.path)
        let codeHash = "session-expiry-code-hash"
        let sessionTokenHash = "expired-session-token-hash"
        try await database.createEnrollmentCode(
            codeHash: codeHash,
            role: .student,
            scope: EnrollmentScope(classes: ["9A"]),
            expiresAt: Date().addingTimeInterval(60)
        )

        let enrolled = try await database.enrollStudent(
            Student(name: "Synthetic Student", studentClass: "9", division: "A"),
            codeHash: codeHash,
            sessionTokenHash: sessionTokenHash,
            sessionExpiresAt: Date().addingTimeInterval(-1)
        )
        let user = try await database.authenticatedUser(sessionTokenHash: sessionTokenHash)

        XCTAssertTrue(enrolled)
        XCTAssertNil(user)
    }
}
