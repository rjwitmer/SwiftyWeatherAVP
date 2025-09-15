//
//  WeatherView.swift
//  SwiftyWeatherAVP
//
//  Created by Bob Witmer on 2025-09-08.
//

import SwiftUI
import RealityKit
import RealityKitContent
import SwiftData

struct WeatherView: View {
    @Environment(\.modelContext) var modelContext
    @Query var preferences: [Preference]
    @State private var preference: Preference = Preference()

    @State var weatherVM: WeatherViewModel = WeatherViewModel()
    @State private var locationName: String = ""
    @State private var latString: String = ""
    @State private var longString: String = ""
    @State private var selectedUnit: UnitSystem = .imperial
    @State private var degreeUnitShowing: Bool = true
    @State private var degreeUnit: String = "°F"
    @State private var sheetIsPresented: Bool = false
    
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color(.cyan.opacity(0.75))
                    .ignoresSafeArea()
                
                VStack {
                    Text("\(locationName)")
                        .font(.largeTitle)
                    Image(systemName: weatherVM.getWeatherIcon(for: weatherVM.weatherCode))
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal)
                        .symbolRenderingMode(.multicolor)
                    Text(weatherVM.getWeatherDescription(for: weatherVM.weatherCode))
                        .font(.largeTitle)
                    Text("\(weatherVM.temperature.formatted(.number))\(degreeUnit)")
                        .font(.system(size: 150))
                        .fontWeight(.thin)
                    Text("Wind: \(weatherVM.windSpeed.formatted(.number))\(preference.selectedUnit == .imperial ? "mph" : "km/h") - Feels Like: \(weatherVM.feelsLike.formatted(.number))\(degreeUnit)")
                        .font(.title2)
                        .padding(.bottom)
                    
                    List(0..<weatherVM.date.count, id: \.self) { myIndex in
                        HStack(alignment: .top) {
                            Image(systemName: weatherVM.getWeatherIcon(for: weatherVM.dailyWeatherCode[myIndex]))
                                .padding(.horizontal)
                                .symbolRenderingMode(.multicolor)
                            Text("\(weatherVM.getWeekDay(value: myIndex + 1))") // Start one day in the future
//                            Text("\(weatherVM.date[myIndex])")
                            Spacer()
                            Text("High: \(weatherVM.dailyHighTemp[myIndex].formatted(.number))\(degreeUnit)")
                            Text("/")
                            Text("Low: \(weatherVM.dailyLowTemp[myIndex].formatted(.number))\(degreeUnit)")
                        }
                        .listRowBackground(Color.clear)
                        .font(.title2)
                        
                    }
                    .listStyle(.plain)

                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            sheetIsPresented.toggle()

                        } label: {
                            Image(systemName: "gear")
                        }
                        
                    }
                }
            }
        }
        .onChange(of: preferences) {
            Task {
                await callWeatherAPI()
            }
            Task {
                await weatherVM.getData()
            }
        }
        .task {
            await callWeatherAPI()
            await weatherVM.getData()
        }
        .fullScreenCover(isPresented: $sheetIsPresented) {
            PreferenceView()
        }
    }
}

extension WeatherView {
    func callWeatherAPI() async {
        if !preferences.isEmpty {
            preference = preferences.first!
            locationName = preference.locationName
            weatherVM.urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(preference.latString)&longitude=\(preference.longString)&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m,&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum&hourly=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m,uv_index&wind_speed_unit=\(preference.selectedUnit == .imperial ? "mph" : "kmh")&temperature_unit=\(preference.selectedUnit == .imperial ? "fahrenheit" : "celsius")&precipitation_unit=\(preference.selectedUnit == .imperial ? "inch" : "mm")&timezone=auto"
            degreeUnitShowing = preference.degreeUnitShowing
            degreeUnit = degreeUnitShowing ? preference.selectedUnit == .imperial ? "°F" : "°C" : "°"
        }
    }
}

#Preview(windowStyle: .automatic) {
    WeatherView()
        .modelContainer(Preference.preview)
}
