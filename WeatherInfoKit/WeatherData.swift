//
//  WeatherData.swift
//  Weather
//
//  Created by Артемий Андреев  on 26.10.2023.
//

import Foundation

public struct WeatherData: Decodable {
    public let name: String
    public let main: Main
    public let weather: [Weather]
}

public struct Main: Decodable {
    public let temp: Double
}

public struct Weather: Decodable {
    public let description: String
    public let id: Int
}

