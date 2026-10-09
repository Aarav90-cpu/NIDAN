import Foundation

public struct Concept: Codable, Identifiable {
    public let id: UUID
    public var name: String
    public var description: String
    public var prerequisiteIds: [UUID]
    
    public init(id: UUID = UUID(), name: String, description: String, prerequisiteIds: [UUID] = []) {
        self.id = id
        self.name = name
        self.description = description
        self.prerequisiteIds = prerequisiteIds
    }
}

public struct Skill: Codable, Identifiable {
    public let id: UUID
    public var name: String
    public var conceptId: UUID
    public var description: String
    
    public init(id: UUID = UUID(), name: String, conceptId: UUID, description: String) {
        self.id = id
        self.name = name
        self.conceptId = conceptId
        self.description = description
    }
}

public struct Lesson: Codable, Identifiable {
    public let id: UUID
    public var title: String
    public var conceptId: UUID
    public var contentItemIds: [UUID]
    
    public init(id: UUID = UUID(), title: String, conceptId: UUID, contentItemIds: [UUID] = []) {
        self.id = id
        self.title = title
        self.conceptId = conceptId
        self.contentItemIds = contentItemIds
    }
}

public struct ContentItem: Codable, Identifiable {
    public let id: UUID
    public var title: String
    public var url: URL?
    public var body: String?
    public var type: ContentType
    
    public init(id: UUID = UUID(), title: String, url: URL? = nil, body: String? = nil, type: ContentType) {
        self.id = id
        self.title = title
        self.url = url
        self.body = body
        self.type = type
    }
}

public enum ContentType: String, Codable {
    case video
    case text
    case interactive
}
