//
//  WeatherStore.swift
//  Weather App
//
//  Created by Hamit Sehjal on 2024-04-15.
//

import Foundation

class WeatherStore{
    private let session:URLSession={
        return URLSession(configuration: URLSessionConfiguration.default)
    }()
    
    func fetchCityWeather(lon longitude:Double,lat latitude:Double,completion: @escaping (Result<WeatherDetail,Error>)->Void){
        let url=ServiceAPI.cityWeatherURL(["lon":"\(longitude)","lat":"\(latitude)"])
        let request=URLRequest(url: url)
        let task=session.dataTask(with: request){
            (data,response,error) in
            let result=self.processWeatherDataRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    // function that processes the JSON Data returned from the web service request(weather details)
    private func processWeatherDataRequest(data:Data?,error:Error?)->Result<WeatherDetail,Error>{
        guard let jsonData=data else{
            return .failure(error!)
        }
        if let jsonString=String(data: jsonData, encoding: .utf8){
            print(jsonString)
        }
        return ServiceAPI.decodeWeatherData(fromJSON: jsonData)
    }
    
}
