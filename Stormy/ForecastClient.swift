//
//  ForecastClient.swift
//  Stormy
//
//  Created by James Daniell on 17/08/2016.
//  Copyright © 2016 Treehouse. All rights reserved.
//
import Foundation

struct Coordinate
{
    let latitude: Double
    let longitude: Double
}

// extension of endpoint
enum Forecast: Endpoint
{
    //current weather
    case Current(token: String , coordinate: Coordinate)
    
    //base
    var baseURL: NSURL
    {
        return NSURL(string: "https://api.forecast.io")!
    }
    var path: String
    {
        switch self
        {
            case .Current(let token, let coordinate):
                return "/forecast/\(token)/\(coordinate.latitude),\(coordinate.longitude)"
        }
    }
    //return the request
    var request: NSURLRequest
    {
        let url = NSURL(string: path , relativeToURL: baseURL )!
        return NSURLRequest(URL: url)
    }
}



final class ForecastAPIClient:  APIClient
{
    // default
    var configuration: NSURLSessionConfiguration
    // create session
    lazy var session: NSURLSession = {
        return NSURLSession(configuration: self.configuration )
    }()
    // access token for API
    private let token: String
    
    // require to begin
    init(config: NSURLSessionConfiguration , APIKey: String)
    {
        self.configuration = config
        self.token = APIKey
    }
    
    convenience init(APIKey: String)
    {
        self.init(config: NSURLSessionConfiguration.defaultSessionConfiguration(), APIKey: APIKey )
    }
    
    // How to get the lates data 
    func fetchCurrentWeather(coordinate: Coordinate , completion: APIResult<CurrentWeather> -> Void )
    {
        // create the NSRequest object
        let request = Forecast.Current(token: self.token , coordinate: coordinate ).request
        
        // call our fetch function with the right data
        // parse json -> T (CurrentWeather)
        fetch(request , parse: { json -> CurrentWeather? in
            // how to do the parse function
            if let currentWeatherDictionary = json["currently"] as? [String : AnyObject]
            {
                // form currnetWeather.swift converts the data to swift Dictionary
                return CurrentWeather(JSON: currentWeatherDictionary)
            }
            else
            {
                return nil
            }
            
        }, completion: completion)
    }
    
}