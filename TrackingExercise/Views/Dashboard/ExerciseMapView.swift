//
//  ExerciseMapView.swift
//  TrackingExercise
//
//  Created by Yujian Song on 4/14/25.
//

import SwiftUI
import MapKit

/// A UIViewRepresentable that wraps an MKMapView to display a polyline based on exercise coordinates.
struct ExerciseMapView: UIViewRepresentable {
    var coordinates: [CLLocationCoordinate2D]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Clear any existing overlays.
        mapView.removeOverlays(mapView.overlays)
        // Draw the polyline if there are any recorded coordinates.
        if !coordinates.isEmpty {
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(polyline)
            let rect = polyline.boundingMapRect
            mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    /// Coordinator to handle MKMapViewDelegate methods.
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: ExerciseMapView
        
        init(_ parent: ExerciseMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = UIColor { traitCollection in
                    traitCollection.userInterfaceStyle == .dark ? .cyan : .blue
                }
                renderer.lineWidth = 4.0
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

#Preview {
    ExerciseMapView(coordinates: [
        CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.4094),
        CLLocationCoordinate2D(latitude: 37.7949, longitude: -122.3994)
    ])
    .modelContainer(for: ExerciseSession.self, inMemory: true)
}
