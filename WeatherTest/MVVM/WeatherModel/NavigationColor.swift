//
//  NavigationColor.swift
//  WeatherTest
//
//  Created by PraveenMAC on 23/11/24.
//

import Foundation
import SwiftUI

class NavigationViewModel: ObservableObject {
    init() {
        setupNavigationBarAppearance()
    }

     func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.clear // Navigation bar background color
        appearance.titleTextAttributes = [.foregroundColor: UIColor.red] // Title color
        
        // Apply the appearance settings globally
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
}
