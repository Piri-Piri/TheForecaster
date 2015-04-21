//
//  HourlyWeatherInterfaceController.swift
//  TheForecaster
//
//  Created by David Pirih on 21.04.15.
//  Copyright (c) 2015 Piri-Piri. All rights reserved.
//

import WatchKit
import Foundation


class HourlyWeatherInterfaceController: WKInterfaceController {

    
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    @IBOutlet weak var temperatureLabel: WKInterfaceLabel!
    @IBOutlet weak var weatherIconImage: WKInterfaceImage!
    @IBOutlet weak var chanceOfRainLabel: WKInterfaceLabel!
    @IBOutlet weak var summaryLabel: WKInterfaceLabel!
    
    var currentIndex: Int!
    var hourlyWeatherArray: [AnyObject]!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        self.currentIndex = 0
        self.hourlyWeatherArray = context! as! [AnyObject]
        self.updateUI()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    @IBAction func previousButtonPressed() {
        if self.currentIndex != 0 {
            self.currentIndex!--
            self.updateUI()
        }
    }

    @IBAction func nextButtonPressed() {
        if self.currentIndex < self.hourlyWeatherArray.count - 1 {
            self.currentIndex!++
            self.updateUI()
        }
    }
    
    func updateUI() {
        let hourlyWeaterDictionary = hourlyWeatherArray[self.currentIndex] as! NSDictionary
        
        let time = hourlyWeaterDictionary["time"] as! Double
        let hourlyDate = NSDate(timeIntervalSince1970: time)
        let formattedDate = NSDateFormatter.localizedStringFromDate(hourlyDate, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        self.timeLabel.setText(formattedDate)
        
        let temperature = hourlyWeaterDictionary["temperature"] as! Double
        self.temperatureLabel.setText("\(temperature) ℉")
        
        let iconString = hourlyWeaterDictionary["icon"] as! String
        self.weatherIconImage.setImage(UIImage(named: iconString))
        
        let precipProbability = hourlyWeaterDictionary["precipProbability"] as! Double
        self.chanceOfRainLabel.setText("\(precipProbability)%")
        
        let summaryString = hourlyWeaterDictionary["summary"] as! String
        self.summaryLabel.setText(summaryString)
        
    }
}
