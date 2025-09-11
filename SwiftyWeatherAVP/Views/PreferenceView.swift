//
//  PreferenceView.swift
//  SwiftyWeatherAVP
//
//  Created by Bob Witmer on 2025-09-11.
//

import SwiftUI

struct PreferenceView: View {
    @State private var locationName: String = "Kitchener, ON, Canada"
    @State private var latString: String = "43.4254"
    @State private var longString: String = "80.5112"
    @State private var unitPreference: UnitSystem = UnitSystem.imperial
    @State private var degreeUnitShowing: Bool = true
    var degreeUnit: String {
        if degreeUnitShowing {
            return unitPreference == .imperial ? "F" : "C"
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
                    Picker("Units:", selection: $unitPreference) {
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
        }
        
        
    }
}

#Preview {
    PreferenceView()
}
