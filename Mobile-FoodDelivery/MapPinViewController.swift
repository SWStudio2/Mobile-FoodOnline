//
//  MapPinViewController.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 2/11/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

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
        if GlobalVariables.sharedManager.basket.object(forKey: "merchant") != nil {
            let basArr = GlobalVariables.sharedManager.basket.object(forKey: "merchant") as! NSArray
            for mer in basArr {
                let lat = (mer as! NSDictionary).object(forKey: "merLatitude") as! String
                let long = (mer as! NSDictionary).object(forKey: "merLongitude") as! String
                updateDistanceAndTime(merLat: lat, merLong: long, curMer: (mer as! NSDictionary))
                
            }
        }
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(tmpLocation!) { response , error in
            if let address = response?.firstResult() {
                    GlobalVariables.sharedManager.selectedAddress = "\(address.thoroughfare!) \(address.locality!) \(address.subLocality!)"
                print("address \(GlobalVariables.sharedManager.selectedAddress)")
                self.navigationController?.popViewController(animated: true)
            }
        }

        

    }
    
    func  updateDistanceAndTime(merLat:String, merLong:String, curMer:NSDictionary)  {
        print("getDistance")
        var lat = "0.00"
        var long = "0.00"
        var distance = "0.00"
        var time = "0.00"
        if GlobalVariables.sharedManager.selectedLocation != nil {
            lat = "\(GlobalVariables.sharedManager.selectedLocation!.latitude)"
            long =  "\(GlobalVariables.sharedManager.selectedLocation!.longitude)"
        }else{
            
            lat = "\(GlobalVariables.sharedManager.currentLocation!.latitude)"
            long =  "\(GlobalVariables.sharedManager.currentLocation!.longitude)"
        }
        let value1 = [ "oriLat" : lat,
                       "oriLng" : long,
                       "desLat" : merLat,
                       "desLng" : merLong]
        print(value1)
        Alamofire.request(BASETESTURL+DISTANCEMATRIX,method: .post, parameters: value1, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
                print("reponse \(response)")
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        
                        print("getDistance example success")
                        //to get JSON return value
                        if let result = response.result.value {
                            print(result)
                            let JSON = result as! NSDictionary
                            distance = (JSON.object(forKey: DATA_KEY) as! NSDictionary).value(forKey: "distance") as! String
                            print("Mer Distance \(curMer.value(forKey: "merDistance") as! String)")
                           // curMer.setValue(distance, forKey: "merDistance")
                        }
                    default:
                        print("error with response status: \(status)")
                        
                    }
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
