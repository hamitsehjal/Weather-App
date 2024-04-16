//
//  WeatherDataSource.swift
//  Weather App
//
//  Created by Hamit Sehjal on 2024-04-15.
//

import Foundation
import UIKit

class WeatherDataSource:NSObject,UITableViewDataSource{
    
    var cityList = [WeatherDetail]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "CityWeatherCell", for: indexPath)
        
        let city=cityList[indexPath.row]
        print("Name of city is \(city.cityName)")
        cell.textLabel?.text=city.cityName
        cell.detailTextLabel?.text="\(city.temperature)(\(city.description))"
        return cell
    }
    
    
}
