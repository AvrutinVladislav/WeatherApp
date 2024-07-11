//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Vladislav Avrutin on 11.07.2024.
//

import Foundation
import Combine

final class NetworkManager {
    
    private let apiKey = "aa23208b1c1944de8f790230241204"
    
    func fetchHourlyWeather(_ cityName: String) -> AnyPublisher<WeatherResponse, Error> {
        let url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(cityName)&days=7&aqi=no&alerts=no")
        return URLSession.shared.dataTaskPublisher(for: url!)
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
