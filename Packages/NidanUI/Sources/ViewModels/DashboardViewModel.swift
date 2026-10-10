import Foundation
import NidanModels
import NidanCore

@MainActor
public final class DashboardViewModel: ObservableObject {
    @Published public private(set) var greeting: String = "Welcome back!"
    @Published public private(set) var studentName: String = ""
    @Published public private(set) var progressPercent: Double = 0.0
    @Published public private(set) var pendingAssignments: [Assignment] = []
    @Published public private(set) var continueLearningRecommendations: [Skill] = []
    @Published public private(set) var isOffline: Bool = true
    
    // Core dependencies
    private let storage: StorageProvider
    private let studentId: UUID
    
    public init(storage: StorageProvider, studentId: UUID) {
        self.storage = storage
        self.studentId = studentId
    }
    
    public func loadData() async {
        do {
            if let student = try await storage.getStudent(id: studentId) {
                self.studentName = student.name
                self.greeting = generateGreeting(for: student.name)
            }
            
            // Dummy logic for now until repositories are fully implemented
            self.progressPercent = 0.0
            self.pendingAssignments = []
            self.continueLearningRecommendations = []
            
        } catch {
            CurrentEnvironment.current.logger.error("Failed to load dashboard data: \(error)")
        }
    }
    
    private func generateGreeting(for name: String) -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "Good morning, \(name)!" }
        if hour < 17 { return "Good afternoon, \(name)!" }
        return "Good evening, \(name)!"
    }
}
