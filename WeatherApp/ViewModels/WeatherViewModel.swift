//
//  HourlyWeatherViewModel.swift
//  WeatherApp
//
//  Created by Vladislav Avrutin on 17.04.2024.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    
    @Published var weather: WeatherResponse?
    
    private var cancellables: Set<AnyCancellable> = []
    private let locationManager = LocationManager()
    private let networkManager = NetworkManager()
    
    func getWeatherResponse() {
        locationManager.$cityName
            .subscribe(on: DispatchQueue.main)
            .sink {[weak self] cityName in
                guard let cityName, let self  else { return }
                self.networkManager.fetchHourlyWeather(cityName)
                    .sink { complition in
                        switch complition {
                        case .failure(let error):
                            print("Error: \(error)")
                        default: break
                        }
                    } receiveValue: { [weak self] weatherResponse in
                        DispatchQueue.main.async {
                            self?.weather = weatherResponse
                        }
                    }
                    .store(in: &self.cancellables)
            }
    }
    
}
    
    extension WeatherViewModel {
        
        func getWeekday() -> String {
            
            let calendar = Calendar.current
            let weekday = calendar.component(.weekday, from: Date())
            return DateFormatter().weekdaySymbols[weekday - 1]
        }
        
        func formateDateFromEpochTime(date: Int) -> String {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            guard let responseDate = formatter.date(from: String(date)) else { return formatter.string(from: Date()) }
            return formatter.string(from: responseDate)
        }
        
        func formateDate(date: String) -> String {

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            guard let dateFromParseString = dateFormatter.date(from: date) else { return ""}
            return dateFormatter.string(from: dateFromParseString)
        }
        
        func formateDateToHourMinute(date: String) -> String {
            
            var result = ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            if let formatedDate = dateFormatter.date(from: date) {
                let calendar = Calendar.current
                let components = calendar.dateComponents([.hour, .minute], from: formatedDate)
            
                if let hour = components.hour, let minute = components.minute {
                    result = "\(hour):\(minute)0"
                }
            }
           
            return result
        }
        
        func pressureConverter(pressure: Int) -> String {
            
            return Int(Double(pressure) * 0.75).description
        }
        
        // Функция для получения текущего часа
        func getCurrentHour() -> Int {
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour], from: Date())
            return components.hour ?? 0
        }
        
        // Функция для получения текущего дня
        func getCurrentDay() -> String {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: Date())

        }
        
        // Функция для получения прогноза погоды для текущего часа и следующих 24 часов
        func getHourlyWeatherForecast(forecast: Forecast) -> [Hour] {
            
            var remainingHours = 24
            var dayIndexHourlyRequest = 0
            var currentHour = getCurrentHour()
            var filteredForecast: [Hour] = []
            
            // Итерируемся по дням, начиная с текущего
            while remainingHours > 0 {
                
                let currentDayForecast = forecast.forecastday[dayIndexHourlyRequest]
                
                // Добавляем прогноз для текущего часа и последующих
                for i in currentHour..<currentDayForecast.hour.count {
                    filteredForecast.append(currentDayForecast.hour[i])
                    remainingHours -= 1
                    if remainingHours == 0 {
                        break
                    }
                }
                
                // Переходим к следующему дню
                dayIndexHourlyRequest += 1
                currentHour = 0
            }
            
            return filteredForecast
        }
        
        func selectLocation() {
            
        }
    }
