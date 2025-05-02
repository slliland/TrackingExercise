//
//  ExerciseSession.swift
//  TrackingExercise
//
//  Created by Yujian Song on 4/14/25.
//

import Foundation
import CoreLocation
import SwiftData

@Model
final class ExerciseSession: Identifiable {
    var id = UUID()
    var startTime: Date
    var endTime: Date?
    // Update the type of locations from CLLocationCoordinate2D to Coordinate.
    var locations: [Coordinate]
    
    var distance: Double {
        guard locations.count > 1 else { return 0 }
        var total = 0.0
        for i in 1..<locations.count {
            let previous = CLLocation(latitude: locations[i - 1].latitude, longitude: locations[i - 1].longitude)
            let current = CLLocation(latitude: locations[i].latitude, longitude: locations[i].longitude)
            total += previous.distance(from: current)
        }
        return total
    }
    
    init(startTime: Date, locations: [Coordinate] = []) {
        self.startTime = startTime
        self.locations = locations
    }
}
