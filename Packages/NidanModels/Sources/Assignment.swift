import Foundation

public struct Assignment: Codable, Identifiable, Sendable {
    public let id: UUID
    public var title: String
    public var studentId: UUID // changed from classId to studentId
    public var assessmentId: UUID
    public var dueDate: Date?
    public var isCompleted: Bool
    
    public init(id: UUID = UUID(), title: String = "", studentId: UUID, assessmentId: UUID, dueDate: Date? = nil, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.studentId = studentId
        self.assessmentId = assessmentId
        self.dueDate = dueDate
        self.isCompleted = isCompleted
    }
}

public struct Submission: Codable, Identifiable, Sendable {
    public let id: UUID
    public var assignmentId: UUID
    public var studentId: UUID
    public var answerIds: [UUID]
    public var timestamp: Date
    
    public init(id: UUID = UUID(), assignmentId: UUID, studentId: UUID, answerIds: [UUID] = [], timestamp: Date = Date()) {
        self.id = id
        self.assignmentId = assignmentId
        self.studentId = studentId
        self.answerIds = answerIds
        self.timestamp = timestamp
    }
}
