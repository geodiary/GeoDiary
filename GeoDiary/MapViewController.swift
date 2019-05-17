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
    var mapMarker: GMSMarker! = GMSMarker()
    var mapFunctions: MapFunctions!
    
    var locationManager: CLLocationManager! = CLLocationManager()
    
    var currentLocation: Location! = Location()
    var currentPlace: GMSPlace!
    var currentPlaceID: String!
    var currentPlaceName: String!
    var currentPlaceFormattedAddress: String!
    
    @IBOutlet weak var locationInfoView: LocationInfoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapFunctions = MapFunctions()
        
        self.mapView = GMSMapView(frame: self.mapContainer.frame)
        self.view.addSubview(self.mapView)
        
        self.mapView.delegate = self // GMSMapViewDelegate
        
        self.mapView.isMyLocationEnabled = true
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.startMonitoringSignificantLocationChanges()
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
        
        self.locationManager.startUpdatingLocation()
        present(autocompleteController, animated: true, completion: nil)
    }
}

extension MapViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("place id \(String:(place.placeID))")
        self.currentLocation.locationName = place.name! as String
        self.currentLocation.locationPlaceID = place.placeID! as String
        self.currentLocation.locationAddress = place.formattedAddress! as String
        self.currentLocation.locationLatitude = place.coordinate.latitude
        self.currentLocation.locationLongitude = place.coordinate.longitude
        
        self.mapView.camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15)
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

extension MapViewController: GMSMapViewDelegate {
    
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
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
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
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        let latitude = (location?.coordinate.latitude)!
        let longitude = (location?.coordinate.longitude)!
        
        self.mapView.animate(to: GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15))
        
        self.locationManager.stopUpdatingLocation()
    }
}
