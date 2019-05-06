//
//  MapFunctions.swift
//  GeoDiary
//
//  Created by Sabah Siddique on 5/6/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapFunctions: NSObject {
    let geocodeURLBase = "https://maps.googleapis.com/maps/api/geocode/json?"
    var geocodedFormattedAddress: String!
    var geocodedLatitude: Double!
    var geocodedLongitude: Double!
    
    override init() {
        super.init()
    }
    
    func geocodeAddressByPlaceID(searchedPlaceID: String!, withCompletionHandler completionHandler: @escaping ((_ status: String, _ success: Bool) -> Void)) {
        
        if let placeID = searchedPlaceID {
            let geocodeURLWithQuery: String! = geocodeURLBase + "place_id=" + placeID + "&key=AIzaSyC1-unUawDB5JY6ZPZU4wwc2HlZb8wMIHw"
            let fullGeocodeURL = NSURL(string: geocodeURLWithQuery)
            
            DispatchQueue.main.async {
                let geocodingData = try! Data(contentsOf: fullGeocodeURL! as URL)
                let geocodingDict = try! JSONSerialization.jsonObject(with: geocodingData, options: []) as! Dictionary<NSString, Any>
                
                var error: NSError?
                if (error != nil) {
                    completionHandler("", false)
                } else {
                    let status = geocodingDict["status"] as! String
                    if status == "OK" {
                        let results = geocodingDict["results"] as! Array<Dictionary<NSString, AnyObject>>
                        let firstAddressComponent = results[0]
                        
                        self.geocodedFormattedAddress = (firstAddressComponent["formatted_address"] as! String)
                        
                        let geometry = firstAddressComponent["geometry"] as! Dictionary<NSString, AnyObject>
                        self.geocodedLatitude = ((geometry["location"] as! Dictionary<NSString, AnyObject>)["lat"] as! NSNumber).doubleValue
                        self.geocodedLongitude = ((geometry["location"] as! Dictionary<NSString, AnyObject>)["lng"] as! NSNumber).doubleValue
                        
                        completionHandler(status, true)
                    } else {
                        completionHandler(status, false)
                    }
                }
            }
        } else {
            completionHandler("No valid address.", false)
        }
    }
}
