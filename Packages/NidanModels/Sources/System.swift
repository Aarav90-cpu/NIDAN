import Foundation

public struct Device: Codable, Identifiable {
    public let id: UUID
    public var name: String
    public var lastSeen: Date
    
    public init(id: UUID = UUID(), name: String, lastSeen: Date = Date()) {
        self.id = id
        self.name = name
        self.lastSeen = lastSeen
    }
}

public struct SyncState: Codable, Identifiable {
    public let id: UUID
    public var lastSync: Date?
    public var isSyncing: Bool
    public var version: Int
    
    public init(id: UUID = UUID(), lastSync: Date? = nil, isSyncing: Bool = false, version: Int = 1) {
        self.id = id
        self.lastSync = lastSync
        self.isSyncing = isSyncing
        self.version = version
    }
}

public struct Download: Codable, Identifiable {
    public let id: UUID
    public var url: URL
    public var localPath: String?
    public var progress: Double // 0.0 to 1.0
    public var isComplete: Bool
    
    public init(id: UUID = UUID(), url: URL, localPath: String? = nil, progress: Double = 0.0, isComplete: Bool = false) {
        self.id = id
        self.url = url
        self.localPath = localPath
        self.progress = progress
        self.isComplete = isComplete
    }
}
