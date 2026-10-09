import Foundation

public struct Question: Codable, Identifiable, Sendable {
    public let id: UUID
    public var skillId: UUID
    public var text: String
    public var options: [String] // Empty array for free-text questions
    public var correctAnswer: String
    public var difficultyLevel: Int // Expected 1-100 scale for adaptive engine
    
    public init(id: UUID = UUID(), skillId: UUID, text: String, options: [String] = [], correctAnswer: String, difficultyLevel: Int = 50) {
        self.id = id
        self.skillId = skillId
        self.text = text
        self.options = options
        self.correctAnswer = correctAnswer
        self.difficultyLevel = difficultyLevel
    }
}

public struct Assessment: Codable, Identifiable, Sendable {
    public let id: UUID
    public var title: String
    public var skillId: UUID
    public var questionIds: [UUID]
    
    public init(id: UUID = UUID(), title: String, skillId: UUID, questionIds: [UUID] = []) {
        self.id = id
        self.title = title
        self.skillId = skillId
        self.questionIds = questionIds
    }
}

public struct Answer: Codable, Identifiable, Sendable {
    public let id: UUID
    public var questionId: UUID
    public var studentId: UUID
    public var submittedText: String
    public var isCorrect: Bool
    public var timestamp: Date
    
    public init(id: UUID = UUID(), questionId: UUID, studentId: UUID, submittedText: String, isCorrect: Bool, timestamp: Date = Date()) {
        self.id = id
        self.questionId = questionId
        self.studentId = studentId
        self.submittedText = submittedText
        self.isCorrect = isCorrect
        self.timestamp = timestamp
    }
}
