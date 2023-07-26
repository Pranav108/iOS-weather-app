//
//  SecondScreenView.swift
//  weatherApp
//
//  Created by Pranav Pratap on 11/07/23.
//

import UIKit

var screen2DataForBinding : [Screen2DataModel]?

class SecondScreenTableViewController : UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    var spinner = UIActivityIndicatorView(style: .large)
    
    var urlMaker : WeatherApiHandler?
    
    var reusableHeader : ReusableHeader?
    
    var expandedIndexSet : IndexSet = []
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        urlMaker?.delegates[1] = self
        
        
        tableView.layer.cornerRadius = 10
        print(#function)
        
        reusableHeader = ReusableHeader(frame: CGRect(x: 20, y: 20, width: tableView.frame.width, height: tableView.frame.height))
//        reusableHeader?.backgroundColor = .green
        
        view.addSubview(reusableHeader!)
        
        NSLayoutConstraint.activate([
            reusableHeader!.bottomAnchor.constraint(equalTo: tableView.topAnchor,constant: -20),
        ])
        spinnerSetup(spinner: spinner, parentView: view)
        
        updateUIforSecondScreen()
        
    }
    // viewWillAppear might be called before loading the data of requerst from viewDidLoad
    override func viewWillAppear(_ animated: Bool) {
        
        print(#function, "SecondScreen")
        updateUIforSecondScreen()
    }
}

extension SecondScreenTableViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        if screen2DataForBinding != nil{
            rowCount = (screen2DataForBinding?.count ?? 10)
            print("screen2DataForBinding is NOT nill")
        }
        print("number_Of_Rows_In_Section : ",rowCount)
        return rowCount
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "SecondScreenTableViewCell", for: indexPath) as! SecondScreenTableViewCell
        
        row.collectionView?.tag = indexPath.item
        
//        print("ROW is created : ", indexPath.item)
        let data = screen2DataForBinding?[indexPath.item]
        row.weatherLogo.image = UIImage(named: data?.icon ?? "Clear")
        row.dayLabel.text = data?.day ?? "TODAY"
        row.humidityLabel.text = data?.humidity ?? "00"
        row.feelsLikeLabel.text = data?.feelsLike ?? "00"
        // THIS DATA IS NOT CONSISTENT
        
        row.selectionStyle = .none
        row.animate()
        row.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 5
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: row.bounds.origin.x, y: row.bounds.origin.y, width: row.bounds.width, height: row.bounds.height).insetBy(dx: 16, dy: 10)
        row.layer.mask = maskLayer
        
        return row
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(expandedIndexSet.contains(indexPath.row)){
            expandedIndexSet.remove(indexPath.row)
        } else {
            // if the cell is not expanded, add it to the indexset to expand it
            expandedIndexSet.insert(indexPath.row)
        }
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
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
        DispatchQueue.main.async{
            self.spinner.startAnimating()
        }
//        let indexOfSelectedRow = userDefault.integer(forKey: "indexOfSelectedRow")
        
//        print("indexOfSelectedRow : ", globalIndexOfSelectedRow)
        
        let weatherData : WeatherDataModel
        if (fetchedDataList.count > globalIndexOfSelectedRow) {
            weatherData = fetchedDataList[globalIndexOfSelectedRow]
        }else{
            print("Cannot find fetchedDataList")
            return
        }
        
        screen2DataForBinding = getForecastHourlyData(weatherData)
        
        print(#function, "SecondScreen")
        
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
        if screen2DataForBinding != nil{
            if self.tableView != nil {
                print("tableView EXIST")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    print("TABLE VIEW RELOADED")
                    self.spinner.stopAnimating()
                }
            }else{
                print("tableView doesn't EXIST")
            }
        }else{
            print(#function, "cannot find screen2DataForBinding data")
        }
        
        self.reusableHeader!.binddataToCard(withText: screen2DataForBinding?[0].city ?? "CITY_NAME")
    }
}

