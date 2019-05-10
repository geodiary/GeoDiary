//
//  MapViewController.swift
//  GeoDiary
//
//  Created by Sabah Siddique on 5/6/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapContainer: UIView!
    var mapView: GMSMapView!
    var mapMarker: GMSMarker!
    var mapFunctions: MapFunctions!
    var currentPlace: GMSPlace!
    var currentPlaceID: String!
    var currentPlaceName: String!
    var currentPlaceFormattedAddress: String!
    @IBOutlet weak var locationInfoView: LocationInfoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapFunctions = MapFunctions()
        
        // Set initial location and marker on map
        self.currentPlaceName = "Courant Institute of Mathematical Sciences - New York University"
        self.currentPlaceFormattedAddress = "251 Mercer St, New York, NY 10012"
        
        self.mapView = GMSMapView.map(withFrame: self.mapContainer.frame, camera: GMSCameraPosition.camera(withLatitude: 40.728952, longitude: -73.995681, zoom: 12))
        self.mapView.isMyLocationEnabled = true
        self.view.addSubview(self.mapView)
        
        self.mapMarker = GMSMarker(position: CLLocationCoordinate2DMake(40.728952, -73.995681))
        self.mapMarker.title = self.currentPlaceName
        self.mapMarker.map = self.mapView
    }
    
    @IBAction func addNewMerchant(_ sender: Any) {
//        let location = Location()
//
//        if currentPlace != nil {
//            if self.currentPlaceFormattedAddress != "" {
//                location.locationName = self.currentPlaceName
//                location.locationPlaceID = self.currentPlaceID
//                location.locationAddress = self.currentPlaceFormattedAddress
//                location.locationLatitude = self.mapMarker.position.latitude
//                location.locationLongitude = self.mapMarker.position.longitude
//            } else {
//                self.mapFunctions.geocodeAddressByPlaceID(searchedPlaceID: currentPlace.placeID, withCompletionHandler: { (status, success) -> Void in
//                    if !success {
//                        location.locationName = ""
//                        location.locationPlaceID = ""
//                        location.locationAddress = ""
//                        location.locationLatitude = 0.0
//                        location.locationLongitude = 0.0
//                    } else {
//                        location.locationName = self.currentPlaceName
//                        location.locationPlaceID = self.currentPlaceID
//                        location.locationAddress = self.mapFunctions.constructedAddress
//                        location.locationLatitude = self.mapFunctions.geocodedLatitude
//                        location.locationLongitude = self.mapFunctions.geocodedLongitude
//                    }
//                })
//            }
//        } else {
//            location.locationName = self.currentPlaceName!
//            location.locationPlaceID = self.currentPlaceID
//            location.locationAddress = self.currentPlaceFormattedAddress
//            location.locationLatitude = self.mapMarker.position.latitude
//            location.locationLongitude = self.mapMarker.position.longitude
//        }
        
        var location: Location!
        
        if currentPlace != nil {
            if self.currentPlaceFormattedAddress != "" {
                location = Location(name: self.currentPlaceName, placeID: self.currentPlaceID, address: self.currentPlaceFormattedAddress, latitude: self.mapMarker.position.latitude, longitude: self.mapMarker.position.longitude)
            } else {
                self.mapFunctions.geocodeAddressByPlaceID(searchedPlaceID: currentPlace.placeID, withCompletionHandler: { (status, success) -> Void in
                    if !success {
                        location = Location(name: "", placeID: "", address: "", latitude: 0.0, longitude: 0.0)
                    } else {
                        location = Location(name: self.currentPlaceName, placeID: self.currentPlaceID, address: self.mapFunctions.constructedAddress, latitude: self.mapFunctions.geocodedLatitude, longitude: self.mapFunctions.geocodedLongitude)
                    }
                })
            }
        } else {
            location = Location(name: self.currentPlaceName, placeID: self.currentPlaceID, address: self.currentPlaceFormattedAddress, latitude: self.mapMarker.position.latitude, longitude: self.mapMarker.position.longitude)
        }
        
        performSegue(withIdentifier: "addNewMerchantMap", sender: location)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addNewMerchantMap") {
            let anmv = segue.destination as! AddNewMerchantView
            anmv.location = sender as! Location
        }
    }
}

extension MapViewController: UISearchBarDelegate {
    
    @IBAction func searchByAddress(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields
        
        present(autocompleteController, animated: true, completion: nil)
    }
}

extension MapViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.mapFunctions.geocodeAddressByPlaceID(searchedPlaceID: place.placeID, withCompletionHandler: { (status, success) -> Void in
            if !success {
                // TODO: handle error
            } else {
               // update current location
                self.currentPlaceID = place.placeID
                self.currentPlace = place
                self.currentPlaceName = self.mapFunctions.editOptionalStringValue(str: place.name)
                self.currentPlaceFormattedAddress = self.mapFunctions.editOptionalStringValue(str: self.mapFunctions.geocodedFormattedAddress)
                
                self.mapView = GMSMapView.map(withFrame: self.mapContainer.frame, camera: GMSCameraPosition.camera(withLatitude: self.mapFunctions.geocodedLatitude, longitude: self.mapFunctions.geocodedLongitude, zoom: 15))
                self.view.addSubview(self.mapView)
                
                self.mapMarker = GMSMarker(position: CLLocationCoordinate2DMake(self.mapFunctions.geocodedLatitude, self.mapFunctions.geocodedLongitude))
                self.mapMarker.title = place.name
                self.mapMarker.map = self.mapView
            }
        })
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
