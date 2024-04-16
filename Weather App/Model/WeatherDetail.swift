//
//  WeatherDetail.swift
//  Weather App
//
//  Created by Hamit Sehjal on 2024-04-15.
//

import Foundation
import UIKit

class WeatherDetail: Codable{
    var cityName:String
    let description:String
    let temperature:Double
    let imageIdentifier:String
//    
    init(name:String,description: String, temperature: Double, icon: String) {
        self.cityName=name
        self.description = description
        self.temperature = temperature
        self.imageIdentifier = icon
    }
    
    enum CodingKeys:String, CodingKey{
        case cityName = "name"
        case description
        case temperature = "temp"
        case imageIdentifier = "icon"
    }
}
