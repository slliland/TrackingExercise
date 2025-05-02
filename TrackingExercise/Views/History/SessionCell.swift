//
//  SessionCell.swift
//  TrackingExercise
//
//  Created by Yujian Song on 4/14/25.
//

import SwiftUI

struct SessionCell: View {
    let session: ExerciseSession
    
    var body: some View {
        HStack(spacing: 12) {
            // show a thumbnail based on the session's route if it is exists, otherwise, show a placeholder.
            if !session.locations.isEmpty {
                ExerciseThumbnailView(coordinates: session.locations.map { $0.clCoordinate })
            } else {
                Image(systemName: "map")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.gray)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Session on \(session.startTime, formatter: dateFormatter)")
                    .font(.headline)
                    .foregroundColor(.primary)
                if let endTime = session.endTime {
                    Text("Duration: \(durationText(start: session.startTime, end: endTime))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Text("Distance: \(session.distance, specifier: "%.2f") meters")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12)
                        .fill(Color(UIColor.secondarySystemBackground)))
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.vertical, 4)
        .padding(.horizontal)
    }
}

private var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}

private func durationText(start: Date, end: Date) -> String {
    let interval = end.timeIntervalSince(start)
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = .abbreviated
    formatter.zeroFormattingBehavior = .pad
    return formatter.string(from: interval) ?? ""
}

