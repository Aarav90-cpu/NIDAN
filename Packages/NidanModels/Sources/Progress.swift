import Foundation

public struct Progress: Codable, Identifiable, Sendable {
    public let id: UUID
    public var studentId: UUID
    public var courseId: UUID
    public var percentComplete: Double // 0.0 to 1.0
    
    public init(id: UUID = UUID(), studentId: UUID, courseId: UUID, percentComplete: Double = 0.0) {
        self.id = id
        self.studentId = studentId
        self.courseId = courseId
        self.percentComplete = percentComplete
    }
}

public struct Mastery: Codable, Identifiable, Sendable {
    public let id: UUID
    public var studentId: UUID
    public var skillId: UUID
    public var level: Double // 0.0 to 1.0 representing mastery level
    public var lastEvaluated: Date
    
    public init(id: UUID = UUID(), studentId: UUID, skillId: UUID, level: Double = 0.0, lastEvaluated: Date = Date()) {
        self.id = id
        self.studentId = studentId
        self.skillId = skillId
        self.level = level
        self.lastEvaluated = lastEvaluated
    }
}
