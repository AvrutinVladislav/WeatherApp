//
//  ContentView.swift
//  WeatherApp
//
//  Created by Vladislav Avrutin on 09.04.2024.
//

import SwiftUI

struct WeatherView: View {
    
    @StateObject var weatherViewModel = WeatherViewModel()
    private let locManager = LocationManager()
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            compactTopView()
            hourlyWeather()
            sevenDaysForecasts()
        }
        .onAppear {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                guard let cityName = locManager.cityName, !cityName.isEmpty else {
                    print("Error: City name is empty")
                    return }
                
                weatherViewModel.getWeatherResponse(cityName)
            }
        }
    }
    
    @ViewBuilder private func compactTopView() -> some View {
        
            if let weather = weatherViewModel.weather {
                VStack {
                    
                    HStack {
                        
                        customButton(title: "", image: "plus")
                        Spacer()
                        
                        Text(verbatim: weather.location.name)
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 25))
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            
                            Image(.threeDotsVertical)
                                .foregroundStyle(.white)
                                .frame(width: 32, height: 32)
                        }
                        
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    HStack {
                        
                        Image("\(weather.current.condition.code)")
                            .resizable()
                            .frame(width: 150, height: 150)
                        
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 10) {
                            
                            Text(verbatim: weatherViewModel.getWeekday())
                                .foregroundStyle(.white)
                                .font(.system(size: 20, weight: .regular))
                            
                            Text(verbatim: weatherViewModel.formateDateFromEpochTime(date: weather.location.localtime_epoch))
                                .foregroundStyle(.white)
                                .font(.system(size: 20, weight: .regular))
                            
                            Text(verbatim: "\(weather.current.temp_c)°C")
                                .font(.system(size: 45, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.top)
                            
                            Text(verbatim: weather.forecast.forecastday[0].day.condition.text)
                                .foregroundStyle(.white)
                                .font(.system(size: 15, weight: .regular))
                            
                        }
                        
                    }
                    .padding(.horizontal, 16)
                    
                    Divider()
                        .background(Color.black.opacity(1.0))
                        .padding(.horizontal, 16)
                        .frame(minHeight: 1.5)
                    
                    HStack {
                        
                        VStack {
                            weatherParametersCell(icon: .locationCurrent,
                                                  topText: "wind",
                                                  bottomText: "\((weather.current.wind_kph / 3.6).rounded(.up)) mPs")
                            
                            
                            weatherParametersCell(icon: .weatherRain,
                                                  topText: "rain",
                                                  bottomText: "\(weather.forecast.forecastday[0].day.daily_chance_of_rain) %")
                        }
                        Spacer()
                        VStack() {
                            weatherParametersCell(icon: .temperature,
                                                  topText: "pressure",
                                                  bottomText: "\(weatherViewModel.pressureConverter(pressure: Int(weather.current.pressure_mb))) mmHg") /*мм рт ст*/
                            
                            weatherParametersCell(icon: .ionWater,
                                                  topText: "humidity",
                                                  bottomText: "\(weather.current.humidity) %")
                        }
                    }
                    .padding(.init(top: 5, leading: 15, bottom: 10, trailing: 15))
                    
                }
                .background(LinearGradient(gradient: Gradient(colors: [.startMainGradient, .hourlyWeather]), startPoint: .top, endPoint: .bottom))
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.horizontal, 16)
            }
        }
    
    @ViewBuilder private func hourlyWeather() -> some View {
        
        if let weather = weatherViewModel.weather {
            
            let filtredHourlyWeather = weatherViewModel.getHourlyWeatherForecast(forecast: weather.forecast)
            
            VStack {
                
                ScrollView(.horizontal) {
                    
                    HStack(spacing: 20) {
                        ForEach(0..<24, id:\.self) { index in
                            
                            hourlyWeatherCell(icon: filtredHourlyWeather[index].condition.code,
                                              time: weatherViewModel.formateDateToHourMinute(date: filtredHourlyWeather[index].time),
                                              temp: filtredHourlyWeather[index].temp_c.description,
                                              chanceOfRain: filtredHourlyWeather[index].chance_of_rain.description)
                            
                        }
                    }
                    .padding(.all, 15)
                }
                
            }
            .background(Color(.hourlyWeather))
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding(.horizontal, 16)
            
        }
    }
    
    @ViewBuilder private func hourlyWeatherCell(icon: Int,
                                                time: String,
                                                temp: String,
                                                chanceOfRain: String) -> some View {
        
        VStack(spacing: 5) {
                
                Text(verbatim: time)
                Image("\(icon)")
                    .resizable()
                    .frame(width: 45, height: 45)
                Text(verbatim: "\(temp)°")
                Text(verbatim: "\(chanceOfRain)% rain")
            }
            .frame(minWidth: 70, minHeight: 100)
            .foregroundStyle(.white)
            .padding(.all, 5)
            .background(Color.black.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    @ViewBuilder private func sevenDaysForecasts() -> some View {
        
        VStack {
            if let weather = weatherViewModel.weather?.forecast.forecastday {
                ScrollView {
                    
                    HStack {
                        
                        Text(verbatim: "Forecats for 3 Days")
                            .foregroundStyle(.white)
                            .font(.system(size: 20, weight: .medium))
                            .padding(.init(top: 16, leading: 16, bottom: 0, trailing: 0))
                        
                        Spacer()
                    }
                    
                    ForEach(0..<weather.count, id:\.self) { index in
                        
                        dayWeatherCell(icon: weather[index].day.condition.code,
                                       chanceOfRain: weather[index].day.daily_chance_of_rain,
                                       minTemp: weather[index].day.mintemp_c,
                                       maxTemp: weather[index].day.maxtemp_c,
                                       date: weather[index].date)
                    }
                }
                .padding(.init(top: 0, leading: 16, bottom: 16, trailing: 16))
            }
        }
        .background(Color(.hourlyWeather))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder private func dayWeatherCell(icon: Int,
                                             chanceOfRain: Int,
                                             minTemp: Double,
                                             maxTemp: Double,
                                             date: String) -> some View {
        
        HStack {
            
            Text(verbatim: weatherViewModel.formateDate(date: date))
            Spacer()
            Image("\(icon)")
                .resizable()
                .frame(width: 40, height: 40)
            Spacer()
            Text(verbatim: "\(chanceOfRain)% rain")
            Spacer()
            Text(verbatim: "\(Int(minTemp))°/\(Int(maxTemp))°")
            
        }
        .foregroundStyle(.white)
        .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
        .background(Color.black.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
        
    
    @ViewBuilder private func customButton(title: String,
                                           image: String) -> some View {
        Button("", systemImage: "plus") {
            print("")
        }
        .foregroundStyle(.white)
        .frame(width: 32, height: 32)
        .dynamicTypeSize(.xxLarge)
    }
    
    @ViewBuilder private func weatherParametersCell(icon: ImageResource,
                                                    topText: String,
                                                    bottomText: String) -> some View {
        
        HStack {
            Spacer()
            Image(icon)
                .resizable()
                .frame(width: 40, height: 40)
            Spacer()
            VStack {
                
                Text(verbatim: topText)
                    .font(.system(size: 18, weight: .regular))
                
                Text(verbatim: bottomText)
                    .font(.system(size: 15, weight: .regular))
            }
            Spacer()
        }
        .foregroundStyle(.white)
        .frame(minWidth: 130)
        .padding(.all, 5)
        .background(Color.black.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
}

#Preview {
    WeatherView()
}

extension Notification.Name {
    static let name = Notification.Name("name")
}
