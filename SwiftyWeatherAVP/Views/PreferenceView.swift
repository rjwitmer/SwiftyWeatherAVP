//
//  PreferenceView.swift
//  SwiftyWeatherAVP
//
//  Created by Bob Witmer on 2025-09-11.
//

import SwiftUI
import SwiftData

struct PreferenceView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query var preferences: [Preference]
    
    @State private var locationName: String = "Kitchener"
    @State private var latString: String = "43.4254"
    @State private var longString: String = "-80.5112"
    @State private var selectedUnit: UnitSystem = UnitSystem.imperial
    @State private var degreeUnitShowing: Bool = true
    var degreeUnit: String {
        if degreeUnitShowing {
            return selectedUnit == .imperial ? "F" : "C"
        }
        return ""
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                TextField("location", text: $locationName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom)
                
                Text("Latitude:")
                    .bold()
                TextField("latitude", text: $latString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Longitude:")
                    .bold()
                TextField("longitude", text: $longString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom)
                HStack(alignment: .firstTextBaseline, spacing: 60) {
                    Text("Units:")
                        .bold()
                    Spacer()
                    Picker("Units:", selection: $selectedUnit) {
                        ForEach(UnitSystem.allCases, id: \.self) { unit in
                            Text(unit.rawValue.capitalized)
                                .font(.title)
                        }
                    }
                    .padding(.bottom)
                }
                
                Toggle("Show F/C after temp value:", isOn: $degreeUnitShowing)
                    .bold()
                
                
                HStack {
                    Spacer()
                    Text("42°\(degreeUnit)")
                        .font(.system(size: 150))
                        .fontWeight(.thin)
                    Spacer()
                }
            }
            .padding()
            .font(.title2)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        if !preferences.isEmpty {
                            for preference in preferences {
                                modelContext.delete(preference)
                            }
                        }
                        let preference = Preference(locationName: locationName, latString: latString, longString: longString, selectedUnit: selectedUnit, degreeUnitShowing: degreeUnitShowing)
                        modelContext.insert(preference)
                        guard let _ = try? modelContext.save() else {
                            print("😡 ERROR: Could not save preferences")
                            return
                        }
                        dismiss()
                    }
                }
            }
        }
        .task {
            guard !preferences.isEmpty else { return }
            let preference = preferences.first!
            locationName = preference.locationName
            latString = preference.latString
            longString = preference.longString
            selectedUnit = preference.selectedUnit
            degreeUnitShowing = preference.degreeUnitShowing
        }
        
    }
}

#Preview {
    PreferenceView()
        .modelContainer(Preference.preview)
}
