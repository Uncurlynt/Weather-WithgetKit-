//
//  Weather_Widget.swift
//  Weather Widget
//
//  Created by Артемий Андреев  on 26.10.2023.
//

import WidgetKit
import SwiftUI
import Intents

struct WeatherEntry: TimelineEntry {
    let date: Date
    let weatherData: WidgetWeatherData
}

struct WidgetWeatherData: Decodable {
    let temperature: Double
    let description: String
}

struct WidgetWeatherResponse: Decodable {
    struct Main: Decodable {
        let temp: Double
    }
    
    struct Weather: Decodable {
        let description: String
    }
    
    let main: Main
    let weather: [Weather]
}


struct WeatherProvider: TimelineProvider {
    typealias Entry = WeatherEntry
    
    func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry(date: Date(),
                     weatherData: WidgetWeatherData(temperature: 20.0,
                                              description: "Placeholder"))
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> ()) {
        let entry = WeatherEntry(date: Date(),
                                 weatherData: WidgetWeatherData(temperature: 20.0,
                                                          description: "Sunny Placeholder"))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> ()) {
        fetchWeatherData { weatherData in
            let currentDate = Date()
            let entry = WeatherEntry(date: currentDate, weatherData: weatherData)
            let midnight = Calendar.current.startOfDay(for: currentDate)
            let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
            let timeline = Timeline(entries: [entry], policy: .after(nextMidnight))
            completion(timeline)
        }
    }
    func fetchWeatherData(completion: @escaping (WidgetWeatherData) -> ()) {
        let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=ac4bc0f4ba46a52c3650fcae9b780649&units=metric"

        let urlString = "\(weatherURL)&q=Moscow"

        // Создаем url из строки
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Empty Response")
                return
            }
            
            print("Response status code: \(response.statusCode)")
            
            guard let safeData = data else {
                print("Empty Data")
                return
            }

            do {
                // Декодируем ответ
                let decoder = JSONDecoder()

                let decodedData = try decoder.decode(WidgetWeatherResponse.self, from: safeData)
                let temp = decodedData.main.temp
                let description = decodedData.weather.first?.description ?? "N/A"

                let weatherData = WidgetWeatherData(temperature: temp, description: description)
                                
                // Возвращаем результат
                completion(weatherData)
            } catch let error {
                print("Error Decoding \(error.localizedDescription)")
            }
        }
        // Начинаем задачу
        task.resume()
    }
}


struct WeatherWidget: Widget {
    private let kind = "WeatherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WeatherProvider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .configurationDisplayName("Weather Widget")
        .description("Displays the current weather")
    }
}

@main
struct WeatherWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        WeatherWidget()
    }
}
