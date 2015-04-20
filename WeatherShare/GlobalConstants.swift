//
//  GlobalConstants.swift
//  TheForecaster
//
//  Created by David Pirih on 20.04.15.
//  Copyright (c) 2015 Piri-Piri. All rights reserved.
//

import Foundation

public struct GlobalConstants {
    public struct NotificationNames {
        public static let kLocationUpdate = "LOCATION_DID_UPDATE"
    }
    
    public struct LocationDictionaryNames {
        public static let kLatitude = "latitude"
        public static let kLongitude = "longitude"
        public static let kCity = "city"
        public static let kState = "state"
        public static let kCountry = "country"
        public static let kTimestamp = "timestamp"
    }
    
    public struct ForecastDictionaryNames {
        public static let kCurrently = "currently"
        public static let kIcon = "icon"
        public static let kTemperature = "temperature"
        public static let kSummary = "summary"
    }
}