//
//  HomeViewController.swift
//  Mobile-FoodDelivery
//
//  Created by Kewalin Sakawattananon on 2/11/2560 BE.
//  Copyright © 2560 BSD. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class HomeViewController: BaseViewController, GMSMapViewDelegate {
    @IBOutlet weak var merchantTbv:UITableView!
    @IBOutlet weak var addressLabel:UILabel!
    @IBOutlet weak var searchBar: UISearchBar!

 //   let nameList = ["โอชายะ (Chamchuri Square)", "ส้มตำเจ๊แดง"]
 //   let distanceList = ["1","1.2"]
 //   let timeList = ["33","40"]
    var merList = NSArray()
    var searchActive : Bool = false
    var filtered:[Merchant] = []
    
    let locationManager = CLLocationManager()
    var indicator = UIActivityIndicatorView()
    var merObjList:[Merchant] = []
    var tmpMerObjList:[Merchant] = []
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        
        self.addSlideMenuButton()
        //self.addBasketAndPinMenuButton()
        self.navigationItem.setHidesBackButton(true, animated: false)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.merchantTbv.delegate = self
        self.merchantTbv.dataSource = self
        self.searchbarSetup()
        self.getMerchant()
        self.refreshControlSetup()
        
    }
    
    func refreshControlSetup(){
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action:  #selector(HomeViewController.refresh), for: UIControlEvents.valueChanged)
        self.merchantTbv.addSubview(refreshControl)
    }
    
    func searchbarSetup(){
        /*searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        merchantTbv.tableHeaderView = searchController.searchBar*/
        self.merchantTbv.delegate = self
        self.merchantTbv.dataSource = self
        self.searchBar.delegate = self
       // searchBar = searchController.searchBar
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.addBasketAndPinMenuButton()
        self.addressLabel.text = GlobalVariables.sharedManager.selectedAddress
      //  self.merchantTbv.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func getMerchant(){
        
        let  value1  = NSDictionary()
        
        Alamofire.request(BASEURL+GETALL_MER,method: .post, parameters: value1 as! Parameters, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
                print("Response \(response)")
               // if let status = response.response?.statusCode {
               //     switch(status){
               //     case 200:
               
                if let result = response.result.value {
                    self.merList = result as! NSArray
                    print("COunt \(self.merList.count)")
                    
                    for mer in self.merList {
                        let merDict = mer as! NSDictionary
                        let merObj = Merchant(json: merDict)
                        
                        let loc =  CLLocation.init(latitude: CLLocationDegrees.init(merObj.merLatitude)!, longitude: CLLocationDegrees.init(merObj.merLongtitude)!)
                        if GlobalVariables.sharedManager.currentLocation != nil {
                            let distance = loc.distance(from: CLLocation.init(latitude: CLLocationDegrees.init((GlobalVariables.sharedManager.currentLocation?.latitude)!), longitude: (GlobalVariables.sharedManager.currentLocation?.longitude)!))
                            merObj.merDistance = String(format: "%.2f", distance / 1000)
                        }else{
                            let distance = loc.distance(from: CLLocation.init(latitude: CLLocationDegrees.init((GlobalVariables.sharedManager.selectedLocation?.latitude)!), longitude: (GlobalVariables.sharedManager.selectedLocation?.longitude)!))
                            merObj.merDistance = String(format: "%.2f", distance / 1000)
                        }
                    //self.updateDistanceAndTime(mer: merObj)
                        self.merObjList.append(merObj)
                    }
                    
                    self.merObjList = self.merObjList.sorted { Double.init($0.merDistance)! < Double.init(($1).merDistance)! }
                    
                     print("mer obj count \(self.merObjList.count)")
                        self.merchantTbv.reloadData()
                    
                        }
               //     default:
               //         print("error with response status: \(status)")
               //     }
              //  }
 /*               do{
                let allMerchant = JSONSerialization.jsonObject(with: JSON as! String, options: JSONSerialization.ReadingOptions.allowFragments)
                  as!  [String : AnyObject]
                /*let allMerchant = try JSONSerialization.jsonObject(with: JSON, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : AnyObject]
                
                for index in 0...allMerchant.count-1 {
                    
                    let aObject = arrJSON[index] as! [String : AnyObject]
                    
                   
                }*/
                }
                catch {
                        
                }*/
        }
    }
    
    func refresh(){
        /*
        self.tmpMerObjList.removeAll()
        for mer in self.merObjList {
            updateDistanceAndTime(mer: mer)
        }*/
        self.merObjList = self.merObjList.sorted { Double.init($0.merDistance)! < Double.init(($1).merDistance)! }
        self.merchantTbv.reloadData()
        self.refreshControl.endRefreshing()
        
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "menuListSegue" {
            
            let menuListVC = segue.destination as! MenuListViewController
            let tmp = sender as! NSDictionary
            menuListVC.mer = tmp.object(forKey: "mer") as! Merchant
            menuListVC.menuArr = tmp.object(forKey: "menuList") as! NSArray
            
        }
        
    }


}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchBar.text != "" {
            return filtered.count
        }
        return merObjList.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "merchantTableViewCell", for: indexPath) as! MerchantTableViewCell
        let row = indexPath.row
       
        var mer = self.merObjList[row]
        if self.searchBar.text != "" {
            mer = filtered[indexPath.row]
        }
        cell.merName.text  = mer.merName
        //cell.merDistance.text = mer.merDistance
        //cell.merTime.text = mer.merDuration
        updateDistanceAndTime(mer: mer, cell: cell, row:row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        self.getMenuList(row: row)
    }
    
    func getMenuList(row:Int){
        /*
        if let path = Bundle.main.path(forResource: "Order", ofType: "json")
        {
            if let jsonData = NSData (contentsOfFile: path)
            {
                do {
                    if let jsonResult: NSMutableDictionary = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSMutableDictionary   {
                        //print("jsonResult \(jsonResult)")
                        if (jsonResult.object(forKey: DATA_KEY) != nil) {
                            let menuArr = jsonResult.object(forKey: DATA_KEY)! as! NSArray
                            var dict = NSDictionary()
                            
                            dict = ["mer": (merList.object(at: row) as! NSDictionary),
                                    "menuList" : menuArr]
                            self.performSegue(withIdentifier: "menuListSegue", sender: dict)
                        }
                    }
                    /*
                     {
                     if let persons : NSArray = jsonResult["person"] as? NSArray
                     {
                     // Do stuff
                     }
                     }*/
                } catch let error {
                    print("error")
                }
            }*/
        //
        var mer = self.merObjList[row]
        if self.searchBar.text != "" {
            mer = filtered[row]
        }
        
        let URL = BASEURL+GETMENU+"\(mer.merID)"
            
        Alamofire.request(URL)
        //Alamofire.request(URL,method: .get, parameters: [] as! Parameters, encoding: JSONEncoding.default, headers: header)
            
            .responseJSON { response in
                print("Response \(response)")
                if response.result.isSuccess {
                    
                    // if let status = response.response?.statusCode {
                    //     switch(status){
                    //     case 200:
                    
                    if let result = response.result.value {
                        do {
                            if ((result as AnyObject).object(forKey: DATA_KEY) != nil) {
                                let menuArr = (result as AnyObject).object(forKey: DATA_KEY)! as! NSArray
                                var dict = NSDictionary()
                            
                                dict = ["mer": (mer),
                                    "menuList" : menuArr]
                                self.performSegue(withIdentifier: "menuListSegue", sender: dict)
                        
                            }
                        } catch let error {
                            print("error")
                            self.alertPopupFail()
                        }
                    }
                }else{
                    self.alertPopupFail()
                }
        }

    }

    func updateDistanceAndTime(mer:Merchant, cell:MerchantTableViewCell, row:Int)  {
        print("getDistance")
        var lat = "13.739852"
        var long = "100.530840"
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
                       "desLat" : mer.merLatitude,
                       "desLng" : mer.merLongtitude]
        print(value1)
        print("merId \(mer.merID)")
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
                            time = (JSON.object(forKey: DATA_KEY) as! NSDictionary).value(forKey: "duration") as! String
                            mer.merDistance = distance
                            mer.merDuration = time
                            print("mer.cookingTime \(mer.cookingTime)")
                            print("time \(time)")
                            let total = Double.init(mer.cookingTime) + Double.init(time)!
                            let strTime = "\(total)"
                            
                            cell.merTime.text = strTime
                            
                            
                            cell.merDistance.text = mer.merDistance
                            
                           
                        }
                    default:
                        print("error with response status: \(status)")
                        
                    }
                }
        }
        
    }
    
    func filterContentForSearchText(searchText: String) {
        print("searchText \(searchText)")
        filtered = merObjList.filter({( mer : Merchant) -> Bool in
            print("mer.merName \(mer.merName)")
            print("\(mer.merName.lowercased().contains(searchText.lowercased()))")
            return mer.merName.lowercased().contains(searchText.lowercased())
        })
        
        print("filtered \(filtered.count)")
        self.merchantTbv.reloadData()
    }
    
}

// Mark: -CLLocationManagerDelegate
extension HomeViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            if GlobalVariables.sharedManager.selectedLocation == nil {
                GlobalVariables.sharedManager.currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                print("First Location\(location)")
                
                let geocoder = GMSGeocoder()
                geocoder.reverseGeocodeCoordinate(GlobalVariables.sharedManager.currentLocation!) { response , error in
                
               
                    if let address = response?.firstResult() {
                        var add = ""
                        if address.thoroughfare != nil {
                            add = address.thoroughfare!
                        }
                        if address.locality != nil {
                            add = add + " " + address.locality!
                        }
                        if address.subLocality != nil {
                            add = add + " " + address.subLocality!
                        }
                        GlobalVariables.sharedManager.selectedAddress = add
                       self.addressLabel.text = GlobalVariables.sharedManager.selectedAddress// "\(address.thoroughfare!) \(address.locality!) \(address.subLocality!)"
                        // print("address.lines \(address.lines)")
                        //  let addessLine = address.lines! as [String]
                        //  self.addressLabel.text = addessLine.first
                    }
                }
            }
        }
    }


}

extension HomeViewController:MapPinViewControllerDelegate {
    func mappinViewControllerReponse(_ clLocation: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
 

        print("reverseGeocodeCoordinate at \(clLocation.latitude), \(clLocation.longitude)")
        geocoder.reverseGeocodeCoordinate(clLocation) { response , error in
            
            
            if let address = response?.firstResult() {
                print("address \(address)")
                var addressStr = ""
                for line in address.lines! {
                    addressStr += line + " "
                }
                
                self.addressLabel.text = addressStr
                // print("address.lines \(address.lines)")
                //  let addessLine = address.lines! as [String]
                //  self.addressLabel.text = addessLine.first
            }
        }
    }
}
/*
extension HomeViewController:UISearchBarDelegate{

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = nameList.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSString.CompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        merchantTbv.reloadData()
    }
}*/

extension HomeViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange")
        filterContentForSearchText(searchText: searchText)
    }
    /*
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        print("searchBarTextDidBeginEditing")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        print("searchBarTextDidEndEditing")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        print("searchBarSearchButtonClicked")
    }*/
    
    
}
/*
extension HomeViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        //let searchBar = searchController.searchBar
         guard let searchString = searchController.searchBar.text else {
            return
        }
        //let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchString)
    }

    
}
*/
