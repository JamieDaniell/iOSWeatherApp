//
//  ViewController.swift
//  Stormy
//
//  Created by Pasan Premaratne on 4/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import CoreLocation
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

class ViewController: UIViewController , CLLocationManagerDelegate
{
    
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentPrecipitationLabel: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    lazy var forecastAPIClient = ForecastAPIClient(APIKey: "4dd81959b6d1a26b14e680f508442ef5")
    var coordinate = Coordinate(latitude: 0, longitude: 0){
        didSet
        {
            getPOI()
        }
    }
    let locationManager: CLLocationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        //locationManager.startUpdatingLocation()
        locationManager.requestLocation()
        fetchCurrentWeather()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func fetchCurrentWeather()
    {
        forecastAPIClient.fetchCurrentWeather(coordinate) { result in
            self.toggleRefreshAnimation(false)
            switch result
            {
                case .Success(let currentWeather):
                // need to deal with threads
                // have to get back to the main thread --> get main queue
                // submits a closure to contaitning some code to a dispatch queue of our choosing in an asyncronous manner
                // (i.e move it to main queue)
                    self.display(currentWeather)
                
                case .Failure(let error as NSError):
                    self.showAlert("Unable to Retreive Forecast" , message: error.localizedDescription)
                
                default: break
            }
        }

    }
    
    func display(weather: CurrentWeather)
    {
        currentTemperatureLabel.text = weather.temperatureString
        currentPrecipitationLabel.text = weather.preciptationProbabiltyString
        currentHumidityLabel.text = weather.humidityString
        currentSummaryLabel.text = weather.summary
        currentWeatherIcon.image = weather.icon
    }
    func showAlert(title: String, message: String? , style: UIAlertControllerStyle = .Alert )
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let dismissAction = UIAlertAction(title: "OK" , style: . Default , handler: nil )
        alertController.addAction(dismissAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    @IBAction func refreshWeather(sender: AnyObject)
    {
        toggleRefreshAnimation(true)
        locationManager.requestLocation()
        fetchCurrentWeather()
        
    }
    func toggleRefreshAnimation(on: Bool)
    {
        refreshButton.hidden = on
        if on
        {
            activityIndicator.startAnimating()
        }
        else
        {
            activityIndicator.stopAnimating()
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let currentLocation = locations.last
        {
            coordinate = Coordinate(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
        }
        
        
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    func getPOI() -> Void
    {
        let place = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(place , completionHandler: { (placemarks , errors) -> Void in
            
            if errors != nil
            {
                print("gelocator failed")
                return
            }
            if placemarks?.count > 0
            {
                let pm = (placemarks?[0])! as CLPlacemark
                self.locationName.text = pm.subLocality
            }
            else
            {
                print(" unidentified problem")
            }
            
        })
    }

}



