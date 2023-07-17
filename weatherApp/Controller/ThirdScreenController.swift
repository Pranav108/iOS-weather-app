//
//  ThirdScreenView.swift
//  weatherApp
//
//  Created by Pranav Pratap on 12/07/23.
//

import UIKit

class ThirdScreenTableViewController: UIViewController {
    
    @IBOutlet weak var screen3TableView: UITableView!
    
    var screen3DataForBinding : [DailyForecastModel]?
    
    var urlMaker : UrlMaker?
    
    var reusableHeader : ReusableHeader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screen3TableView.delegate = self
        screen3TableView.dataSource = self
        urlMaker?.delegates[2] = self
        
        screen3TableView.register(UINib(nibName: "ThirdScreenTableViewCell", bundle: nil), forCellReuseIdentifier: "ThirdScreenTableViewCell")
        
        screen3TableView.layer.cornerRadius = 10
        
        reusableHeader = ReusableHeader(frame: CGRect(x: 20, y: 20, width: screen3TableView.frame.width, height: screen3TableView.frame.height))
        
        view.addSubview(reusableHeader!)
        NSLayoutConstraint.activate([
            reusableHeader!.bottomAnchor.constraint(equalTo: screen3TableView.topAnchor,constant: -20),
        ])
        
        
        if urlMaker?.dataByCurrentLocation == nil {
            urlMaker?.urlStringMaker()
        }else{
            self.updateUIforThirdScreen((urlMaker?.dataByCurrentLocation)!)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        print(#function, "ThirdScreen")
        reloadUIForThirdScreen()
    }

}

extension ThirdScreenTableViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = screen3TableView.dequeueReusableCell(withIdentifier: "ThirdScreenTableViewCell", for: indexPath) as! ThirdScreenTableViewCell
        
        if let dailyForecastDataForBinding = screen3DataForBinding{
            let dataToFill = dailyForecastDataForBinding[indexPath.item]
            row.weatherIcon.image = UIImage(named: dataToFill.icon)
            row.dayNameLabel.text = dataToFill.dayName
            row.humidityLabel.text = dataToFill.humidity+"🌫"
            row.tempLabel.text = dataToFill.temperature+"🌡"
        }
        
        return row
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension ThirdScreenTableViewController : WeatherApiDelegate{
    func updateUIforFirstScreen(_ weatherData: WeatherRequestTypeProtocol) {
        print("Dummy updateUIforFirstScreen call from Third VC")
    }
    
    func updateUIforSecondScreen(_ weatherData: WeatherRequestTypeProtocol) {
        print("Dummy updateUIforSecondScreen call from Third VC")
    }
    
    func updateUIforThirdScreen(_ weatherData: WeatherRequestTypeProtocol) {
        
        print("CurrentWeather data in ThirdScreen")
        print(#function)
        let foreCastData = weatherData as! CurrentLocationModel
        
        screen3DataForBinding = getForecastDailyData(foreCastData)
        print(#function)
        
        reloadUIForThirdScreen()
    }
    
    func getForecastDailyData(_ weatherData: CurrentLocationModel) -> [DailyForecastModel]{
        
        var requiredData = [TimeStampData]()
        let locationname = weatherData.city.name
        for i in 0...4 {
            requiredData.append(weatherData.list[i*8])
        }
        
        print(#function)
        let result = requiredData.map{
            el in
            return DailyForecastModel(city : locationname,
                dayName : el.dayName ,icon: String(el.weather[0].main), temperature: el.main.tempString, humidity: el.main.humidityString)
        }
        print(#function)
        return result
    }
    
    func reloadUIForThirdScreen(){
        if urlMaker?.dataByCurrentLocation != nil{
            
            if self.screen3TableView != nil {
                print("screen3TableView EXIST")
                DispatchQueue.main.async {
                    self.screen3TableView.reloadData()
                }
            }else{
                print("screen3TableView doesn't EXIST")
            }
        }else{
            print(#function, "cannot find screen3DataForBinding data")
        }
        self.reusableHeader!.binddataToCard(location: self.screen3DataForBinding?[0].city ?? "CITY_NAME")
    }
}
