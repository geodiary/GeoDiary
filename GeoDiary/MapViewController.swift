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

class MapViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var mapContainer: UIView!
    var mapView: GMSMapView!
    var mapMarker: GMSMarker!
    var mapFunctions: MapFunctions!
    var currentPlace: GMSPlace!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapFunctions = MapFunctions()
        
        // Set initial location and marker on map
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 10)
        self.mapView = GMSMapView.map(withFrame: self.mapContainer.frame, camera: camera)
        self.view.addSubview(self.mapView)
        
        let mapMarker = GMSMarker(position: CLLocationCoordinate2DMake(-33.86, 151.20))
        mapMarker.title = ""
        self.mapMarker = mapMarker
        self.mapMarker.map = self.mapView
    }
    
    @IBAction func addNewMerchant(_ sender: Any) {
        print(self.currentPlace.name ?? "")
        print(self.currentPlace.formattedAddress ?? "")
        print(self.mapMarker.position.latitude)
        print(self.mapMarker.position.longitude)
        let location = Location(name: self.currentPlace.name!, address: self.currentPlace.formattedAddress!, latitude: self.mapMarker.position.latitude, longitude: self.mapMarker.position.longitude)
        
        performSegue(withIdentifier: "addNewMerchantMap", sender: location)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addNewMerchantMap") {
            let anmv = segue.destination as! AddNewMerchantView
            anmv.location = sender as! Location
        }
    }
    
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
                // update current location using the updated mapStuff values
                let newCamera = GMSCameraPosition.camera(withLatitude: self.mapFunctions.geocodedLatitude, longitude: self.mapFunctions.geocodedLongitude, zoom: 15)
                let newMapView = GMSMapView.map(withFrame: self.mapContainer.frame, camera: newCamera)
                self.mapView = newMapView
                self.view.addSubview(newMapView)
                
                let newMapMarker = GMSMarker()
                newMapMarker.position = CLLocationCoordinate2DMake(self.mapFunctions.geocodedLatitude, self.mapFunctions.geocodedLongitude)
                newMapMarker.title = place.name
                self.mapMarker = newMapMarker
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
