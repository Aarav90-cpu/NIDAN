import Foundation

public struct Subject: Codable, Identifiable, Sendable {
    public let id: UUID
    public var name: String
    
    public init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}

public struct Course: Codable, Identifiable, Sendable {
    public let id: UUID
    public var name: String
    public var subjectId: UUID
    public var conceptIds: [UUID]
    
    public init(id: UUID = UUID(), name: String, subjectId: UUID, conceptIds: [UUID] = []) {
        self.id = id
        self.name = name
        self.subjectId = subjectId
        self.conceptIds = conceptIds
    }
}

public struct Class: Codable, Identifiable, Sendable {
    public let id: UUID
    public var name: String
    public var teacherId: UUID
    public var studentIds: [UUID]
    public var courseId: UUID?
    
    public init(id: UUID = UUID(), name: String, teacherId: UUID, studentIds: [UUID] = [], courseId: UUID? = nil) {
        self.id = id
        self.name = name
        self.teacherId = teacherId
        self.studentIds = studentIds
        self.courseId = courseId
    }
}
