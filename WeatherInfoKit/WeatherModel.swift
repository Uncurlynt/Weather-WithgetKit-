//
//  WeatherModel.swift
//  Weather
//
//  Created by Артемий Андреев  on 26.10.2023.
//

import Foundation

public struct WeatherModel {
    public let conditionId: Int
    public let cityName: String
    public let temperature: Double
    
    public var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    public  var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
}
