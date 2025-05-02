//
//  HistoryView.swift
//  TrackingExercise
//
//  Created by Yujian Song on 4/14/25.
//

import SwiftUI
import SwiftData

enum HistoryTab: String, CaseIterable {
    case list = "List"
    case calendar = "Calendar"
}

/// HistoryView allows the user to switch between a list view and a calendar view.
struct HistoryView: View {
    // Fetch all sessions sorted by start time (latest first).
    @Query(sort: \ExerciseSession.startTime, order: .reverse) var sessions: [ExerciseSession]
    
    // Used to switch between list and calendar modes.
    @State private var selectedTab: HistoryTab = .list
    
    // Inject the ModelContext from the environment.
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            VStack {
                // Top segmented control for switching modes.
                Picker("History Mode", selection: $selectedTab) {
                    ForEach(HistoryTab.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.top, 16)
                
                Divider()
                    .padding(.horizontal)
                
                // Display the selected view.
                if selectedTab == .list {
                    historyListView
                } else {
                    CalendarHistoryView(sessions: sessions)
                }
                
                Spacer()
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("History")
        }
    }
    
    // MARK: - List Mode
    private var historyListView: some View {
        List {
            ForEach(sessions) { session in
                SessionCell(session: session)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
            .onDelete(perform: deleteSession)
        }
        .listStyle(PlainListStyle())
    }
    
    // Delete function to remove sessions.
    private func deleteSession(at offsets: IndexSet) {
        for index in offsets {
            let session = sessions[index]
            modelContext.delete(session)
        }
    }
}

#Preview {
    NavigationStack {
        HistoryView()
    }
}

