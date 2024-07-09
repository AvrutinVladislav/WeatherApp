//
//  AddCityCellModel.swift
//  WeatherApp
//
//  Created by Vladislav Avrutin on 29.04.2024.
//

import Foundation

struct AddCityCellModel: Identifiable {
    
    var id = UUID()
    var cityName: String
    var minTemp: String
    var maxTemp: String
    var conditionIconCode: Int
    var conditionText: String
}
