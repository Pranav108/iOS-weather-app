//
//  HomeViewController.swift
//  weatherApp
//
//  Created by Pranav Pratap on 25/12/23.
//

import UIKit

import CoreLocation
import Reachability

class HomeViewController: UIViewController {
    
    @IBOutlet weak var outerBlurView: UIView!
    
    @IBOutlet weak var screen1TableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var switchButton: UISwitch!
    
    @IBOutlet weak var headerView: UIView!
    
//    var firstScreenTableViewCell : Screen1TableViewCell!
    var blurEffectView : UIVisualEffectView?
    var reusableHeader : ReusableHeader?
    
    var redHeader = UIColor(red: 1, green: 179 / 255.0, blue: 179 / 255.0, alpha: 1)
    var greenHeader = UIColor(red: 179 / 255.0, green: 1, blue: 179 / 255.0, alpha: 1)
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
        
        blurViewSetup()
        checkNetworkConnectionStatus()
        screen1TableView.register(UINib(nibName: "Screen1TableViewCell", bundle: nil), forCellReuseIdentifier: "Screen1TableViewCell")
        setupHeaderAndInfoView()
        setupSearchBarView()
        spinnerSetup(spinner: spinner, parentView: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.resignFirstResponder()
        screen1TableView.reloadData() // DUE TO TEMPERATURE SCALE CHANGE
    }
    
    deinit{
        reachability.stopNotifier()
    }
}

extension HomeViewController : WeatherApiDelegate {
    func updateUIforFirstScreen() {
        if self.screen1TableView != nil {
            DispatchQueue.main.async {
                
                self.screen1TableView.beginUpdates()
                
                if let moveFrom = Variable.deleteRowFrom {
                    guard moveFrom < fetchedDataList.count, moveFrom > 0 else {
                        self.spinner.stopAnimating()
                        self.screen1TableView.endUpdates()
                        Variable.deleteRowFrom = nil
                        return
                    }
                    self.screen1TableView.moveRow(at: IndexPath(item: moveFrom, section: 0), to: IndexPath(row: 0, section: 0))
                    
                    Variable.deleteRowFrom = nil
                    
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

// MARK: - EXTENSION FOR HomeViewController
extension HomeViewController {
    func getBindedModel(weatherData : WeatherDataModel) -> Screen1DataModel{
        
        let city : String = weatherData.city.name
        let imageName : String = weatherData.list.first?.weather.first?.imageName ?? "IMAGE_NAME"
        let description : String = weatherData.list.first?.weather.first?.description ?? "DESCRIPTION"
        let max_min : String = weatherData.list.first?.main.tempRangeString ?? "MAX_MIN"
        let temperature : String = weatherData.list.first?.main.tempString ?? "TEMP"
        
        let newData = Screen1DataModel(city: city, imageName: imageName, description: description, max_min: max_min, temperature: temperature)
        return newData
    }
    
    func bindCellData(withData currentWeatherData : Screen1DataModel, for row : Screen1TableViewCell){
        row.placeLabel?.text = currentWeatherData.city
        row.tmpLabel?.text = currentWeatherData.temperature
        row.infoLabel?.text = currentWeatherData.description
        row.tempRangeLabel?.text = currentWeatherData.max_min
        row.backgroundView = UIImageView(image: UIImage(named: currentWeatherData.imageName))
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
    
    func setInitialDelegates(){
        screen1TableView.delegate = self
        screen1TableView.dataSource = self
        searchBar.delegate = self
        locationManager.delegate = self
        urlMaker.delegates[0] = self
    }
    
    func setupHeaderAndInfoView(){
        // Configure the info button here
       
        reusableHeader = ReusableHeader(frame:headerView.bounds)
        headerView.addSubview(reusableHeader!)
    }
    func setupSearchBarView(){
        self.searchBar.placeholder = "Search here"
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UISearchTextField
        let imageV = textFieldInsideSearchBar?.leftView as! UIImageView
        imageV.image = imageV.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imageV.tintColor = UIColor.purple
    }
    
    func setRowLayouts(for row : Screen1TableViewCell, withIndex indexPath: IndexPath){
        if selectedIndexSet.contains(indexPath.row) {
            row.layer.borderColor = CGColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
            row.layer.borderWidth = 15
        }else{
            row.layer.borderWidth = 0
        }
    }
    
    // MARK: - THIS SHOULD BE COMMON THROUGH THE APP
    func showAlert(forPromptTitle title : String,withMessage message : String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
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
    
}
