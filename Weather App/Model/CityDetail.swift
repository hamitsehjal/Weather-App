//
//  CityDetail.swift
//  Weather App
//
//  Created by Hamit Sehjal on 2024-04-15.
//

import Foundation

class CityDetail{
    let name:String
    let longitude:Double
    let latitude:Double
    
    init(name: String, longitude: Double, latitude: Double) {
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
    }
}
