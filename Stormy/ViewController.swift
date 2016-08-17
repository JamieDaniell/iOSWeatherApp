//
//  ViewController.swift
//  Stormy
//
//  Created by Pasan Premaratne on 4/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit

extension CurrentWeather
{
    var temperatureString: String
    {
        return "\(Int(temperature))º"
    }
    
    var humidityString: String
    {
        let percentageValue = Int(humidity * 100)
        return "\(percentageValue)%"
    }
    
    var preciptationProbabiltyString: String
    {
        let percentageValue = Int(precipitationProbabilty * 100)
        return "\(percentageValue)%"
    }
}

class ViewController: UIViewController
{
    
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentPrecipitationLabel: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let forecastAPIKey = "4dd81959b6d1a26b14e680f508442ef5"

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let icon = WeatherIcon.PartlyCloudyDay.image
        let currentWeather = CurrentWeather(temperature: 56.0, humidity: 1.0, precipitationProbabilty: 1.0, summary: " Wet and Rainy", icon: icon)
        display(currentWeather)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func display(weather: CurrentWeather)
    {
        currentTemperatureLabel.text = weather.temperatureString
        currentPrecipitationLabel.text = weather.preciptationProbabiltyString
        currentHumidityLabel.text = weather.humidityString
        currentSummaryLabel.text = weather.summary
        currentWeatherIcon.image = weather.icon
    }


}



