import Foundation

public protocol User {
    var id: UUID { get }
    var name: String { get }
    var role: UserRole { get }
}

public enum UserRole: String, Codable {
    case student
    case teacher
    case admin
}

public struct Student: User, Codable, Identifiable {
    public let id: UUID
    public var name: String
    public let role: UserRole
    
    public init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
        self.role = .student
    }
}

public struct Teacher: User, Codable, Identifiable {
    public let id: UUID
    public var name: String
    public let role: UserRole
    
    public init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
        self.role = .teacher
    }
}
