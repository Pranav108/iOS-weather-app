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
    
    var firstScreenTableViewCell : Screen1TableViewCell?
    
    var spinner = UIActivityIndicatorView(style: .large)
    var urlMaker : WeatherApiHandler?
    var selectedIndexSet : IndexSet = []
    var reusableHeader : ReusableHeader?
    var locationManager = CLLocationManager()
    var selectedRow = 0
    
    //    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    //            self.view.endEditing(true)
    //        }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches..")
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitialDelegates()
        
        setupInitialTableView()
        
        
        
        locationManager.requestWhenInUseAuthorization()
        
        screen1TableView.register(UINib(nibName: "Screen1TableViewCell", bundle: nil), forCellReuseIdentifier: "Screen1TableViewCell")
        setupHeaderView()
        
        setupSearchBarView()
        
        spinnerSetup(spinner: spinner, parentView: view)
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchBarSearchButtonClicked(searchBar)
    }
}

extension FirstScreenTableViewController : UITableViewDelegate, UITableViewDataSource,TableReloaderDelegate{
    func reloadTableView() {
        print("TABLE RELOADED FROM CELL CALL")
        print(favouriteWeatherList.getFavouriteList())
        DispatchQueue.main.async {
            self.screen1TableView.reloadData()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("INITIAL_ROW_COUNT : ", fetchedDataList.count)
        return fetchedDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = tableView.dequeueReusableCell(withIdentifier: "Screen1TableViewCell", for: indexPath) as! Screen1TableViewCell
        //        firstScreenTableViewCell?.reloaderDelegate = self
        print("CELL IS CREATED WITH INDEXPATH : \(indexPath.row)")
        row.tableView = screen1TableView
        row.delegate = self
        setRowLayouts(for: row,withIndex: indexPath)
        
        let currentWeatherData = getBindedModel(weatherData: fetchedDataList[indexPath.item])
        
        bindCellData(withData: currentWeatherData, for: row)
        
        let favList = favouriteWeatherList.getFavouriteList()
        
        if favList.contains(indexPath.row){
            row.favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            print("favList contains : \(indexPath.row)")
        }else{
            row.favButton.setImage(UIImage(systemName: "heart"), for: .normal)
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
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        print(#function)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        spinner.startAnimating()
        print("SEARCHED BUTTON IS CLICKED")
        selectedIndexSet.removeAll()
        screen1TableView.reloadRows(at: [IndexPath(item: selectedRow, section: 0)], with: .automatic)
        
        searchBar.endEditing(true)
        let cityName = searchBar.text!
        let cityWithoutSpaces = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        urlMaker?.city = cityWithoutSpaces.replacingOccurrences(of: " ", with: "+")
        if cityName == "" {
            showToast(message: "Please enter city name", seconds: 1.2)
        }else{
            urlMaker?.getApiData()
        }
        searchBar.text = ""
    }
}

extension FirstScreenTableViewController : WeatherApiDelegate{
    
    func updateUIforFirstScreen() {
        print("CurrentWeather data in FirstScreen")
        if self.screen1TableView != nil {
            print("screen1TableView EXIST")
            DispatchQueue.main.async {
                
                self.screen1TableView.beginUpdates()
                
                if let moveFrom = deleteRowFrom {
                    guard moveFrom < fetchedDataList.count, moveFrom > 0 else {
                        //                        self.screen1TableView.reloadData()
                        self.spinner.stopAnimating()
                        self.screen1TableView.endUpdates()
                        deleteRowFrom = nil
                        return
                    }
                    self.screen1TableView.moveRow(at: IndexPath(item: moveFrom, section: 0), to: IndexPath(row: 0, section: 0))
                    
                    deleteRowFrom = nil
                    
                }else{
                    let indexPathToBeAdded = IndexPath(row: 0, section: 0)
                    self.screen1TableView.insertRows(at: [indexPathToBeAdded], with: .automatic)
                    self.screen1TableView.endUpdates()
                    
                    self.screen1TableView.scrollToRow(at: indexPathToBeAdded,
                                                      at: .top,
                                                      animated: true)
                }
                self.screen1TableView.endUpdates()
                globalIndexOfSelectedRow = 0
                self.spinner.stopAnimating()
                print("FavList : \(favouriteWeatherList.getFavouriteList())")
            }
        }else{
            print("screen1TableView doesn't EXIST")
        }
    }
}

extension FirstScreenTableViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        givePermission(manager)
        print(#function)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        givePermission(manager)
        print(#function)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authorizationStatus = manager.authorizationStatus
        
        print(authorizationStatus.rawValue)
        
        switch authorizationStatus {
        case .restricted, .denied:
            print("PERMISSION NOT GIVEN")
            showAlert()
        case .authorizedAlways , .authorizedWhenInUse:
            spinner.startAnimating()
            givePermission(manager)
        default:
            print("STATUS : UNKNOWN__DEFAULT")
        }
    }
    
    func givePermission(_ manager: CLLocationManager){
        print("PERMISSION GIVEN")
        let location = manager.location
        guard let lat = location?.coordinate.latitude, let lon = location?.coordinate.longitude else {
            locationManager.requestWhenInUseAuthorization()
            //            showToast(message: "Cannot decode LAT and LON \(manager.authorizationStatus.rawValue)", seconds: 1.5)
            return
        }
        urlMaker?.lat = String(lat)
        urlMaker?.lon = String(lon)
        print("Cordinates : ",lat, lon)
        urlMaker?.getApiData()
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

extension FirstScreenTableViewController {
    
    private func setupInitialTableView(){
        let defaults = UserDefaults.standard
        if let savedData = defaults.data(forKey: "favouritePlaces") {
            do {
                let decoder = JSONDecoder()
                
                let decodedData = try decoder.decode([WeatherDataModel].self, from: savedData)
                
                fetchedDataList = decodedData
                
                for index in stride(from: fetchedDataList.count - 1, through: 0, by: -1) {
                    favouriteWeatherList.selectFavourite(havingIndex: index)
                }
                
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
                    self.spinner.stopAnimating()
                })
            }
        }))
        print("SHOWING ALERT")
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: { _ in
            exit(0)
            //            self.spinner.stopAnimating()
        }))
        
        present(alertController, animated: true)
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
    
    private func bindCellData(withData currentWeatherData : Screen1DataModel, for row : Screen1TableViewCell){
        row.placeLabel?.text = currentWeatherData.city
        row.tmpLabel?.text = currentWeatherData.temperature
        row.infoLabel?.text = currentWeatherData.description
        row.tempRangeLabel?.text = currentWeatherData.max_min
        row.backgroundView = UIImageView(image: UIImage(named: currentWeatherData.imageName))
    }
    
    private func setInitialDelegates(){
        screen1TableView.delegate = self
        screen1TableView.dataSource = self
        searchBar.delegate = self
        locationManager.delegate = self
        urlMaker?.delegates[0] = self
        //        firstScreenTableViewCell?.delegate = self
    }
    
    private func setupHeaderView(){
        reusableHeader = ReusableHeader(frame: CGRect(x: 20, y: 20, width: screen1TableView.frame.width, height: screen1TableView.frame.height))
        
        view.addSubview(reusableHeader!)
        reusableHeader?.binddataToCard(withText: "Weather App")
        
        NSLayoutConstraint.activate([
            reusableHeader!.bottomAnchor.constraint(equalTo: searchBar.topAnchor,constant: -20),
        ])
        
    }
    private func setupSearchBarView(){
        self.searchBar.placeholder = "Search here"
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UISearchTextField
        let imageV = textFieldInsideSearchBar?.leftView as! UIImageView
        imageV.image = imageV.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imageV.tintColor = UIColor.purple
        
        searchButton.layer.cornerRadius = 10
        
    }
    
    private func setRowLayouts(for row : Screen1TableViewCell, withIndex indexPath: IndexPath){
        row.selectionStyle = .none
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 5
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: row.bounds.origin.x, y: row.bounds.origin.y, width: row.bounds.width, height: row.bounds.height).insetBy(dx: 10, dy: 10)
        row.layer.mask = maskLayer
        
        if selectedIndexSet.contains(indexPath.row) {
            row.layer.borderColor = CGColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
            row.layer.borderWidth = 15
        }else{
            row.layer.borderWidth = 0
        }
    }
}
