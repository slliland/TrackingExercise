//
//  LocationManager.swift
//  TrackingExercise
//
//  Created by Yujian Song on 4/14/25.
//

import Foundation
import CoreLocation
import Combine

/// Manages location updates using Core Location.
final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var currentLocation: CLLocation?
    @Published var locations: [CLLocationCoordinate2D] = []
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .fitness
        
        // Request location authorization when the instance is created.
        manager.requestWhenInUseAuthorization()
    }
    
    /// Starts tracking location updates.
    func startUpdates() {
        locations.removeAll()
        manager.startUpdatingLocation()
    }
    
    /// Stops location tracking.
    func stopUpdates() {
        manager.stopUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations newLocations: [CLLocation]) {
        guard let latest = newLocations.last else { return }
        DispatchQueue.main.async {
            self.currentLocation = latest
            self.locations.append(latest.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
}


