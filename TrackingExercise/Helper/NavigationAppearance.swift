//
//  NavigationAppearance.swift
//  TrackingExercise
//
//  Created by Yujian Song on 4/14/25.
//

import UIKit

func applyNavigationAppearance() {
    let navBarAppearance = UINavigationBarAppearance()
    navBarAppearance.configureWithOpaqueBackground()
    
    // Use a dynamic color for the navigation bar background.
    navBarAppearance.backgroundColor = UIColor { traitCollection in
        // Choose different colors for light and dark mode.
        return traitCollection.userInterfaceStyle == .dark ? UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0) : UIColor.systemGreen
    }
    
    // Set a handwriting-style font for the navigation titles.
    let largeFont = UIFont(name: "Avenir-Heavy", size: 34) ?? UIFont.systemFont(ofSize: 34, weight: .bold)
    let inlineFont = UIFont(name: "Avenir-Heavy", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .semibold)
    
    navBarAppearance.largeTitleTextAttributes = [
        .foregroundColor: UIColor.white,
        .font: largeFont
    ]
    
    navBarAppearance.titleTextAttributes = [
        .foregroundColor: UIColor.white,
        .font: inlineFont
    ]
    
    // Apply the appearance to all navigation bars.
    UINavigationBar.appearance().standardAppearance = navBarAppearance
    UINavigationBar.appearance().compactAppearance = navBarAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    
    // Set the tint color for bar button items.
    UINavigationBar.appearance().tintColor = .white
}
