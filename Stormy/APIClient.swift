//
//  APIClient.swift
//  Stormy
//
//  Created by James Daniell on 17/08/2016.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation


typealias JSON = [String: AnyObject]
typealias JSONTaskCompletion = (JSON?, NSHTTPURLResponse? , NSError?) -> Void)
typealias JSONTask = NSURLSessionDataTask
protocol APIClient
{
    var configuation: NSURLSessionConfiguration { get }
    var session: NSURLSession { get }
    
    init(config: NSURLSessionConfiguration)
    
    func JSONTaskWithRequest(request: NSURLRequest, completion: JSONTaskCompletion) -> JSONTask
    
    
}