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

class MapViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var mapContainer: UIView!
    var mapView: GMSMapView!
    var mapMarker: GMSMarker!
    var mapFunctions: MapFunctions!
    
    @IBAction func addNewMerchant(_ sender: Any) {
        performSegue(withIdentifier: "addNewMerchantMap", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set initial location and marker on map
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 10)
        let initialMapView = GMSMapView.map(withFrame: self.mapContainer.frame, camera: camera)
        self.mapView = initialMapView
        self.view.addSubview(self.mapView)
        let location = CLLocationCoordinate2DMake(-33.86, 151.20)
        let mapMarker = GMSMarker(position: location)
        self.mapMarker = mapMarker
        self.mapMarker.map = self.mapView
    }
    
    @IBAction func searchByAddress(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields
        
        present(autocompleteController, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        self.mapFunctions = MapFunctions()
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
