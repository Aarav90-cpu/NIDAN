import Foundation
import GRDB
import NidanModels
import NidanCore

public final class DatabaseManager: StorageProvider, Sendable {
    public let dbPool: DatabasePool
    
    public init(path: String) throws {
        var configuration = Configuration()
        
        // Use our central NidanLogger to log database queries.
        // NidanStorage is aware of NidanCore, but NidanCore is not aware of NidanStorage.
        configuration.prepareDatabase { db in
            db.trace { message in
                CurrentEnvironment.current.logger.debug("SQLite: \(message)")
            }
        }
        
        self.dbPool = try DatabasePool(path: path, configuration: configuration)
        try migrator.migrate(dbPool)
    }
    
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("v1_initial_schema") { db in
            // Table: students
            try db.create(table: "students") { t in
                t.column("id", .text).primaryKey()
                t.column("name", .text).notNull()
                t.column("role", .text).notNull() 
            }
            
            // Table: subjects
            try db.create(table: "subjects") { t in
                t.column("id", .text).primaryKey()
                t.column("name", .text).notNull()
                t.column("description", .text)
            }
            
            // Table: skills
            try db.create(table: "skills") { t in
                t.column("id", .text).primaryKey()
                t.column("name", .text).notNull()
                t.column("subjectId", .text).notNull().references("subjects", onDelete: .cascade)
                t.column("prerequisiteIds", .text)
            }
            
            // Table: assessments
            try db.create(table: "assessments") { t in
                t.column("id", .text).primaryKey()
                t.column("title", .text).notNull()
                t.column("skillId", .text).notNull().references("skills", onDelete: .cascade)
            }
            
            // Table: questions
            try db.create(table: "questions") { t in
                t.column("id", .text).primaryKey()
                t.column("assessmentId", .text).notNull().references("assessments", onDelete: .cascade)
                t.column("body", .text).notNull()
                t.column("type", .text).notNull()
            }
            
            // Table: assignments
            try db.create(table: "assignments") { t in
                t.column("id", .text).primaryKey()
                t.column("studentId", .text).notNull().references("students", onDelete: .cascade)
                t.column("assessmentId", .text).notNull().references("assessments", onDelete: .cascade)
                t.column("dueDate", .datetime).notNull()
                t.column("isCompleted", .boolean).notNull().defaults(to: false)
            }
            
            // Table: submissions
            try db.create(table: "submissions") { t in
                t.column("id", .text).primaryKey()
                t.column("assignmentId", .text).notNull().references("assignments", onDelete: .cascade)
                t.column("submittedAt", .datetime).notNull()
                t.column("score", .double)
            }
            
            // Table: progress
            try db.create(table: "progress") { t in
                t.column("id", .text).primaryKey()
                t.column("studentId", .text).notNull().references("students", onDelete: .cascade)
                t.column("courseId", .text).notNull() 
                t.column("percentComplete", .double).notNull()
            }
            
            // Table: content
            try db.create(table: "content") { t in
                t.column("id", .text).primaryKey()
                t.column("title", .text).notNull()
                t.column("url", .text)
                t.column("body", .text)
                t.column("type", .text).notNull()
            }
            
            // Table: sync_state
            try db.create(table: "sync_state") { t in
                t.column("id", .text).primaryKey()
                t.column("lastSync", .datetime)
                t.column("isSyncing", .boolean).notNull().defaults(to: false)
                t.column("version", .integer).notNull().defaults(to: 1)
            }
            
            // Table: settings
            try db.create(table: "settings") { t in
                t.column("key", .text).primaryKey()
                t.column("value", .text).notNull()
            }
        }
        
        return migrator
    }
    
    // MARK: - StorageProvider Implementation
    
    public func getStudent(id: UUID) async throws -> Student? {
        // Implementation stub for now
        return nil
    }
    
    public func saveStudent(_ student: Student) async throws {
        try await dbPool.write { db in
            try db.execute(
                sql: "INSERT INTO students (id, name, role) VALUES (?, ?, ?) ON CONFLICT(id) DO UPDATE SET name=excluded.name, role=excluded.role",
                arguments: [student.id.uuidString, student.name, student.role.rawValue]
            )
        }
    }
    
    public func saveCourse(_ course: Course) async throws {
        // Mapped to "subjects" table for simplicity per plan schema
        try await dbPool.write { db in
            try db.execute(
                sql: "INSERT INTO subjects (id, name, description) VALUES (?, ?, ?) ON CONFLICT(id) DO UPDATE SET name=excluded.name",
                arguments: [course.id.uuidString, course.name, ""]
            )
        }
    }
    
    public func saveSkill(_ skill: Skill) async throws {
        try await dbPool.write { db in
            try db.execute(
                sql: "INSERT INTO skills (id, name, subjectId, prerequisiteIds) VALUES (?, ?, ?, ?) ON CONFLICT(id) DO UPDATE SET name=excluded.name",
                arguments: [skill.id.uuidString, skill.name, skill.subjectId.uuidString, "[]"]
            )
        }
    }
    
    public func saveAssessment(_ assessment: Assessment) async throws {
        try await dbPool.write { db in
            try db.execute(
                sql: "INSERT INTO assessments (id, title, skillId) VALUES (?, ?, ?) ON CONFLICT(id) DO UPDATE SET title=excluded.title",
                arguments: [assessment.id.uuidString, assessment.title, assessment.skillId.uuidString]
            )
        }
    }
    
    public func saveAssignment(_ assignment: Assignment) async throws {
        try await dbPool.write { db in
            try db.execute(
                sql: "INSERT INTO assignments (id, studentId, assessmentId, dueDate, isCompleted) VALUES (?, ?, ?, ?, ?) ON CONFLICT(id) DO UPDATE SET isCompleted=excluded.isCompleted",
                arguments: [assignment.id.uuidString, assignment.studentId.uuidString, assignment.assessmentId.uuidString, assignment.dueDate, assignment.isCompleted]
            )
        }
    }
    
    public func saveProgress(_ progress: Progress) async throws {
        try await dbPool.write { db in
            try db.execute(
                sql: "INSERT INTO progress (id, studentId, courseId, percentComplete) VALUES (?, ?, ?, ?) ON CONFLICT(id) DO UPDATE SET percentComplete=excluded.percentComplete",
                arguments: [progress.id.uuidString, progress.studentId.uuidString, progress.courseId.uuidString, progress.percentComplete]
            )
        }
    }
}
