//
//  Preference.swift
//  SwiftyWeatherAVP
//
//  Created by Bob Witmer on 2025-09-12.
//

import Foundation
import SwiftData

@MainActor
@Model
class Preference {
    var locationName: String = ""
    var latString: String = ""
    var longString: String = ""
    var selectedUnit: UnitSystem = UnitSystem.imperial
    var degreeUnitShowing: Bool = true
    
    init(locationName: String = "", latString: String = "", longString: String = "", selectedUnit: UnitSystem = UnitSystem.imperial, degreeUnitShowing: Bool = true) {
        self.locationName = locationName
        self.latString = latString
        self.longString = longString
        self.selectedUnit = selectedUnit
        self.degreeUnitShowing = degreeUnitShowing
    }
}

extension Preference {
    
    static var preview: ModelContainer {
        let container = try! ModelContainer(for: Preference.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        // Add Mock Data Here
        container.mainContext.insert(Preference(locationName: "Dublin, Ireland", latString: "53.3498", longString: "-6.2603", selectedUnit: .imperial, degreeUnitShowing: true))
        
        return container
    }
}
