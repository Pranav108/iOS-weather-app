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
    
    var spinner = UIActivityIndicatorView(style: .large)
    var urlMaker : WeatherApiHandler?
    var selectedIndexSet : IndexSet = []
    var reusableHeader : ReusableHeader?
    var locationManager = CLLocationManager()
    var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screen1TableView.delegate = self
        screen1TableView.dataSource = self
        searchBar.delegate = self
        locationManager.delegate = self
        urlMaker?.delegates[0] = self
        
        setupInitialTableView()
       
        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
        
        reusableHeader = ReusableHeader(frame: CGRect(x: 20, y: 20, width: screen1TableView.frame.width, height: screen1TableView.frame.height))
        
        view.addSubview(reusableHeader!)
        reusableHeader?.binddataToCard(withText: "Weather App")
        
        NSLayoutConstraint.activate([
            reusableHeader!.bottomAnchor.constraint(equalTo: searchBar.topAnchor,constant: -20),
        ])
        
        screen1TableView.register(UINib(nibName: "Screen1TableViewCell", bundle: nil), forCellReuseIdentifier: "Screen1TableViewCell")
        
        self.searchBar.placeholder = "Search here"
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UISearchTextField
        let imageV = textFieldInsideSearchBar?.leftView as! UIImageView
        imageV.image = imageV.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imageV.tintColor = UIColor.purple
        
        searchButton.layer.cornerRadius = 10
        
        spinnerSetup(spinner: spinner, parentView: view)
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authorizationStatus = manager.authorizationStatus
        
        print(authorizationStatus.rawValue)
        
        switch authorizationStatus {
        case .restricted, .denied:
            print("PERMISSION NOT GIVEN")
            showAlert()
        case .authorizedAlways, .authorizedWhenInUse:
            givePermission(manager)
        default:
            print("STATUS : UNKNOWN__DEFAULT")
        }
    }
    func givePermission(_ manager: CLLocationManager){
        print("PERMISSION GIVEN")
        let location = manager.location
        guard let lat = location?.coordinate.latitude, let lon = location?.coordinate.longitude else {
            showToast(message: "Cannot decode LAT and LON \(manager.authorizationStatus.rawValue)", seconds: 1.5)
            return
        }
        urlMaker?.lat = String(lat)
        urlMaker?.lon = String(lon)
        print("Cordinates : ",lat, lon)
        urlMaker?.getApiData()
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchBarSearchButtonClicked(searchBar)
    }
}

extension FirstScreenTableViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("INITIAL_ROW_COUNT : ", fetchedDataList.count)
        return fetchedDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = tableView.dequeueReusableCell(withIdentifier: "Screen1TableViewCell", for: indexPath) as! Screen1TableViewCell
        
        row.selectionStyle = .none
        
        let maskLayer = CALayer()
        
        maskLayer.cornerRadius = 5
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: row.bounds.origin.x, y: row.bounds.origin.y, width: row.bounds.width, height: row.bounds.height).insetBy(dx: 10, dy: 10)
        row.layer.mask = maskLayer
        
//        print("MAKING ROWS : ", indexPath.item)
        let currentWeatherData = getBindedModel(weatherData: fetchedDataList[indexPath.item])
        row.placeLabel?.text = currentWeatherData.city
        row.tmpLabel?.text = currentWeatherData.temperature
        row.infoLabel?.text = currentWeatherData.description
        row.tempRangeLabel?.text = currentWeatherData.max_min
        row.backgroundView = UIImageView(image: UIImage(named: currentWeatherData.imageName))
        
        
        if selectedIndexSet.contains(indexPath.row) {
            row.layer.borderColor = CGColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
            row.layer.borderWidth = 15
//            print("Border is selected : ", indexPath.row)
        }else{
//            print("Border is NOT selected : ", indexPath.row)
            row.layer.borderWidth = 0
        }
        
        return row
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(selectedIndexSet.contains(indexPath.row)){
            selectedIndexSet.removeAll()
        } else {
            selectedIndexSet.removeAll()
            selectedIndexSet.insert(indexPath.row)
        }
        
        selectedRow = indexPath.row
        globalIndexOfSelectedRow = indexPath.row
        tableView.reloadData()
        
        
        let indexData : [String: Int] = ["Index": 1]
        NotificationCenter.default.post(name: Notification.Name("changeIndex"), object: nil,userInfo: indexData)
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
        spinner.startAnimating()
        print("SEARCHED BUTTON IS CLICKED")
        selectedIndexSet.removeAll()
        screen1TableView.reloadRows(at: [IndexPath(item: selectedRow, section: 0)], with: .automatic)
        
        searchBar.endEditing(true)
        let cityName = searchBar.text!
        
        urlMaker?.city = cityName.replacingOccurrences(of: " ", with: "+")
        if cityName == "" {
            showToast(message: "Please enter city name", seconds: 1.2)
        }else{
            urlMaker?.getApiData()
        }
        searchBar.text = ""
    }
}

extension FirstScreenTableViewController : WeatherApiDelegate{
    
    func setupInitialTableView(){
        let defaults = UserDefaults.standard
        if let savedData = defaults.data(forKey: "favouritePlaces") {
            do {
                let decoder = JSONDecoder()
                
                let decodedData = try decoder.decode([WeatherDataModel].self, from: savedData)
                
                fetchedDataList = decodedData
                
                print("RETRIVED DATA FROM USER_DEFAULTS",decodedData.count)
            } catch {
                print("Error decoding data: \(error)")
            }
        } else {
            print("CANNOT GET ANY DATA FROM USER_DEFAULT")
        }
        
        DispatchQueue.main.async {
            self.screen1TableView.reloadData()
        }
        spinner.startAnimating()
//        globalIndexOfSelectedRow = fetchedDataList.count -
    }
    
    func updateUIforFirstScreen() {
        print("CurrentWeather data in FirstScreen")
        if self.screen1TableView != nil {
            print("screen1TableView EXIST")
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: 0, section: 0)
                self.screen1TableView.insertRows(at: [indexPath], with: .automatic)
                globalIndexOfSelectedRow = 0
                self.spinner.stopAnimating()
            }
        }else{
            print("screen1TableView doesn't EXIST")
        }
    }
    
    func showToast(message: String, seconds: Double) {
        self.spinner.stopAnimating()
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
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
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
        print("SHOWING ALERT")
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: { _ in
            exit(0)
        }))
        
        present(alertController, animated: true)
    }
}

func getBindedModel(weatherData : WeatherDataModel) -> Screen1DataModel{
    
    let city : String = weatherData.city.name
    let imageName : String = weatherData.list.first?.weather.first?.imageName ?? "IMAGE_NAME"
    let description : String = weatherData.list.first?.weather.first?.description ?? "DESCRIPTION"
    let max_min : String = weatherData.list.first?.main.tempRangeString ?? "MAX_MIN"
    let temperature : String = weatherData.list.first?.main.tempString ?? "TEMP"
    
    let newData = Screen1DataModel(city: city, imageName: imageName, description: description, max_min: max_min, temperature: temperature)
    return newData
}
