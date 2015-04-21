//
//  InterfaceController.swift
//  TheForecaster WatchKit Extension
//
//  Created by David Pirih on 21.04.15.
//  Copyright (c) 2015 Piri-Piri. All rights reserved.
//

import WatchKit
import Foundation
import WeatherShare


class InterfaceController: WKInterfaceController {

    
    @IBOutlet weak var temperatureLabel: WKInterfaceLabel!
    @IBOutlet weak var weatherIconImage: WKInterfaceImage!
    @IBOutlet weak var conditionsLabel: WKInterfaceLabel!
    @IBOutlet weak var locationLabel: WKInterfaceLabel!
    @IBOutlet weak var map: WKInterfaceMap!
    @IBOutlet weak var lastUpdateLabel: WKInterfaceLabel!

    var hourlyResults: [AnyObject]?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        updateUI()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func hourlyWeatherButtonPressed() {
        if let results = hourlyResults {
            pushControllerWithName("HourlyWeatherController", context:results)
        }
        else {
            // alert user by an alertview
            //...
            println("Warning: No Hourly information avaiblable.")
        }
    }
    
    @IBAction func refreshButtonPressed() {
        self.updateUI()
    }
    
    func updateUI() {
        var userDefaults = NSUserDefaults(suiteName: GlobalConstants.NSUserDefaultsKey.kLocationKey)
        
        if let locationDitionary = userDefaults?.objectForKey(GlobalConstants.NSUserDefaultsKey.kLocationKey) as? Dictionary<String, AnyObject> {
            let latitude = locationDitionary[GlobalConstants.LocationDictionaryNames.kLatitude] as! Double
            let longitude = locationDitionary[GlobalConstants.LocationDictionaryNames.kLongitude] as! Double
            let city = locationDitionary[GlobalConstants.LocationDictionaryNames.kCity] as! String
            let state = locationDitionary[GlobalConstants.LocationDictionaryNames.kState] as! String
            let country = locationDitionary[GlobalConstants.LocationDictionaryNames.kCountry] as! String
            let lastUpdatedAt = locationDitionary[GlobalConstants.LocationDictionaryNames.kTimestamp] as! NSDate
        
            ForecastNetwork.requestWeather(latitude: latitude, longitude: longitude, completionClosure: { (responseDictionary) -> () in
                if let response = responseDictionary {
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let currentConditionsDictionary = response[GlobalConstants.ForecastDictionaryNames.kCurrently] as! NSDictionary
                        
                        let iconName = currentConditionsDictionary[GlobalConstants.ForecastDictionaryNames.kIcon] as! String
                        self.weatherIconImage.setImage(UIImage(named: iconName))
                        let temperature = currentConditionsDictionary[GlobalConstants.ForecastDictionaryNames.kTemperature] as! Double
                        self.temperatureLabel.setText("\(temperature) ℉")
                        let conditions = currentConditionsDictionary[GlobalConstants.ForecastDictionaryNames.kSummary] as! String
                        self.conditionsLabel.setText(conditions)
                        
                        self.locationLabel.setText("\(city), \(state), \(country)")
                        let formattedDate = NSDateFormatter.localizedStringFromDate(lastUpdatedAt, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
                        self.lastUpdateLabel.setText(formattedDate)
                    
                        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        let span = MKCoordinateSpanMake(0.05, 0.05)
                        let region = MKCoordinateRegionMake(location, span)
                    
                        self.map.setRegion(region)
                        self.map.addAnnotation(location, withPinColor: WKInterfaceMapPinColor.Purple)
                    
                        let hourlyDictionary = currentConditionsDictionary[GlobalConstants.ForecastDictionaryNames.kHourly] as! NSDictionary
                        self.hourlyResults = hourlyDictionary[GlobalConstants.ForecastDictionaryNames.kData] as? [AnyObject]
//                    })
                }
                else {
                    println("Response from Request is missing.")
                }
            })
        }
        else {
            println("Error: Location for NSUserDefaults is empty.")
        }
    }
}
