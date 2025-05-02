//
//  SettingsView.swift
//  TrackingExercise
//
//  Created by Yujian Song on 4/14/25.
//

import SwiftUI

struct SettingsView: View {
    // Persist user preferences
    @AppStorage("colorSchemePreference") private var colorSchemePreference: String = "system"
    @AppStorage("showNotifications") private var showNotifications = true

    let colorSchemes = [
        ("system", "System", "gearshape"),
        ("light", "Light", "sun.max"),
        ("dark", "Dark", "moon.fill")
    ]

    var body: some View {
        NavigationStack {
            Form {
                // Appearance section
                Section(header: Text("Appearance")) {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(colorSchemes, id: \.0) { id, name, icon in
                            Button(action: {
                                withAnimation {
                                    colorSchemePreference = id
                                }
                            }) {
                                HStack {
                                    Label(name, systemImage: icon)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    if colorSchemePreference == id {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(10)
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(8)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.vertical, 4)
                }

                // Preferences section
                Section(header: Text("Preferences")) {
                    Toggle("Show Notifications", isOn: $showNotifications)
                }

                // About section
                Section(header: Text("About")) {
                    Text("Version 2.0")
                    Text("© 2025 by Yujian Song")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
        }
        .previewDisplayName("Settings View")
    }
}
