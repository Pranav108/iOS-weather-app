//
//  SecondScreenView.swift
//  weatherApp
//
//  Created by Pranav Pratap on 11/07/23.
//

import UIKit

var screen2DataForBinding : [UseableDataModel]?

class SecondScreenTableViewController : UIViewController{

    @IBOutlet weak var tableView: UITableView!
    
    var urlMaker : UrlMaker?
    
    var reusableHeader : ReusableHeader?
    
    var expandedIndexSet : IndexSet = []
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        urlMaker?.delegates[1] = self
        
//        tableView.register(UINib(nibName: "SecondScreenCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SecondScreenCollectionViewCell")
        
//        tableView.layer.cornerRadius = 10
//        print(#function)
//
//        reusableHeader = ReusableHeader(frame: CGRect(x: 20, y: 20, width: tableView.frame.width, height: tableView.frame.height))
//
//        view.addSubview(reusableHeader!)
//
//
//        NSLayoutConstraint.activate([
//            reusableHeader!.bottomAnchor.constraint(equalTo: tableView.topAnchor,constant: -20),
//        ])
//
//        if urlMaker?.dataByCurrentLocation == nil {
//            urlMaker?.urlStringMaker()
//        }else{
//            self.updateUIforSecondScreen((urlMaker?.dataByCurrentLocation)!)
//        }
        
    }
    // viewWillAppear might be called before loading the data of requerst from viewDidLoad
    override func viewWillAppear(_ animated: Bool) {
        
        print(#function, "SecondScreen")
        reloadUIForSecondScreen()
    }
}


extension SecondScreenTableViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "SecondScreenTableViewCell", for: indexPath) as! SecondScreenTableViewCell
        row.collectionView?.tag = indexPath.item
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
            return 300
        }
        return 120
    }
    
}



extension SecondScreenTableViewController : WeatherApiDelegate {
    
    func updateUIforSecondScreen() {
        
        print("CurrentWeather data in SecondScreen")
        let weatherData = urlMaker?.weatherData
        
        //  FORCE_UNRAPPED
        screen2DataForBinding = getForecastHourlyData(weatherData!)
        
        print(#function, "SecondScreen")
        
        reloadUIForSecondScreen()
    }
    
    func getForecastHourlyData(_ weatherData: WeatherDataModel) -> [UseableDataModel]{
        
        //        struct HourlyDataModel {
        //            let time : String
        //            let temperature : String
        //        }
        //
        //        struct UseableDataModel {
        //            let city : String
        //            let day : String
        //            let icon : String
        //            let humidity : String
        //            let feelsLike : String
        //            let hourlyData : [HourlyDataModel]
        //        }
        var dataForBinding = [UseableDataModel]()
        
        let dataList = weatherData.list
        let city = weatherData.city.name
        
        for lowerRange in 0...4 {
            let el = dataList[0]
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
            let useableDataModel = UseableDataModel(city : city, day: day, icon: icon, humidity: humidity, feelsLike: feelsLike, hourlyData: hourlyData)
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
                }
            }else{
                print("tableView doesn't EXIST")
            }
        }else{
            print(#function, "cannot find screen2DataForBinding data")
        }
        
//        self.reusableHeader!.binddataToCard(location: screen2DataForBinding?[0].city ?? "CITY_NAME")
    }
}

