//
//  firstScreenTableViewController.swift
//  weatherApp
//
//  Created by Pranav Pratap on 10/07/23.
//

//unable to dequeue a cell with identifier screen1TableViewCell - must register a nib or a class for the identifier or connect a prototype cell in a storyboard"

import UIKit

import CoreLocation
import Reachability

class FirstScreenTableViewController: UIViewController {
    
    @IBOutlet weak var outerBlurView: UIView!
    
    @IBOutlet weak var screen1TableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var switchButton: UISwitch!
    
    @IBOutlet weak var headerView: UIView!
    
    var firstScreenTableViewCell : Screen1TableViewCell!
    var blurEffectView: UIVisualEffectView?
    
    var spinner = UIActivityIndicatorView(style: .large)
    var urlMaker = WeatherApiHandler()
    var selectedIndexSet : IndexSet = []
    var backgroundView: BackgroundView!
    var locationManager = CLLocationManager()
    var selectedRow = 0
    let reachability = try! Reachability()
    var isReachableToNetwork = false
    var shouldNotifyOnInternetAvailable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitialDelegates()
        
        backgroundView = BackgroundView()
        screen1TableView.backgroundView = backgroundView
        
        setupInitialTableView()
        
        blurViewSetup()
        
        checkNetworkConnectionStatus()
        
        locationManager.requestWhenInUseAuthorization()
        
        screen1TableView.register(UINib(nibName: "Screen1TableViewCell", bundle: nil), forCellReuseIdentifier: "Screen1TableViewCell")
        
        setupHeaderAndSwitchView()
        
        setupSearchBarView()
        
        spinnerSetup(spinner: spinner, parentView: view)
    }
    
    func checkNetworkConnectionStatus(){
        DispatchQueue.main.async {
            self.reachability.whenReachable = {
                reachability in
                if reachability.connection == .wifi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
                self.isReachableToNetwork = true
                
                if self.shouldNotifyOnInternetAvailable {
                    self.showToast(message: "Internet Connection Available", seconds: 1.2,withBackroundColor: .green)
                }
                
                if (((self.urlMaker.lat) != nil) && ((self.urlMaker.lon) != nil) && (!self.urlMaker.isInitalLocationCallDone))  {
                    self.spinner.startAnimating()
                    self.urlMaker.getApiData()
                }
            }
            self.reachability.whenUnreachable = { _ in
                self.isReachableToNetwork = false
                self.showToast(message: "Internet Connection Needed", seconds: 2,withBackroundColor: .red)
                self.shouldNotifyOnInternetAvailable = true
            }

            do {
                try self.reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }
    }
    deinit{
        reachability.stopNotifier()
    }
    override func viewWillAppear(_ animated: Bool) {
        searchBar.resignFirstResponder()
    }
    
    @objc func switchStateChanged(_ sender: UISwitch) {
           if sender.isOn {
               isDegreeCelsius = true
           } else {
               isDegreeCelsius = false
           }
        screen1TableView.reloadData()
       }
    
    func applyBlurEffect() {
        screen1TableView.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.4) {
            self.blurEffectView?.alpha = 0.7
        }
    }
    
    func blurViewSetup(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.lightGray .cgColor,UIColor.clear.cgColor]
        gradientLayer.locations = [0.0, 0.05, 1.0]
        
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView!.contentView.layer.addSublayer(gradientLayer)
        blurEffectView!.frame = outerBlurView.bounds
        outerBlurView.addSubview(blurEffectView!)
        blurEffectView?.alpha = 0
    }
    
    func removeBlurEffect() {
        UIView.animate(withDuration: 0.4) {
            self.blurEffectView?.alpha = 0
        } completion: { _ in
            self.screen1TableView.isUserInteractionEnabled = true
        }
    }
}

extension FirstScreenTableViewController : UITableViewDelegate, UITableViewDataSource,TableReloaderDelegate{
    func reloadTableView() {
        DispatchQueue.main.async {
            self.screen1TableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount = fetchedDataList.count
        
        tableView.backgroundView?.isHidden = rowCount > 0
        
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = tableView.dequeueReusableCell(withIdentifier: "Screen1TableViewCell", for: indexPath) as! Screen1TableViewCell
        //        firstScreenTableViewCell?.reloaderDelegate = self
        row.tableView = screen1TableView
        row.delegate = self
        setRowLayouts(for: row,withIndex: indexPath)
        
        let currentWeatherData = getBindedModel(weatherData: fetchedDataList[indexPath.item])
        
        bindCellData(withData: currentWeatherData, for: row)
        
        let favList = favouriteWeatherList.getFavouriteList()
        
        if favList.contains(indexPath.row){
            row.favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
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
        tableView.beginUpdates()
        tableView.reloadData()
        tableView.endUpdates()
        
        if let tabBarController = self.tabBarController,
           let viewControllers = tabBarController.viewControllers,
           let secondViewController = viewControllers[1] as? SecondScreenTableViewController {
            secondViewController.indexOfSelectedRow = indexPath.row
            tabBarController.selectedIndex = 1
        }
        
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            fetchedDataList.remove(at: indexPath.row)
            favouriteWeatherList.deleteRow(withIndex: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        deleteAction.backgroundColor = .systemGray4
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

extension FirstScreenTableViewController : UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        applyBlurEffect()
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        removeBlurEffect()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        selectedIndexSet.removeAll()
        screen1TableView.reloadRows(at: [IndexPath(item: selectedRow, section: 0)], with: .automatic)
        
        searchBar.endEditing(true)
        let cityName = searchBar.text!
        let cityWithoutSpaces = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        urlMaker.city = cityWithoutSpaces.replacingOccurrences(of: " ", with: "+")
        if cityName == "" {
            showToast(message: "Please enter city name", seconds: 1.2,withBackroundColor: .orange)
        }else if isReachableToNetwork{
            spinner.startAnimating()
            urlMaker.getApiData()
        }else {
            self.showToast(message: "Internet Connection Needed", seconds: 1.5,withBackroundColor: .red)
        }
        searchBar.text = ""
    }
}

extension FirstScreenTableViewController : WeatherApiDelegate{
    
    func updateUIforFirstScreen() {
        if self.screen1TableView != nil {
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
                self.spinner.stopAnimating()
            }
        }else{
            print("screen1TableView doesn't EXIST")
        }
    }
}

extension FirstScreenTableViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        getLocationData(locations.last)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        getLocationData(manager.location)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authorizationStatus = manager.authorizationStatus
        switch authorizationStatus {
        case .restricted, .denied:
            showAlert()
        case .authorizedAlways :
            getLocationData(manager.location)
        case .authorizedWhenInUse :
            locationManager.requestLocation()
        default:
            print("STATUS : UNKNOWN__DEFAULT")
        }
    }
    
    func getLocationData(_ location: CLLocation?){
        guard let lat = location?.coordinate.latitude, let lon = location?.coordinate.longitude else {
            showToast(message: "Unable to get location", seconds: 1.5)
            spinner.stopAnimating()
            return
        }
        urlMaker.lat = String(lat)
        urlMaker.lon = String(lon)
        print("Cordinates : ",lat, lon)
        if isReachableToNetwork {
            spinner.startAnimating()
            urlMaker.getApiData()
        }
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
                    self.spinner.stopAnimating()
                })
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: { _ in
            self.spinner.stopAnimating()
        }))
        
        present(alertController, animated: true)
    }
    
    func showToast(message: String, seconds: Double,withBackroundColor bgColor : UIColor = .darkGray) {
        self.spinner.stopAnimating()
        let toast = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        toast.view.backgroundColor = bgColor
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
        urlMaker.delegates[0] = self
    }
    
    private func setupHeaderAndSwitchView(){
        switchButton.isOn = true
        switchButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switchButton.addTarget(self, action: #selector(switchStateChanged(_:)), for: .valueChanged)
        
        let reusableHeader = ReusableHeader(frame:headerView.bounds)
        headerView.addSubview(reusableHeader)
    }
    private func setupSearchBarView(){
        self.searchBar.placeholder = "Search here"
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UISearchTextField
        let imageV = textFieldInsideSearchBar?.leftView as! UIImageView
        imageV.image = imageV.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imageV.tintColor = UIColor.purple
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
