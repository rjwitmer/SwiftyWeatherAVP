//
//  SwiftyWeatherAVPApp.swift
//  SwiftyWeatherAVP
//
//  Created by Bob Witmer on 2025-09-08.
//

import SwiftUI
import SwiftData

@main
struct SwiftyWeatherAVPApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherView()
                .modelContainer(for: Preference.self)
        }
    }
    
    
    // Will allow us to find where our simulator data is saved
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
