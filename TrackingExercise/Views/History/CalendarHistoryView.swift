//
//  CalendarHistoryView.swift
//  TrackingExercise
//
//  Created by Yujian Song on 4/14/25.
//

import SwiftUI
import SwiftData

/// A calendar view that displays days in a month.
/// A day is marked (with a dot) if an ExerciseSession exists on that day.
/// Now supports switching between months.
struct CalendarHistoryView: View {
    let sessions: [ExerciseSession]
    
    // Track the currently displayed month.
    @State private var currentMonth: Date = Date()
    
    // A computed property to show the current month and year as a string.
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: currentMonth)
    }
    
    // Compute the set of marked dates
    private var markedDates: Set<Date> {
        let calendar = Calendar.current
        return Set(sessions.map { calendar.startOfDay(for: $0.startTime) })
    }
    
    // Get an array of all days in the selected month.
    private var currentMonthDays: [Date] {
        let calendar = Calendar.current
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else { return [] }
        // Calculate the number of days in the month.
        let dayCount = calendar.dateComponents([.day], from: monthInterval.start, to: monthInterval.end).day ?? 1
        return (0..<dayCount).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: monthInterval.start)
        }
    }
    
    // Grid layout with 7 columns (one per weekday).
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // Month navigation header
            HStack {
                Button(action: {
                    if let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) {
                        currentMonth = previousMonth
                    }
                }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(monthYearString)
                    .font(.title2)
                    .bold()
                Spacer()
                Button(action: {
                    if let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) {
                        currentMonth = nextMonth
                    }
                }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Weekday headers.
            HStack {
                ForEach(Calendar.current.shortStandaloneWeekdaySymbols, id: \.self) { weekday in
                    Text(weekday)
                        .font(.footnote)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            
            // Calendar grid.
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(currentMonthDays, id: \.self) { day in
                    VStack {
                        Text("\(Calendar.current.component(.day, from: day))")
                            .font(.body)
                            .foregroundColor(.primary)
                        if markedDates.contains(day) {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 6, height: 6)
                        } else {
                            Spacer().frame(height: 6)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(UIColor.secondarySystemBackground))
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    CalendarHistoryView(sessions: [])
}
