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
    
    var reusableHeader : ReusableHeader?
    var backgroundView: BackgroundView!
    var locationManager = CLLocationManager()
    var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitialDelegates()
        
        backgroundView = BackgroundView()
        screen1TableView.backgroundView = backgroundView
        
        setupInitialTableView()
        
        locationManager.requestWhenInUseAuthorization()
        
        screen1TableView.register(UINib(nibName: "Screen1TableViewCell", bundle: nil), forCellReuseIdentifier: "Screen1TableViewCell")
        
        setupHeaderView()
        
        setupSearchBarView()
        
        spinnerSetup(spinner: spinner, parentView: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.resignFirstResponder()
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
        let rowCount = fetchedDataList.count
        
        tableView.backgroundView?.isHidden = rowCount > 0
        
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = tableView.dequeueReusableCell(withIdentifier: "Screen1TableViewCell", for: indexPath) as! Screen1TableViewCell
        //        firstScreenTableViewCell?.reloaderDelegate = self
        print("CELL IS CREATED WITH INDEXPATH : \(indexPath.row)")
        row.tableView = screen1TableView
        row.delegate = self
        //        setRowLayouts(for: row,withIndex: indexPath)
        
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
        
        let row  = tableView.cellForRow(at: indexPath) as! Screen1TableViewCell
        row.togggleSelection(for : indexPath.row)
        
        selectedRow = indexPath.row
        
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
        print(#function)
        return configuration
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        print(#function)
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
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
        Screen1TableViewCell.selectedIndexSet.removeAll()
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
    
    func updateUIforFirstScreen(deleteRowFrom : Int? ){
        print("CurrentWeather data in FirstScreen")
        DispatchQueue.main.async {
            
            self.screen1TableView.beginUpdates()
            
            if let moveFrom = deleteRowFrom {
                guard moveFrom < fetchedDataList.count, moveFrom > 0 else {
                    
                    self.showToast(message: "Weather updated for \(fetchedDataList.first?.city.name ?? "CITY")", seconds: 1)
                    self.screen1TableView.endUpdates()
                    return
                }
                self.screen1TableView.moveRow(at: IndexPath(item: moveFrom, section: 0), to: IndexPath(row: 0, section: 0))
                
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
            print("FavList : \(favouriteWeatherList.getFavouriteList())")
            
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
    
    private func setupInitialTableView() {
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
    
}
