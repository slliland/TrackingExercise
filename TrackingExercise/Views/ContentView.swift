//
//  ContentView.swift
//  TrackingExercise
//
//  Created by Yujian Song on 4/14/25.
//


import SwiftUI

struct ContentView: View {
    @StateObject var authViewModel = AuthenticationViewModel()
    @AppStorage("colorSchemePreference") private var colorSchemePreference: String = "system"

    init() {
        // Apply our custom navigation appearance.
        applyNavigationAppearance()
        
        // Configure the UITabBar appearance as needed.
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.systemBackground

        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }

    var body: some View {
        NavigationStack {
            TabView {
                DashboardView()
                    .environmentObject(authViewModel)
                    .tabItem {
                        Label("Dashboard", systemImage: "heart.fill")
                    }
                HistoryView()
                    .tabItem {
                        Label("History", systemImage: "clock.fill")
                    }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProfileView().environmentObject(authViewModel)) {
                        Image(systemName: "person.circle")
                    }
                }
            }
            .navigationTitle("Health Tracker")
        }
        .preferredColorScheme(colorSchemePreference == "system"
                              ? nil
                              : (colorSchemePreference == "light" ? .light : .dark))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
