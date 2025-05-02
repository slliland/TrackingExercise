//
//  TrackingExerciseApp.swift
//  TrackingExercise
//
//  Created by Yujian Song on 4/14/25.
//

import SwiftUI
import SwiftData

@main
struct TrackingExerciseApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([ExerciseSession.self, User.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()
    
    @StateObject private var viewModel = ExerciseSessionViewModel()

    var body: some Scene {
        WindowGroup {
            // Provide the view model to the view hierarchy
            ContentView()
                .environmentObject(viewModel)
        }
        .modelContainer(sharedModelContainer)
    }
}

