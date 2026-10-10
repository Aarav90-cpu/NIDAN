import Foundation

public protocol User: Sendable {
    var id: UUID { get }
    var name: String { get }
    var role: UserRole { get }
}

public enum UserRole: String, Codable, Sendable {
    case student
    case teacher
    case vicePrincipal
    case principal
}

public struct Student: User, Codable, Identifiable, Sendable {
    public let id: UUID
    public var name: String
    public let role: UserRole
    
    // Additional Onboarding Fields
    public var studentClass: String?
    public var division: String?
    public var englishTeacher: String?
    public var ictTeacher: String?
    public var classTeacher: String?
    
    public init(id: UUID = UUID(), name: String, studentClass: String? = nil, division: String? = nil, englishTeacher: String? = nil, ictTeacher: String? = nil, classTeacher: String? = nil) {
        self.id = id
        self.name = name
        self.role = .student
        self.studentClass = studentClass
        self.division = division
        self.englishTeacher = englishTeacher
        self.ictTeacher = ictTeacher
        self.classTeacher = classTeacher
    }
}

public struct Teacher: User, Codable, Identifiable, Sendable {
    public let id: UUID
    public var name: String
    public let role: UserRole
    
    // Additional Onboarding Fields
    public var teacherRole: String? // "Class Teacher" or "Supportive Teacher"
    public var classTeacherOf: String? // e.g., "9A"
    public var subjectsTaught: [String]?
    public var classesTaught: [String]?
    
    public init(id: UUID = UUID(), name: String, teacherRole: String? = nil, classTeacherOf: String? = nil, subjectsTaught: [String]? = nil, classesTaught: [String]? = nil) {
        self.id = id
        self.name = name
        self.role = .teacher
        self.teacherRole = teacherRole
        self.classTeacherOf = classTeacherOf
        self.subjectsTaught = subjectsTaught
        self.classesTaught = classesTaught
    }
}
