import Foundation
import SwiftCrossUI
import NidanModels

public struct DashboardView: View {
    @Observed public var viewModel: DashboardViewModel
    
    public init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            // Header / Greeting
            HStack {
                Text(viewModel.greeting)
                    .font(.title1)
                Spacer()
                if viewModel.isOffline {
                    Text("Offline Mode")
                        .foregroundColor(.red)
                }
            }
            .padding()
            
            // Progress Section
            VStack(alignment: .leading) {
                Text("Today's Learning")
                    .font(.title2)
                
                Text("Progress: \(Int(viewModel.progressPercent * 100))%")
                
                // Continue Learning
                if !viewModel.continueLearningRecommendations.isEmpty {
                    Text("Up Next: \(viewModel.continueLearningRecommendations.first?.name ?? "")")
                }
            }
            .padding()
            
            // Pending Assignments
            VStack(alignment: .leading) {
                Text("Pending Assignments")
                    .font(.title2)
                
                if viewModel.pendingAssignments.isEmpty {
                    Text("No pending assignments! You're all caught up.")
                } else {
                    ForEach(viewModel.pendingAssignments) { assignment in
                        Text("Due: \(assignment.dueDate)")
                    }
                }
            }
            .padding()
            
            Spacer()
        }
    }
}
