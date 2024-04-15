//
//  GeoBytesAPI.swift
//  Weather App
//
//  Created by Hamit Sehjal on 2024-04-15.
//


import Foundation

//struct GeoBytesResponse:Codable{
//    let cities:[String]
//}

struct GeoBytesAPI{
    private static let baseURLString="http://gd.geobytes.com/AutoCompleteCity"
        
    private static let session = URLSession(configuration: URLSessionConfiguration.default)
    
    // builds GeoBytes URL with query parameters
    private static func getCitiesURL(queryParameters:[String:String]?)->URL{
        
        // constructing a url
        var components = URLComponents(string: baseURLString)!
        var queryItems=[URLQueryItem]()
        
        // adding the base parameters
//        let baseParameters=[
//            "callback":"?"
//        ]
//        for (key,value) in baseParameters{
//            let query=URLQueryItem(name: key, value: value)
//            queryItems.append(query)
//        }
        
        // adding the query parameters(key-value pairs) to the URL object
        if let queries=queryParameters{
            for (key,val) in queries{
                let query = URLQueryItem(name: key, value: val)
                queryItems.append(query)
            }
        }
        components.queryItems=queryItems
        
        return components.url!
    }
    
    // fetch cities
    static func fetchCityList(parameters:[String:String],completion:@escaping (Result<[String],Error>)->Void){
        let url=getCitiesURL(queryParameters: parameters)
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
      
        return GeoBytesAPI.decodeCities(fromJSON: jsonData)
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


