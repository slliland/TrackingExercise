//
//  ExerciseThumbnailView.swift
//  TrackingExercise
//
//  Created by Yujian Song on 4/14/25.
//

import SwiftUI
import MapKit

struct ExerciseThumbnailView: View {
    let coordinates: [CLLocationCoordinate2D]
    @State private var snapshotImage: UIImage? = nil

    var body: some View {
        Group {
            if let image = snapshotImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipped()
                    .cornerRadius(8)
            } else {
                ZStack {
                    Color(UIColor.secondarySystemBackground)
                        .frame(width: 150, height: 150)
                        .cornerRadius(8)
                    ProgressView()
                }
                .onAppear {
                    generateSnapshot()
                }
            }
        }
    }

    private func generateSnapshot() {
        guard !coordinates.isEmpty else { return }
        
        // Determine region to show
        let region: MKCoordinateRegion = {
            if coordinates.count == 1 {
                return MKCoordinateRegion(center: coordinates.first!,
                                          latitudinalMeters: 500,
                                          longitudinalMeters: 500)
            } else {
                var minLat = coordinates.first!.latitude
                var maxLat = coordinates.first!.latitude
                var minLon = coordinates.first!.longitude
                var maxLon = coordinates.first!.longitude
                
                coordinates.forEach { coordinate in
                    minLat = min(minLat, coordinate.latitude)
                    maxLat = max(maxLat, coordinate.latitude)
                    minLon = min(minLon, coordinate.longitude)
                    maxLon = max(maxLon, coordinate.longitude)
                }
                let center = CLLocationCoordinate2D(latitude: (minLat + maxLat)/2,
                                                    longitude: (minLon + maxLon)/2)
                let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*1.5,
                                            longitudeDelta: (maxLon - minLon)*1.5)
                return MKCoordinateRegion(center: center, span: span)
            }
        }()
        
        let options = MKMapSnapshotter.Options()
        options.region = region
        options.size = CGSize(width: 150, height: 150)
        options.scale = UIScreen.main.scale
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            guard let snapshot = snapshot, error == nil else { return }
            let image = snapshot.image
            
            // Draw the route on the snapshot.
            UIGraphicsBeginImageContextWithOptions(options.size, true, options.scale)
            image.draw(at: .zero)
            let context = UIGraphicsGetCurrentContext()
            context?.setStrokeColor(UIColor.red.cgColor)
            context?.setLineWidth(2)
            
            if let path = createPath(for: snapshot, coordinates: coordinates) {
                context?.addPath(path)
                context?.strokePath()
            }
            
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            DispatchQueue.main.async {
                self.snapshotImage = finalImage
            }
        }
    }
    
    private func createPath(for snapshot: MKMapSnapshotter.Snapshot,
                            coordinates: [CLLocationCoordinate2D]) -> CGPath? {
        guard coordinates.count > 1 else { return nil }
        let path = UIBezierPath()
        let firstPoint = snapshot.point(for: coordinates.first!)
        path.move(to: firstPoint)
        
        for coordinate in coordinates.dropFirst() {
            let point = snapshot.point(for: coordinate)
            path.addLine(to: point)
        }
        return path.cgPath
    }
}

#Preview {
    ExerciseThumbnailView(coordinates: [
        CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        CLLocationCoordinate2D(latitude: 37.7799, longitude: -122.4144),
        CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.4094)
    ])
}
