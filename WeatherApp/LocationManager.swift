//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Vladislav Avrutin on 15.04.2024.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    
    private var locationManager = CLLocationManager()
    var cityName: String?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
    }
    
    func requestLocation() {
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else { return }
        let geoCoder = CLGeocoder()
        let coordinats = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        geoCoder.reverseGeocodeLocation(coordinats) { placemarks, error in
            
            guard let placeMark = placemarks?.first else { return }
            if let city = placeMark.locality {
                self.cityName = city
            }
        }
       
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        requestLocation()
    }
}

