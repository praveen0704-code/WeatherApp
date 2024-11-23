//
//  WeatherTestApp.swift
//  WeatherTest
//
//  Created by PraveenMAC on 22/11/24.
//

import SwiftUI

@main
struct WeatherTestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            WeaterSwiftUIView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
