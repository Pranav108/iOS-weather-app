//
//  SecondScreenView.swift
//  weatherApp
//
//  Created by Pranav Pratap on 11/07/23.
//

import UIKit


class SecondScreenCollectionViewController : UIViewController{
    
    @IBOutlet weak var collectIonView: UICollectionView!
    
    var urlMaker : UrlMaker?
    
    var screen2DataForBinding : [HourlyForecastModel]?
    
    var reusableHeader : ReusableHeader?
    
    override func viewDidLoad() {
        
        collectIonView.delegate = self
        collectIonView.dataSource = self
        urlMaker?.delegates[1] = self
        
        collectIonView.register(UINib(nibName: "SecondScreenCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SecondScreenCollectionViewCell")
        
        collectIonView.layer.cornerRadius = 10
        print(#function)
        
        reusableHeader = ReusableHeader(frame: CGRect(x: 20, y: 20, width: collectIonView.frame.width, height: collectIonView.frame.height))
        
        view.addSubview(reusableHeader!)

       
        NSLayoutConstraint.activate([
            reusableHeader!.bottomAnchor.constraint(equalTo: collectIonView.topAnchor,constant: -20),
        ])
        
        if urlMaker?.dataByCurrentLocation == nil {
            urlMaker?.urlStringMaker()
        }else{
            self.updateUIforSecondScreen((urlMaker?.dataByCurrentLocation)!)
        }
        
    }
    // viewWillAppear might be called before loading the data of requerst from viewDidLoad
    override func viewWillAppear(_ animated: Bool) {
        
        print(#function, "SecondScreen")
        reloadUIForSecondScreen()
    }
}

extension SecondScreenCollectionViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecondScreenCollectionViewCell", for: indexPath) as! SecondScreenCollectionViewCell
        print(#function)
        
        if let hourlyForecastDataForBinding = screen2DataForBinding {
            let dataToFill = hourlyForecastDataForBinding[indexPath.item]
            cell.weatherIcon.image = UIImage(named: dataToFill.icon)
            cell.forecastingTime.text = (indexPath.item == 0) ? "Now" : dataToFill.hour
            cell.temperatureLabel.text = dataToFill.temperature
            print("Weather Icon : ", dataToFill.info)
            
        }
        return cell
    }
}


extension SecondScreenCollectionViewController : WeatherApiDelegate {
    
    func updateUIforFirstScreen(_ weatherData: WeatherRequestTypeProtocol) {
        print("Dummy updateUIforFirstScreen call from second VC")
    }
    
    func updateUIforSecondScreen(_ weatherData: WeatherRequestTypeProtocol) {
        
        print("CurrentWeather data in SecondScreen")
        print(#function)
        let foreCastData = weatherData as! CurrentLocationModel
        print("Recieved forecast data in updateUIforSecondScreen")
        
        screen2DataForBinding = getForecastHourlyData(foreCastData)
        
        print(#function, "SecondScreen")
        
        reloadUIForSecondScreen()
    }
    
    func updateUIforThirdScreen(_ weatherData: WeatherRequestTypeProtocol) {
        print("Dummy updateUIforThirdScreen call from second VC")
    }
    
    
    func getForecastHourlyData(_ weatherData: CurrentLocationModel) -> [HourlyForecastModel]{
        
        let requiredData = Array(weatherData.list.prefix(8))
        let locationname = weatherData.city.name
        print(#function)
        let result = requiredData.map{
            el in
            return HourlyForecastModel(city : locationname ,hour: el.timeString, info: String(el.weather[0].main), temperature: el.main.tempString, icon: el.weather[0].icon)
        }
        print(#function)
        return result
    }
    
    func reloadUIForSecondScreen(){
        
        if urlMaker?.dataByCurrentLocation != nil{
            if self.collectIonView != nil {
                print("collectIonView EXIST")
                DispatchQueue.main.async {
                    self.collectIonView.reloadData()
                }
            }else{
                print("collectIonView doesn't EXIST")
            }
        }else{
            print(#function, "cannot find screen2DataForBinding data")
        }
        
        self.reusableHeader!.binddataToCard(location: self.screen2DataForBinding?[0].city ?? "CITY_NAME")
    }
}

