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
    
    
    // function that processes the JSON Data returned from the web service request
    static func processCitiesRequest(data:Data?,error:Error?)->Result<[String],Error>{
        guard let jsonData=data else{
            return .failure(error!)
        }
      
        return ServiceAPI.decodeCities(fromJSON: jsonData)
    }
    
    // function that takes in instance of Data and  uses JSONDecoder to convert the data into an instance of GeoBytesResponse
    static func decodeCities(fromJSON data:Data)->Result<[String],Error>{
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
  
    
}


