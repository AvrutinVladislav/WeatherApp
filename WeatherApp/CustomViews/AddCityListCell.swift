//
//  AddCityListCell.swift
//  WeatherApp
//
//  Created by Vladislav Avrutin on 25.04.2024.
//

import SwiftUI

struct AddCityListCell: View {
    
    private let viewModel = WeatherViewModel()
    private var city = "London"
    private var isSelected = true
    @State private var minMaxTemp = "temp"
    
    var body: some View {
        if let weather = viewModel.weather?.forecast.forecastday[0].day {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(verbatim: city)
                                .font(.system(size: 20, weight: .medium))
                            if isSelected {
                                Image(systemName: "checkmark.circle")
                            }
                        }
                        HStack {
                            Text(verbatim: "\(weather.mintemp_c)°/\(weather.maxtemp_c)°")
                        }
                    }
                    .padding(.leading, 16)
                    Spacer()
                    VStack(alignment: .leading) {
                        Image("\(weather.condition.code)")
                            .resizable()
                            .frame(width: 45, height: 45)
                        Text(verbatim: weather.condition.text)
                    }
                    .padding(16)
                }
                .background(.white)
                .foregroundStyle(.black)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.horizontal, 16)
            }
            .background(.blue)
            Spacer()
        }
    }
}

#Preview {
    AddCityListCell()
}
