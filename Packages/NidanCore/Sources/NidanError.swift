import Foundation

public enum NidanError: Error, LocalizedError, Equatable, Sendable {
    case notFound(String)
    case unauthorized(String)
    case databaseError(String)
    case networkError(String)
    case validationFailed(String)
    case syncConflict(String)
    case internalInconsistency(String)
    
    public var errorDescription: String? {
        switch self {
        case .notFound(let message): return "Not Found: \(message)"
        case .unauthorized(let message): return "Unauthorized: \(message)"
        case .databaseError(let message): return "Database Error: \(message)"
        case .networkError(let message): return "Network Error: \(message)"
        case .validationFailed(let message): return "Validation Failed: \(message)"
        case .syncConflict(let message): return "Sync Conflict: \(message)"
        case .internalInconsistency(let message): return "Internal Inconsistency: \(message)"
        }
    }
}
