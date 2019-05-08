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
    
    let directionsURLBase = "https://maps.googleapis.com/maps/api/directions/json?"
    var selectedRoute: Dictionary<NSObject, AnyObject>!
    var overviewPolyline: Dictionary<NSObject, AnyObject>!
    var originCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!
    var originAddress: String!
    var destinationAddress: String!
    var totalDistanceInMeters: UInt = 0
    var totalDistance: String!
    var totalDurationInSeconds: UInt = 0
    var totalDuration: String!
    
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
                            self.constructedAddress = streetNumber + " " + route + ", " + locality + ", " + administrativeLevel1 + ", " + country
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
    
    func getDirections(origin: String!, destination: String!, waypoints: Array<String>!, withCompletionHandler completionHandler: @escaping ((_ status: String, _ success: Bool) -> Void)) {
        
        if let originLocation = origin {
            if let destinationLocation = destination {
                var directionsURLWithQueries = directionsURLBase + "origin=" + originLocation + "&destination=" + destinationLocation + "&key=AIzaSyC1-unUawDB5JY6ZPZU4wwc2HlZb8wMIHw"
                let fullDirectionsURL = NSURL(string: directionsURLWithQueries)
                
                DispatchQueue.main.async {
//                    let geocodingData = try! Data(contentsOf: fullGeocodeURL! as URL)
                    let directionsData = try! Data(contentsOf: fullDirectionsURL! as URL)
                    let directionsDict = try! JSONSerialization.jsonObject(with: directionsData, options: []) as! Dictionary<NSString, Any>
                    
                    var error: NSError?
                    if error != nil {
                        completionHandler("", false)
                    } else {
                        let status = directionsDict["status"] as! String
                        if status == "OK" {
                            let routes = directionsDict["routes"] as! Array<Dictionary<NSString, AnyObject>>
                            let firstRoute = routes[0]
                            self.selectedRoute = firstRoute
                            
                            if let overviewPolyline = (firstRoute["overview_polyline"]) {
                                self.overviewPolyline = overviewPolyline as! Dictionary<NSString, AnyObject>
                                
                                let legs = firstRoute["legs"] as! Array<Dictionary<NSString, AnyObject>>
                                let startLocationDict = legs[0]["start_location"] as! Dictionary<NSString, AnyObject>
                                self.originCoordinate = CLLocationCoordinate2DMake(startLocationDict["lat"] as! Double, startLocationDict["lng"] as! Double)
                                
                                let endLocationDict = legs[legs.count - 1]["end_location"] as! Dictionary<NSString, AnyObject>
                                self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDict["lat"] as! Double, endLocationDict["lng"] as! Double)

                                self.originAddress = legs[0]["start_address"] as! String
                                self.destinationAddress = legs[legs.count - 1]["end_address"] as! String
                                
                                self.calculateDurationAndDistance(legs: legs)
                                
                                completionHandler(status, true)
                            }
                        } else {
                            completionHandler(status, false)
                        }
                    }
                }
            } else {
                completionHandler("Destination is nil", false)
            }
        } else {
            completionHandler("Origin is nil", false)
        }
        
    }
    
    func calculateDurationAndDistance(legs: Array<Dictionary<NSString, AnyObject>>) {
        print("in calculateDurationAndDistance()")
        print("legs: \(String(describing: legs))")
//        for leg in legs {
//            let distance = leg["distance"] as! Dictionary<NSString, AnyObject>
//            self.totalDistanceInMeters += distance["value"] as! UInt
//            let duration = leg["duration"] as! Dictionary<NSString, AnyObject>
//            self.totalDurationInSeconds += duration["value"] as! UInt
//        }
//
//        let distanceInKilometers: Double = Double(self.totalDistanceInMeters / 1000)
//        self.totalDistance = "Total distance: \(distanceInKilometers) Km"
//
//        let minutes = self.totalDurationInSeconds / 60
//        let hours = minutes / 60
//        let days = hours / 24
//        let hoursRemainder = hours % 24
//        let minutesRemainder = minutes % 60
//        self.totalDuration = "Total duration: \(days) days, \(hoursRemainder) hours, \(minutesRemainder) minutes"
    }
    
    func reverseGeocodeByCoordinates(latitude: Double!, longitude: Double!, withCompletionHandler completionHandler: @escaping ((_ status: String, _ success: Bool) -> Void)) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: {
            (placemarks, error) in
            if error != nil {
                print("error with reverse geocoding")
            }
            else {
                let placemarks = placemarks! as [CLPlacemark]
                if placemarks.count > 0 {
                    let placemark = placemarks[0] as CLPlacemark
                    // continue
                }
            }
        })
    }
    
    func editOptionalStringValue(str: String!) -> String {
        var strEdited = str.replacingOccurrences(of: "Optional(", with: "")
        strEdited = strEdited.replacingOccurrences(of: ")", with: "")
        strEdited = strEdited.replacingOccurrences(of: "\"", with: "")
        print(strEdited)
        return strEdited
    }
}
