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
import CoreLocation

class MapFunctions: NSObject {
    let geocodeURLBase = "https://maps.googleapis.com/maps/api/geocode/json?"
    var geocodedFormattedAddress: String!
    var constructedAddress: String!
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
                if error != nil {
                    completionHandler("", false)
                } else {
                    let status = geocodingDict["status"] as! String
                    if status == "OK" {
                        let results = geocodingDict["results"] as! Array<Dictionary<NSString, AnyObject>>
                        let firstResult = results[0]

                        if let formattedAddress = (firstResult["formatted_address"]) {
                            self.geocodedFormattedAddress = (formattedAddress as! String)
                            self.constructedAddress = ""
                        } else {
                            let addressComponents = firstResult["address_components"] as! Array<Dictionary<NSString, AnyObject>>
                            var streetNumber: String!
                            var route: String!
                            var locality: String!
                            var administrativeLevel1: String!
                            var country: String!
                            for component in addressComponents {
                                let types = component["types"] as! Dictionary<NSString, AnyObject>
                                if let type = types["street_number"] {
                                    streetNumber = (type as! String)
                                } else if let type = types["route"] {
                                    route = (type as! String)
                                } else if let type = types["locality"] {
                                    locality = (type as! String)
                                } else if let type = types["administrative_level_1"] {
                                    administrativeLevel1 = (type as! String)
                                } else if let type = types["country"] {
                                    country = (type as! String)
                                }
                            }
                            self.constructedAddress = streetNumber + " "
                            self.constructedAddress += route + ", "
                            self.constructedAddress += locality + ", "
                            self.constructedAddress += administrativeLevel1 + ", "
                            self.constructedAddress += country
                            self.geocodedFormattedAddress = ""
                        }
                        
                        let geometry = firstResult["geometry"] as! Dictionary<NSString, AnyObject>
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
    
    func getDirectionsBetweenTwoPoints(origin: String!, destination: String!, withCompletionHandler completionHandler: @escaping ((_ status: String, _ success: Bool) -> Void)) {
        
    }
    
    func editOptionalStringValue(str: String!) -> String {
        var strEdited = str.replacingOccurrences(of: "Optional(", with: "")
        strEdited = strEdited.replacingOccurrences(of: ")", with: "")
        strEdited = strEdited.replacingOccurrences(of: "\"", with: "")
        print(strEdited)
        return strEdited
    }
}
