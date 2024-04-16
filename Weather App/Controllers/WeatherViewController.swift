//
//  WeatherViewController.swift
//  Weather App
//
//  Created by Hamit Sehjal on 2024-04-15.
//

import UIKit

class WeatherViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var store:WeatherStore!
    
    let weatherDataSource = WeatherDataSource()
    
    var citiesToVisit:[CityDetail]=[
        CityDetail(name: "Toronto", longitude: 43.653225, latitude: -79.383186),
//        CityDetail(name: "Brampton", longitude: 43.653225, latitude: -79.383186),
//        CityDetail(name: "London", longitude: 43.653225, latitude: -79.383186)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set an instance of WeatherDataSource as tableView's datasource
        tableView.dataSource=weatherDataSource
        
        for city in citiesToVisit{
            store.fetchCityWeather(lon: city.longitude, lat: city.latitude){
                (weatherResult) in
                
                switch weatherResult{
                case let .success(weatherDetails):
                    print("Successfull fetched weatehr details for city: \(city.name)")
                    if weatherDetails.cityName.isEmpty{
                        weatherDetails.cityName=city.name
                    }
                    self.weatherDataSource.cityList.append(weatherDetails)
//                    print(self.weatherDataSource.cityList.count)
                    print(weatherDetails.cityName)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    

                case let .failure(error):
                    print("Error fetching weather details for city: \(city.name) Error - \(error)")
                }
            }
            
            }
        
        // Do any additional setup after loading the view.
        
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
