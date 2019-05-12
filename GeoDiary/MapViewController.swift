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

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var mapContainer: UIView!
    var mapView: GMSMapView!
    var mapMarker: GMSMarker!
    var mapFunctions: MapFunctions!
    
    var currentLocation: Location! = Location()
    
    var currentPlace: GMSPlace!
    var currentPlaceID: String!
    var currentPlaceName: String!
    var currentPlaceFormattedAddress: String!
    @IBOutlet weak var locationInfoView: LocationInfoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapFunctions = MapFunctions()
        
        // Set initial location and marker on map
        self.currentLocation.locationName = "Courant Institute of Mathematical Sciences - New York University"
        self.currentLocation.locationAddress = "251 Mercer St, New York, NY 10012"
        self.currentLocation.locationPlaceID = "ChIJOQ8GbZBZwokR7XMOCVaCVtM"
        
        self.mapView = GMSMapView.map(withFrame: self.mapContainer.frame, camera: GMSCameraPosition.camera(withLatitude: 40.728952, longitude: -73.995681, zoom: 12))
        self.mapView.isMyLocationEnabled = true
        self.view.addSubview(self.mapView)
        
        self.mapMarker = GMSMarker(position: CLLocationCoordinate2DMake(40.728952, -73.995681))
        self.mapMarker.title = self.currentLocation.locationName
        self.mapMarker.map = self.mapView
        
        self.mapView.delegate = self // GMSMapViewDelegate
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        if let customInfoWindow = Bundle.main.loadNibNamed("LocationInfo", owner: self, options: nil)?.first as? LocationInfoView {
            
            customInfoWindow.addRoundedCornersAndShadows()
            customInfoWindow.nameLabel.text = self.currentLocation.locationName
            customInfoWindow.addressLabel.text = self.currentLocation.locationAddress
            marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.0)
            
            return customInfoWindow
        } else {
            return nil
        }
        
    }
    
    @IBAction func addNewMerchant(_ sender: Any) {
        performSegue(withIdentifier: "addNewMerchantMap", sender: self.currentLocation)
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
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.formattedAddress.rawValue) | UInt(GMSPlaceField.coordinate.rawValue) | UInt(GMSPlaceField.phoneNumber.rawValue))!
        autocompleteController.placeFields = fields
        
        present(autocompleteController, animated: true, completion: nil)
    }
}

extension MapViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        print("place: \(String(describing: place))")
        
        currentLocation.locationName = place.name! as String
        currentLocation.locationPlaceID = place.placeID! as String
        currentLocation.locationAddress = place.formattedAddress! as String
        currentLocation.locationLatitude = place.coordinate.latitude
        currentLocation.locationLongitude = place.coordinate.longitude
        
        self.mapView = GMSMapView.map(withFrame: self.mapContainer.frame, camera: GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15))
        self.view.addSubview(self.mapView)
        
        self.mapMarker = GMSMarker(position: place.coordinate)
        self.mapMarker.title = place.name
        self.mapMarker.map = self.mapView
        
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
