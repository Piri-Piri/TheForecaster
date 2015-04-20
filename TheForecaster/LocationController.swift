//
//  LocationController.swift
//  TheForecaster
//
//  Created by David Pirih on 20.04.15.
//  Copyright (c) 2015 Piri-Piri. All rights reserved.
//

import UIKit
import CoreLocation
import WeatherShare

class LocationController: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.distanceFilter = 100.0
        self.locationManager.startUpdatingLocation()
    }
 
    // MARK: - CLLocationManger Delegate
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        let location = locations.last as! CLLocation
        
        println("didUpdateLactions: \(location)")
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: {
            placemarks, error in
            
            if error != nil {
                println("Reverse geocoding failed. Error: \(error.localizedDescription)")
            }
            else {
                let placemark = placemarks.last as! CLPlacemark
                let locationInfo = [
                    GlobalConstants.LocationDictionaryNames.kLatitude : placemark.location.coordinate.latitude,
                    GlobalConstants.LocationDictionaryNames.kLongitude : placemark.location.coordinate.longitude,
                    GlobalConstants.LocationDictionaryNames.kCity : placemark.locality,
                    GlobalConstants.LocationDictionaryNames.kState: placemark.administrativeArea,
                    GlobalConstants.LocationDictionaryNames.kCountry : placemark.country,
                    GlobalConstants.LocationDictionaryNames.kTimestamp : location.timestamp
                ]
                NSNotificationCenter.defaultCenter().postNotificationName(GlobalConstants.NotificationNames.kLocationUpdate, object: nil, userInfo: locationInfo)
            }
        })
        
        
    }
    
}
