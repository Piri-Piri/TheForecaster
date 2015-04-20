//
//  ForecastNetwork.swift
//  TheForecaster
//
//  Created by David Pirih on 20.04.15.
//  Copyright (c) 2015 Piri-Piri. All rights reserved.
//

import UIKit

let kForecastApiKey = "5adc20893be823cde647b3a4f537c874"

public class ForecastNetwork: NSObject {
    
    public class func requestWeather(#latitude: Double, longitude: Double, completionClosure: (responseDictionary : NSDictionary?) -> ()) {
        let  url = NSURL(string: "https://api.forecast.io/forecast/\(kForecastApiKey)/\(latitude),\(longitude)")
    
        var request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        
        var weatherTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            var conversionError: NSError?
            var jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error: &conversionError) as? NSDictionary
            if conversionError != nil {
                println(conversionError!.localizedDescription)
                completionClosure(responseDictionary: nil)
            }
            else {
                completionClosure(responseDictionary: jsonDictionary!)
            }
        })
        weatherTask.resume()
    }
}
