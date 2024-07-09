//
//  AddCity.swift
//  WeatherApp
//
//  Created by Vladislav Avrutin on 25.04.2024.
//

import SwiftUI

struct AddCity: View {
    @State private var searchCity = ""
    @State private var citiesArray: [AddCityCellModel] = []
    
    var body: some View {
        VStack {
            HStack(spacing: 40) { //добавить акшен
                Button("", systemImage: "arrow.backward", action: {})
                    .frame(width: 32, height: 32)
                    .dynamicTypeSize(.xxLarge)
                    .padding()
                Text(verbatim: "Manager Locations")
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                Spacer()
            }
            .foregroundStyle(.white)
            
            Spacer()
            
            SearchBar(text: $searchCity)
                .padding()
            
            Spacer()
            
            List(citiesArray) { index in
                
            }
            
        }
        .background(LinearGradient(gradient: Gradient(colors: [.startMainGradient, .hourlyWeather]), startPoint: .top, endPoint: .bottom))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .padding(.horizontal, 16)
        
    }
    
    
}

#Preview {
    AddCity()
}
