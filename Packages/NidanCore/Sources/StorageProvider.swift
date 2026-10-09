import Foundation
import NidanModels

/// NidanCore defines this protocol. The UI and Core logic use this protocol.
/// The `NidanStorage` package implements it using SQLite/GRDB.
/// This guarantees NidanCore never imports database libraries.
public protocol StorageProvider: Sendable {
    func getStudent(id: UUID) async throws -> Student?
    func saveStudent(_ student: Student) async throws
    
    // As we build features, we will add more methods here 
    // for skills, assessments, progress, etc.
}
