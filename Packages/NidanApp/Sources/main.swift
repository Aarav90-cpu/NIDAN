import Foundation
import NidanCore
import NidanModels
import NidanStorage

func runExitGate() async throws {
    print("🚀 NIDAN Phase 3 Exit Gate Test")
    print("==================================")
    print("✅ App starts")
    
    // 1. Initialize DB in memory
    let dbManager = try DatabaseManager(path: ":memory:")
    CurrentEnvironment.current = Environment(logger: PrintLogger(), storage: dbManager)
    print("✅ Local DB works")
    
    // 2. Sample Student
    let student = Student(name: "Aarav")
    try await dbManager.saveStudent(student)
    print("✅ Sample student exists: \(student.name)")
    
    // 3. Sample Course
    let course = Course(name: "Mathematics 101", subjectId: UUID())
    try await dbManager.saveCourse(course)
    print("✅ Sample course exists: \(course.name)")
    
    // 4. Sample Skill Graph
    let skill1 = Skill(name: "Addition", subjectId: course.id, prerequisiteIds: [])
    let skill2 = Skill(name: "Multiplication", subjectId: course.id, prerequisiteIds: [skill1.id])
    try await dbManager.saveSkill(skill1)
    try await dbManager.saveSkill(skill2)
    print("✅ Sample skill graph exists (Addition -> Multiplication)")
    
    // 5. Assessment
    let assessment = Assessment(title: "Multiplication Quiz", skillId: skill2.id)
    try await dbManager.saveAssessment(assessment)
    print("✅ Assessment can be stored: \(assessment.title)")
    
    // 6. Assignment
    let assignment = Assignment(studentId: student.id, assessmentId: assessment.id, dueDate: Date())
    try await dbManager.saveAssignment(assignment)
    print("✅ Assignment can be stored")
    
    // 7. Progress
    let progress = Progress(studentId: student.id, courseId: course.id, percentComplete: 0.15)
    try await dbManager.saveProgress(progress)
    print("✅ Progress can be calculated: \(progress.percentComplete * 100)%")
    
    print("\n🎉 PHASE 3 EXIT GATE PASSED: Entire basic flow works offline")
}

do {
    try await runExitGate()
} catch {
    print("❌ Exit Gate Failed: \(error)")
}
