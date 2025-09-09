//
//  WeatherView.swift
//  SwiftyWeatherAVP
//
//  Created by Bob Witmer on 2025-09-08.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct WeatherView: View {
    @State var weatherVM: WeatherViewModel = WeatherViewModel()
    @State private var degreeUnit: String = "°F"
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.cyan.opacity(0.75))
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
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
                    Text("Wind: \(weatherVM.windSpeed.formatted(.number))mph - Feels Like: \(weatherVM.feelsLike.formatted(.number))\(degreeUnit)")
                        .font(.title2)
                        .padding(.bottom)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            //TODO: Add gear click action here
                        } label: {
                            Image(systemName: "gear")
                        }
                        
                    }
                }
            }
        }
        .task {
            await weatherVM.getData()
        }
    }
}

#Preview(windowStyle: .automatic) {
    WeatherView()
}
