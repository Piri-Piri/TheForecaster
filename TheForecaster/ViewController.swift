//
//  ViewController.swift
//  TheForecaster
//
//  Created by David Pirih on 16.04.15.
//  Copyright (c) 2015 Piri-Piri. All rights reserved.
//

import UIKit
import WeatherShare

class ViewController: UIViewController {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationDidUpdate:", name: GlobalConstants.NotificationNames.kLocationUpdate, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func refreshWeatherButtonPressed(sender: UIButton) {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            appDelegate.locationController?.locationManager.stopUpdatingLocation()
            appDelegate.locationController?.locationManager.startUpdatingLocation()
        }
    }

    func locationDidUpdate(notication: NSNotification) {
        let locationDictionary = notication.userInfo as! Dictionary<String,AnyObject>
        
        let latitude = locationDictionary[GlobalConstants.LocationDictionaryNames.kLatitude] as! Double
        let longitude = locationDictionary[GlobalConstants.LocationDictionaryNames.kLongitude] as! Double
        let city = locationDictionary[GlobalConstants.LocationDictionaryNames.kCity] as! String
        let state = locationDictionary[GlobalConstants.LocationDictionaryNames.kState] as! String
        let country = locationDictionary[GlobalConstants.LocationDictionaryNames.kCountry] as! String
        let lastUpdatedAt = locationDictionary[GlobalConstants.LocationDictionaryNames.kTimestamp] as! NSDate
        
        ForecastNetwork.requestWeather(latitude: latitude, longitude: longitude) { (responseDictionary) -> () in
            if let response = responseDictionary {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let currentConditionsDictionary = response[GlobalConstants.ForecastDictionaryNames.kCurrently] as! NSDictionary
                    
                    let iconName = currentConditionsDictionary[GlobalConstants.ForecastDictionaryNames.kIcon] as! String
                    self.weatherImageView.image = UIImage(named: iconName)
                    let temperature = currentConditionsDictionary[GlobalConstants.ForecastDictionaryNames.kTemperature] as! Double
                    self.temperatureLabel.text = "\(temperature) ℉"
                    let conditions = currentConditionsDictionary[GlobalConstants.ForecastDictionaryNames.kSummary] as! String
                    self.weatherConditionLabel.text = conditions
                    
                    self.locationLabel.text = "\(city), \(state), \(country)"
                    let formattedDate = NSDateFormatter.localizedStringFromDate(lastUpdatedAt, dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.MediumStyle)
                    self.updateDateLabel.text = formattedDate
                })
            }
            else {
                println("Response from Request is missing.")
            }
        }
    }
}

