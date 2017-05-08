//
//  MapPinViewController.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 2/11/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit
import GoogleMaps

protocol MapPinViewControllerDelegate {
    func mappinViewControllerReponse(_ clLocation:CLLocationCoordinate2D)
}

class MapPinViewController: BaseViewController, GMSMapViewDelegate{
    
    
    @IBOutlet var mapView: GMSMapView!
    var mappinVCDelegate:MapPinViewControllerDelegate?
    let locationManager = CLLocationManager()
    var tmpLocation:CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        if let location = GlobalVariables.sharedManager.selectedLocation {
            let marker = GMSMarker(position: location)
            marker.map = mapView
        }else{
            let marker = GMSMarker(position: GlobalVariables.sharedManager.currentLocation!)
            marker.map = mapView
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectLocationClick(){
       /* if mappinVCDelegate != nil {
            self.mappinVCDelegate?.mappinViewControllerReponse(GlobalVariables.sharedManager.selectedLocation!)
        }*/
        GlobalVariables.sharedManager.selectedLocation = tmpLocation
        print("Selected Location\(tmpLocation!)")
            
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(tmpLocation!) { response , error in
            if let address = response?.firstResult() {
                    GlobalVariables.sharedManager.selectedAddress = "\(address.thoroughfare!) \(address.locality!) \(address.subLocality!)"
                print("address \(GlobalVariables.sharedManager.selectedAddress)")
                self.navigationController?.popViewController(animated: true)
            }
        }

        

    }
}


// Mark: -CLLocationManagerDelegate
extension MapPinViewController: CLLocationManagerDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        mapView.clear()
        let position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let marker = GMSMarker(position: position)
        marker.map = mapView
        tmpLocation = position
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            
            self.mapView.isMyLocationEnabled = true
            self.mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            locationManager.stopUpdatingLocation()
            
        }
    }

}
