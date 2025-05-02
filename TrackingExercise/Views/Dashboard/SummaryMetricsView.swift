//
//  SummaryMetricsView.swift
//  TrackingExercise
//
//  Created by Yujian Song on 4/14/25.
//

import SwiftUI

/// Displays summary metrics (total distance) for a set of sessions.
struct SummaryMetricsView: View {
    var sessions: [ExerciseSession]
    
    // Calculate the total distance from the sessions.
    var totalDistance: Double {
        sessions.reduce(0) { $0 + $1.distance }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Total Distance: \(totalDistance, specifier: "%.2f") meters")
                .font(.headline)
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(12)
    }
}

#Preview {
    SummaryMetricsView(sessions: [])
}
