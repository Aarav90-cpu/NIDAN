import Foundation
import XCTest
import NidanModels
@testable import NidanStorage

final class DiagnosticStorageTests: XCTestCase {
    func testSeededQuestionsCanBeScoredAndSavedForAStudent() async throws {
        let databaseURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("nidan-diagnostic-\(UUID().uuidString).sqlite")
        defer { try? FileManager.default.removeItem(at: databaseURL) }

        let database = try DatabaseManager(path: databaseURL.path)
        try await database.seedDiagnosticQuestionBank()
        let student = Student(name: "Synthetic Student", studentClass: "9", division: "A")
        try await database.saveStudent(student, isDeviceOwner: true)

        let questions = try await database.diagnosticQuestions(for: student.id)
        XCTAssertEqual(questions.count, 5)
        XCTAssertTrue(questions.allSatisfy { !$0.options.isEmpty })

        let answers = questions.map {
            DiagnosticAnswerInput(questionID: $0.id, answer: $0.options[0])
        }
        let result = try await database.submitDiagnosticAttempt(studentID: student.id, answers: answers)

        XCTAssertEqual(result.questionCount, questions.count)
        XCTAssertTrue((0...100).contains(result.score))
        XCTAssertTrue((0...questions.count).contains(result.correctCount))

        let nextQuestions = try await database.diagnosticQuestions(for: student.id)
        XCTAssertEqual(nextQuestions.count, 5)
    }
}
