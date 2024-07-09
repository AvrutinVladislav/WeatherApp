//
//  HourlyWeatherModel.swift
//  WeatherApp
//
//  Created by Vladislav Avrutin on 17.04.2024.
//

import Foundation


struct WeatherResponse: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast
}

// MARK: - Current
struct Current: Codable {

    let last_updated: String
    let temp_c, temp_f: Double
    let condition: Condition
    let wind_mph, wind_kph: Double
//    let wind_dir: WindDir
    let pressure_mb: Double
    let humidity, cloud: Int
    let feelslike_c, feelslike_f, vis_km, vis_miles: Double
    }

// MARK: - Condition
struct Condition: Codable {
    let text, icon: String
    let code: Int
}

// MARK: - Forecast
struct Forecast: Codable {
    let forecastday: [Forecastday]
}

// MARK: - Forecastday
struct Forecastday: Codable {
    let date: String
    let date_epoch: Int
    let day: Day
    let hour: [Hour]
}

// MARK: - Day
struct Day: Codable {
    let maxtemp_c, maxtemp_f, mintemp_c, mintemp_f: Double
    let avgtemp_c, avgtemp_f, maxwind_mph, maxwind_kph: Double
    let avghumidity, daily_chance_of_rain: Int
    let condition: Condition
}

// MARK: - Hour
struct Hour: Codable {
    let time: String
    let temp_c, temp_f: Double
    let condition: Condition
    let wind_mph, wind_kph: Double
//    let wind_dir: WindDir
    let pressure_mb: Double
    let humidity, cloud: Int
    let feelslike_c, feelslike_f: Double
    let chance_of_rain: Int
}

// MARK: - Location
struct Location: Codable {
    let name, region, country: String
    let lat, lon: Double
    let tz_id: String
    let localtime_epoch: Int
    let localtime: String
}

enum WindDir: Codable {
    case n
    case nne
    case nnw
    case nw
    case w
    case wnw
    case wsw
}

