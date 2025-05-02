//
//  ExerciseSessionViewModel.swift
//  TrackingExercise
//
//  Created by Yujian Song on 4/14/25.
//

import Foundation
import Combine
import SwiftData
import CoreLocation

final class ExerciseSessionViewModel: ObservableObject {
    @Published var session: ExerciseSession?
    @Published var isSessionActive = false
    
    var locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    // Add a property to hold a reference to the model context.
    var modelContext: ModelContext?
    
    init() {
        // Subscribe to location updates.
        locationManager.$locations
            .sink { [weak self] coords in
                guard let self = self, self.isSessionActive else { return }
                // Convert CLLocationCoordinate2D to your persistable Coordinate type.
                self.session?.locations = coords.map { Coordinate(clCoordinate: $0) }
            }
            .store(in: &cancellables)
    }
    
    /// Starts a new exercise session.
    func startSession() {
        guard let context = modelContext else {
            print("ModelContext is nil")
            return
        }
        let newSession = ExerciseSession(startTime: Date(), locations: [])
        context.insert(newSession)
        session = newSession
        isSessionActive = true
        locationManager.startUpdates()
    }
    
    /// Stops the active exercise session.
    func stopSession() {
        locationManager.stopUpdates()
        isSessionActive = false
        session?.endTime = Date()
        // Changes are automatically tracked by SwiftData.
    }
}
