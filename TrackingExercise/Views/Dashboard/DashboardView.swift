//
//  DashboardView.swift
//  TrackingExercise
//
//  Created by Yujian Song on 4/14/25.
//

import SwiftUI
import SwiftData

/// Dashboard view displaying a live map and summary metrics.
/// Uses SwiftData’s @Query to fetch exercise sessions from the database.
struct DashboardView: View {
    // Fetch all sessions sorted by startTime in reverse order.
    @Query(sort: \ExerciseSession.startTime, order: .reverse) var sessions: [ExerciseSession]
    
    // Use the shared view model from the environment.
    @EnvironmentObject var viewModel: ExerciseSessionViewModel
    // Inject the model context.
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerView
                
                if let activeSession = sessions.first(where: { $0.endTime == nil }) {
                    activeSessionCard(session: activeSession)
                } else {
                    noActiveSessionCard
                }
                
                summaryMetricsCard
                
                Spacer()
            }
            .padding()
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 80)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Dashboard")
        .navigationBarTitleDisplayMode(.large)   // Switch to a large navigation title.
        .onAppear {
            // Inject the modelContext into the view model.
            viewModel.modelContext = modelContext
        }
    }
}

private extension DashboardView {
    // MARK: - Header
    var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Today's a new start")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.primary)
            Text(Date(), style: .date)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.green.opacity(0.3), Color.blue.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
        )
        .cornerRadius(12)
    }
    
    // MARK: - Active Session Card
    func activeSessionCard(session: ExerciseSession) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Active Session")
                .font(.title2)
                .bold()
                .foregroundColor(colorScheme == .dark ? .white : .black)

            // Live map view with the exercise route.
            ExerciseMapView(coordinates: session.locations.map { $0.clCoordinate })
                .frame(height: 300)
                .cornerRadius(12)
                .shadow(radius: 8)

            VStack(alignment: .leading, spacing: 8) {
                Text("Started: \(session.startTime.formatted(date: .abbreviated, time: .shortened))")
                Text("Distance: \(session.distance, specifier: "%.2f") m")
            }
            .font(.subheadline)
            .foregroundColor(colorScheme == .dark ? .white : .black)

            Button(action: {
                viewModel.stopSession()
            }) {
                Text("Stop Session")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(colorScheme == .dark ? Color.black : Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }

    
    // MARK: - No Active Session Card
    var noActiveSessionCard: some View {
        VStack(spacing: 16) {
            Image(systemName: "figure.walk")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.green)
            Text("No active session")
                .font(.title3)
                .bold()
                .foregroundColor(Color.primary)
            Text("Tap below to start your workout!")
                .font(.subheadline)
                .foregroundColor(Color.secondary)
            Button(action: {
                viewModel.startSession()
            }) {
                Text("Start Session")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Summary Metrics Card
    var summaryMetricsCard: some View {
        SummaryMetricsView(sessions: sessions)
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}



#Preview {
    let container = try! ModelContainer(
        for: Schema([ExerciseSession.self, User.self]),
        configurations: [
            ModelConfiguration(
                schema: Schema([ExerciseSession.self, User.self]),
                isStoredInMemoryOnly: true
            )
        ]
    )
    NavigationStack {
        DashboardView()
    }
    // Apply the environment object to the NavigationStack.
    .environmentObject(ExerciseSessionViewModel())
    .modelContainer(container)
}
