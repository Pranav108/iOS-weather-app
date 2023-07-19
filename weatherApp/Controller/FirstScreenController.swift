//
//  firstScreenTableViewController.swift
//  weatherApp
//
//  Created by Pranav Pratap on 10/07/23.
//

//unable to dequeue a cell with identifier screen1TableViewCell - must register a nib or a class for the identifier or connect a prototype cell in a storyboard"


import UIKit

import CoreLocation


class FirstScreenTableViewController: UIViewController {
    
    @IBOutlet weak var screen1TableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    
    let locationManager = CLLocationManager()
    var screen1DataForBinding = [Screen1DataModel]()
    var urlMaker : UrlMaker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screen1TableView.delegate = self
        screen1TableView.dataSource = self
        searchBar.delegate = self
        locationManager.delegate = self
        urlMaker?.delegates[0] = self
        
        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        
        
        screen1TableView.register(UINib(nibName: "Screen1TableViewCell", bundle: nil), forCellReuseIdentifier: "Screen1TableViewCell")
        
        self.searchBar.placeholder = "Search here"
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UISearchTextField
        let imageV = textFieldInsideSearchBar?.leftView as! UIImageView
        imageV.image = imageV.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imageV.tintColor = UIColor.purple
        
        searchButton.layer.cornerRadius = 10
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchBarSearchButtonClicked(searchBar)
    }
}


extension FirstScreenTableViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if screen1DataForBinding.isEmpty {
            return 0
        }
        return screen1DataForBinding.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = tableView.dequeueReusableCell(withIdentifier: "Screen1TableViewCell", for: indexPath) as! Screen1TableViewCell
        
        let maskLayer = CALayer()
        
        maskLayer.cornerRadius = 20
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: row.bounds.origin.x, y: row.bounds.origin.y, width: row.bounds.width, height: row.bounds.height).insetBy(dx: 16, dy: 10)
        row.layer.mask = maskLayer
        
        let currentWeatherData = screen1DataForBinding[indexPath.item]
        row.placeLabel?.text = currentWeatherData.locationName
        row.tmpLabel?.text = currentWeatherData.temp
        row.infoLabel?.text = currentWeatherData.info
        row.tempRangeLabel?.text = currentWeatherData.min_max
        row.backgroundView = UIImageView(image: UIImage(named: currentWeatherData.imageName))
        return row
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}


extension FirstScreenTableViewController : UISearchBarDelegate{
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if searchBar.text != "" {
            return true
        }else{
            searchBar.placeholder = "Type place name..."
            return false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        let cityName = searchBar.text!
        
        urlMaker?.city = cityName.replacingOccurrences(of: " ", with: "+")
        if cityName == "" {
            showToast(message: "Please enter city name", seconds: 1.2)
        }else{
            urlMaker?.urlStringMaker()
        }
        searchBar.text = ""
    }
}

extension FirstScreenTableViewController : WeatherApiDelegate{
    
    func updateUIforFirstScreen(_ weatherData: WeatherRequestTypeProtocol) {
        print("CurrentWeather data in FirstScreen")
        
        var newData : Screen1DataModel
        if weatherData is PlaceLoactionModel {
            let placeData = weatherData as? PlaceLoactionModel
            newData = Screen1DataModel(locationName: placeData?.name ?? "CTY", info: placeData?.weather.first?.main ?? "NA", temp: placeData?.main.tempString ?? "TMP", min_max: placeData?.main.tempRangeString ?? "MN_MX", imageName: placeData?.weather.first!.imageName ?? "NA")
            
            print("Data is of type : PlaceLoactionModel")
        }else{
            // CONVERT THE DATA OF TYPE CurrentLocationModel TO PlaceLoactionModel
            let currentData = weatherData as? CurrentLocationModel
            print("Data is of type : CurrentLocationModel")
            
            newData = Screen1DataModel(locationName: currentData?.city.name ?? "CTY", info:currentData?.list.first?.weather.first?.main ?? "NA", temp: currentData?.list.first?.main.tempString ?? "TMP", min_max: currentData?.list.first?.main.tempRangeString ?? "MN_MX", imageName: currentData?.list.first?.weather.first?.imageName ?? "NA")
            
        }
        
        screen1DataForBinding.insert(newData, at: 0)
        
        reloadUIForFirstScreen()
    }
    
    func showToast(message: String, seconds: Double) {
        let toast = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        toast.view.backgroundColor = .darkGray
        toast.view.alpha = 0.5
        toast.view.layer.cornerRadius = 20
        self.present(toast, animated: true)
        DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + seconds){
            toast.dismiss(animated: true)
        }
    }
}


extension FirstScreenTableViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        print(locations)
        
        if let locValue = locations.first?.coordinate {
            urlMaker?.lat = String(locValue.latitude)
            urlMaker?.lon = String(locValue.longitude)
            
            print("Cordinates : ",urlMaker?.lat ?? "_LAT_", urlMaker?.lon ?? "_LON_")
            urlMaker?.urlStringMaker()
            
        }else{
            print("Cannot find the coordinates")
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to fetch location")
        print(error)
        showAlert()
        
    }
    
    func reloadUIForFirstScreen(){
        if self.screen1TableView != nil {
            print("screen1TableView EXIST")
            
            DispatchQueue.main.async {
                if self.screen1DataForBinding.count <= 0 {
                    self.screen1TableView.reloadData()
                }
                else{
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.screen1TableView.insertRows(at: [indexPath], with: .automatic)
                }
            }
        }else{
            print("screen1TableView doesn't EXIST")
        }
    }
    
    func showAlert(){
        let alertController = UIAlertController(title: "Need location access", message: "Allow location acces to continue this app", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Give permission", style: .destructive,handler: { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: { _ in
            self.urlMaker?.urlStringMaker()
        }))
        
        present(alertController, animated: true)
    }
}
