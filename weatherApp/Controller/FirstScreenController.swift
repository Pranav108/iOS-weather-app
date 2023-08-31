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
    var blurEffectView : UIVisualEffectView?
    var reusableHeader : ReusableHeader?
    
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
        
        screen1TableView.register(UINib(nibName: "Screen1TableViewCell", bundle: nil), forCellReuseIdentifier: "Screen1TableViewCell")
        
        setupHeaderAndSwitchView()
        
        setupSearchBarView()
        
        spinnerSetup(spinner: spinner, parentView: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.resignFirstResponder()
    }
    
    deinit{
        reachability.stopNotifier()
    }
}

extension FirstScreenTableViewController : WeatherApiDelegate{
    func updateUIforFirstScreen() {
        if self.screen1TableView != nil {
            DispatchQueue.main.async {
                
                self.screen1TableView.beginUpdates()
                
                if let moveFrom = deleteRowFrom {
                    guard moveFrom < fetchedDataList.count, moveFrom > 0 else {
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
extension FirstScreenTableViewController {
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
    
}
