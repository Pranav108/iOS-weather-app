//
//  SecondScreenView.swift
//  weatherApp
//
//  Created by Pranav Pratap on 11/07/23.
//

import UIKit

var screen2DataForBinding = [Screen2DataModel]()

class SecondScreenTableViewController : UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    var backgroundView: BackgroundView!
    
    var urlMaker : WeatherApiHandler?
    
    var reusableHeader : ReusableHeader?
    
    var expandedIndexSet : IndexSet = []
    
    var indexOfSelectedRow = 0
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        urlMaker?.delegates[1] = self
        
        backgroundView = BackgroundView()
        backgroundView.imageWithName(as: "empty-box")
        tableView.backgroundView = backgroundView
        
        print(#function)
        setupHeaderView()
        
        updateUIforSecondScreen()
        
    }
    // viewWillAppear might be called before loading the data of requerst from viewDidLoad
    override func viewWillAppear(_ animated: Bool) {
        
        print(#function, "SecondScreen")
        updateUIforSecondScreen()
    }
    override func viewDidDisappear(_ animated: Bool) {
        indexOfSelectedRow = 0
    }
}

extension SecondScreenTableViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rowCount = screen2DataForBinding.count
       
        tableView.backgroundView?.isHidden = rowCount > 0
        
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "SecondScreenTableViewCell", for: indexPath) as! SecondScreenTableViewCell
        
        row.collectionView?.tag = indexPath.item
        
        let data = screen2DataForBinding[indexPath.item]
            bindCellData(forRow : row, withData : data)
        
        
        giveBorders(toRow: row)
        return row
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var indexPathList = [IndexPath]()
        
        for el in expandedIndexSet{
            indexPathList.append(IndexPath(row: el, section: 0))
        }
        
        if(expandedIndexSet.contains(indexPath.row)){
            expandedIndexSet.removeAll()
        } else {
            // if the cell is not expanded, add it to the indexset to expand it
            expandedIndexSet.removeAll()
            expandedIndexSet.insert(indexPath.row)
            indexPathList.append(indexPath)
        }
        
        tableView.beginUpdates()
        tableView.reloadRows(at: indexPathList, with: .automatic)
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if expandedIndexSet.contains(indexPath.row) {
            return 260
        }
        return 80
    }
    
}

extension SecondScreenTableViewController : WeatherApiDelegate {
    
    func updateUIforSecondScreen() {
        expandedIndexSet.removeAll()
        print("CurrentWeather data in SecondScreen")

        let weatherData : WeatherDataModel
        if (fetchedDataList.count > indexOfSelectedRow) {
            weatherData = fetchedDataList[indexOfSelectedRow]
            screen2DataForBinding = getForecastHourlyData(weatherData)
        }else{
            screen2DataForBinding.removeAll()
        }
        
        reloadUIForSecondScreen()
    }
    
    func getForecastHourlyData(_ weatherData: WeatherDataModel) -> [Screen2DataModel]{
        
        var dataForBinding = [Screen2DataModel]()
        
        let dataList = weatherData.list
        let city = weatherData.city.name
        
        for lowerRange in 0...4 {
            let el = dataList[lowerRange*8]
            let day : String = el.dayName
            let icon : String = el.weather.first?.icon ?? "ICON"
            let humidity : String = el.main.humidityString
            let feelsLike : String = el.main.feels_likeString
            
            var hourlyData = [HourlyDataModel]()
            
            for i in stride(from: lowerRange * 8, to: (lowerRange+1) * 8 , by: 1) {
                let time : String = dataList[i].timeString
                let temperature : String = dataList[i].main.tempString
                hourlyData.append(HourlyDataModel(time: time, temperature: temperature))
            }
            let useableDataModel = Screen2DataModel(city : city, day: day, icon: icon, humidity: humidity, feelsLike: feelsLike, hourlyData: hourlyData)
            dataForBinding.append(useableDataModel)
        }
        
        return dataForBinding
    }
    
    func reloadUIForSecondScreen(){
        if self.tableView != nil {
            print("tableView EXIST")
            DispatchQueue.main.async {
                self.tableView.reloadData()
                print("TABLE VIEW RELOADED")
            }
        }else{
            print("tableView doesn't EXIST")
        }
        var textToBind = "Nothing to show"
        if screen2DataForBinding.count > 0 {
            textToBind = screen2DataForBinding[0].city
        }
        self.reusableHeader!.binddataToCard(withText: textToBind)
    }
}

extension SecondScreenTableViewController {
    private func bindCellData(forRow row : SecondScreenTableViewCell, withData data : Screen2DataModel){
        row.weatherLogo.image = UIImage(named: data.icon )
        row.dayLabel.text = data.day
        row.humidityLabel.text = data.humidity
        row.feelsLikeLabel.text = data.feelsLike
    }
    private func giveBorders(toRow row : SecondScreenTableViewCell){
        row.selectionStyle = .none
        row.animate()
        row.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 5
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: row.bounds.origin.x, y: row.bounds.origin.y, width: row.bounds.width, height: row.bounds.height).insetBy(dx: 16, dy: 10)
        row.layer.mask = maskLayer
    }
    private func setupHeaderView(){
        reusableHeader = ReusableHeader(frame: CGRect(x: 20, y: 20, width: tableView.frame.width, height: tableView.frame.height))
        
        view.addSubview(reusableHeader!)
        
        NSLayoutConstraint.activate([
            reusableHeader!.bottomAnchor.constraint(equalTo: tableView.topAnchor,constant: -20),
        ])
    }
}
