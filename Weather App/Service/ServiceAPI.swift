//
//  GeoBytesAPI.swift
//  Weather App
//
//  Created by Hamit Sehjal on 2024-04-15.
//


import Foundation

// associating "request url" with the task
enum Endpoint:String{
    case cityNames = "http://gd.geobytes.com/AutoCompleteCity"
    case cityWeahter = "https://api.openweathermap.org/data/2.5/weather"
}

// struct types for each layer of API response

struct WeatherData: Codable{
    let weatherInfo:[Weather]
    let cityInfo:Main
    let name:String
    
    // mapping preferred proprety names to key names in JSON Response
    enum CodingKeys:String,CodingKey{
        case weatherInfo="weather"
        case cityInfo="main"
        case name
    }
}

struct Weather:Codable{
    let description:String
    let icon:String
}
struct Main:Codable{
    let temp:Double
}
struct ServiceAPI{
    private static let baseURLString="http://gd.geobytes.com/AutoCompleteCity"
        
    private static let session = URLSession(configuration: URLSessionConfiguration.default)

    // builds request url based on api call and parameters
    private static func buildURL(endpoint:Endpoint,parameters:[String:String]?)->URL{
        
        
        // extracting the base url based on endpoint
        let baseURL=endpoint.rawValue
        
        // Configuring the URL
        var urlComponents = URLComponents(string: baseURL)!
        var queryItems=[URLQueryItem]()
        
        // if requesting weather data, use api key
        if endpoint == .cityWeahter{
            let query=URLQueryItem(name: "appid", value: "642a3c23abcb9a3d05c3550208a42a89")
            queryItems.append(query)
        }
        
        // adding the query parameters(key-value pairs) to the URL object
        if let queryParamters=parameters{
            for (key,val) in queryParamters{
                let query = URLQueryItem(name: key, value: val)
                queryItems.append(query)
            }
        }
        
        urlComponents.queryItems=queryItems
        return urlComponents.url!
    }
    
    // returns a url specific to GeoBytes API - list of city names
    static var cityNamesURL:(_ parameters:[String:String]?)->URL={
        parameters in
        return buildURL(endpoint: .cityNames, parameters: parameters)
    }
    
    // returns a url specific to Open Weather - weather of a city
    static var cityWeatherURL:(_ parameters:[String:String]?)->URL={
        parameters in
        return buildURL(endpoint: .cityWeahter, parameters:   parameters)
    }
    // fetch list of cities names
    static func fetchCityList(parameters:[String:String],completion:@escaping (Result<[String],Error>)->Void){
        let url=cityNamesURL(parameters)
        let request=URLRequest(url: url)
        
        let task = session.dataTask(with: request, completionHandler: {
            (data,response,error) in
            
            let result=self.processCitiesRequest(data:data,error:error)
            completion(result)
        })
        task.resume()
    }
    
    
    // function that processes the JSON Data returned from the web service request(city names)
    static func processCitiesRequest(data:Data?,error:Error?)->Result<[String],Error>{
        guard let jsonData=data else{
            return .failure(error!)
        }
      
        return ServiceAPI.decodeCitiesList(fromJSON: jsonData)
    }
    
    
    
    // function that takes in instance of Data and  uses JSONDecoder to convert the data into an array of city names
    static func decodeCitiesList(fromJSON data:Data)->Result<[String],Error>{
        do{
            let decoder=JSONDecoder()
            var response = try decoder.decode([String].self, from: data)
            response=response.filter{
                !$0.contains("%s")
            }
            return .success(response)
        }catch{
            return .failure(error)
        }
    }
    
    // function that takes in instance of Data and  uses JSONDecoder to convert the data into an instance of Weather Detail
    static func decodeWeatherData(fromJSON data:Data)->Result<WeatherDetail,Error>{
        
        do{
            let decoder=JSONDecoder()
            let responseData = try decoder.decode(WeatherData.self, from: data)
            print("Name of city decoded is: \(responseData.name)")
            let weatherData=WeatherDetail(name: responseData.name, description: responseData.weatherInfo[0].description, temperature: responseData.cityInfo.temp, icon: responseData.weatherInfo[0].icon)
            
            return .success(weatherData)
        }catch{
            return .failure(error)
        }
    }
  
    
}


