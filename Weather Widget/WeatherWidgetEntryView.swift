//
//  Weather_WidgetBundle.swift
//  Weather Widget
//
//  Created by Артемий Андреев  on 26.10.2023.
//

import SwiftUI
import WidgetKit
import Foundation

struct WeatherWidgetEntryView: View {
    var entry: WeatherProvider.Entry
    
    var body: some View {
        VStack {
            Text("Moscow")
                .font(.title)
                .fontWeight(.bold)
            
            Text("\(String(format: "%.1f", entry.weatherData.temperature))°C")

            
                .font(.title)
                .fontWeight(.semibold)
            
            Text(entry.weatherData.description)
                .font(.caption)
        }
        .padding()
    }
}

