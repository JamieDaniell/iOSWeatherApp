//
//  CurrentWeather.swift
//  Stormy
//
//  Created by James Daniell on 24/07/2016.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeather
{
    let temperature: Double
    let humidity: Double
    let precipitationProbabilty: Double
    let summary: String
    let icon: UIImage
    
}



extension CurrentWeather: JSONDecodable
{
    init?(JSON: [String: AnyObject])
    {
        guard let temperature = JSON["temperature"] as? Double,
        humidity = JSON["humidity"] as? Double,
        precipitationProbabilty = JSON["precipProbability"] as? Double,
        summary = JSON["summary"] as? String,
        iconString = JSON["icon"] as? String
        else
        {
            return nil
        }
        let icon = WeatherIcon(rawValue: iconString).image
        self.temperature = (temperature-32)*(5/9)
        self.humidity = humidity
        self.precipitationProbabilty = precipitationProbabilty
        self.summary = summary
        self.icon = icon
    }
}








