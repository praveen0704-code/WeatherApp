//
//  ForcastModel.swift
//  WeatherTest
//
//  Created by PraveenMAC on 23/11/24.
//

import Foundation
struct ForecastResponse: Decodable {
    let list: [ForecastItem]
    let city: City
}

struct ForecastItem: Decodable {
    let dt: TimeInterval
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let rain: Rain?
    let dt_txt: String
}

struct Rain: Decodable {
    let threeHourVolume: Double?

    private enum CodingKeys: String, CodingKey {
        case threeHourVolume = "3h"
    }
}

struct City: Decodable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: TimeInterval
    let sunset: TimeInterval
}

struct DailyForecast: Identifiable {
    let id = UUID()
    let date: String
    let minTemp: Double
    let maxTemp: Double
}
