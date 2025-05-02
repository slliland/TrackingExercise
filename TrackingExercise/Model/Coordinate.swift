//
//  Coordinate.swift
//  TrackingExercise
//
//  Created by Yujian Song on 4/14/25.
//

import CoreLocation

struct Coordinate: Codable, Hashable {
    var latitude: Double
    var longitude: Double

    // Convenience computed property to convert to CLLocationCoordinate2D.
    var clCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // Initializer from CLLocationCoordinate2D
    init(clCoordinate: CLLocationCoordinate2D) {
        self.latitude = clCoordinate.latitude
        self.longitude = clCoordinate.longitude
    }
}

