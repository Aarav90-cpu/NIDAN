import Foundation
import NidanModels

/// NidanCore defines this protocol. The UI and Core logic use this protocol.
/// The `NidanStorage` package implements it using SQLite/GRDB.
/// This guarantees NidanCore never imports database libraries.
public protocol StorageProvider: Sendable {
    func getStudent(id: UUID) async throws -> Student?
    func saveStudent(_ student: Student) async throws
    
    func saveCourse(_ course: Course) async throws
    func saveSkill(_ skill: Skill) async throws
    func saveAssessment(_ assessment: Assessment) async throws
    func saveAssignment(_ assignment: Assignment) async throws
    func saveProgress(_ progress: NidanModels.Progress) async throws
}
