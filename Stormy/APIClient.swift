//
//  APIClient.swift
//  Stormy
//
//  Created by James Daniell on 17/08/2016.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation

public let TRENetworkingErrorDomain = "com.JamieDaniell.Stormy.NetworkingError"
public let MissingHTTPResponseError: Int = 10
public let UnexpectedResponseError: Int = 20

typealias JSON = [String: AnyObject]
typealias JSONTaskCompletion = (JSON?, NSHTTPURLResponse? , NSError?) -> Void
typealias JSONTask = NSURLSessionDataTask


// Results form Api Call
enum APIResult<T>
{
    case Success(T)
    case Failure(ErrorType)
}

protocol JSONDecodable
{
    init?(JSON: [String: AnyObject])
}

// The constituent parts of the request
protocol Endpoint
{
    var baseURL: NSURL { get }
    var path: String { get }
    var request: NSURLRequest { get }
}

protocol APIClient
{
    var configuration: NSURLSessionConfiguration { get }
    var session: NSURLSession { get }
    
    // initalise with config
    
    init(config: NSURLSessionConfiguration , APIKey: String)
    
    // takes a request and tuple ( JSON , HTTP response , Error) outputs a void
    func JSONTaskWithRequest(request: NSURLRequest, completion: JSONTaskCompletion) -> JSONTask
    
    //takes a request and a function which goes from JSON to JSON decodeable and a completion function
    func fetch<T: JSONDecodable>(request: NSURLRequest, parse: JSON -> T?, completion: APIResult<T> -> Void )
}


extension APIClient
{
    // implemntation of JSONTaskwithRequest 
    // asynchronous code
    func JSONTaskWithRequest(request: NSURLRequest, completion: JSONTaskCompletion) -> JSONTask
    {
        // create a sesion with a request. A closure is then created for the variables in response to the data task with request
        let task = session.dataTaskWithRequest(request) { data , response , error in
            // if the resonseis not valid
            guard let HTTPResponse = response as? NSHTTPURLResponse else
            {
                //return an error
                let userInfo = [
                    NSLocalizedDescriptionKey: NSLocalizedString("MissingHTTPResponse", comment: "")
                ]
                
                let error = NSError(domain: TRENetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
                
                // josn is nill 
                // response is nil
                // error is passed 
                // completion -> void
                completion(nil, nil, error)
                return
            }
            if data == nil
            {
                if let error = error
                {
                    completion(nil, HTTPResponse, error)
                }
            }
            else
            {
                // if successful and status code is acceptable (code = 200)
                switch HTTPResponse.statusCode
                {
                    case 200:
                        do
                        {
                            // convert the data to a dictionary
                            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String : AnyObject]
                            // call the function with the data and the response and no error
                            completion(json, HTTPResponse , nil )
                        }
                        catch let error as NSError
                        {
                            //if error then send back a code and the error data
                            completion(nil , HTTPResponse, error)
                        }
                    default:
                        print("Received HTTP Response: \(HTTPResponse.statusCode) - not handled")
                }
            }
        }
        return task
    }
    
    // Takes a request 
    // a fucntion from type JSON to T ( CurrentWeather )
    // API Result ( Current Weather ) to void
    func fetch<T>(request: NSURLRequest, parse: JSON -> T?, completion: APIResult<T> -> Void )
    {
        // get the task from the Function 
        // instead of having the completion task we use the closure to get the result
        let task = JSONTaskWithRequest(request) { json , response , error in
            
            dispatch_async(dispatch_get_main_queue())
            {
                // if json is good
                guard let json = json
                    // else throw error
                else
                {
                    if let error = error
                    {
                        completion(.Failure(error))
                    }
                    else
                    {
                        // TODO: Implement Error handling
                    }
                    return
                }
                // pasre the json and give success
                if let value = parse(json)
                {
                    completion(.Success(value))
                }
                    // else throw error
                else
                {
                    print(json)
                    let error = NSError(domain: TRENetworkingErrorDomain, code: UnexpectedResponseError, userInfo: nil)
                    completion(.Failure(error))
                }
            
            
            }
            
        }
        task.resume()
    }
}







