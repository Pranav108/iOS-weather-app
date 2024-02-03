//
//  ApiRequestType.swift
//  weatherApp
//
//  Created by Pranav Pratap on 13/07/23.
//

import Foundation
import UIKit

let API_ID = ServerConfig.shared.WEATHER_API_ID

let API_URL = "https://api.openweathermap.org/data/2.5/forecast?appid=\(API_ID)&units=metric"

var deleteRowFrom : Int?
var isDegreeCelsius : Bool = true
var fetchedDataList = [WeatherDataModel]()
var favouriteWeatherList = FavouriteQueue(size: 3)

func getTemperatureStringBasedOnScale(forTemp temp : Float) -> String {
    if (!isDegreeCelsius) {
        return String(Int((temp * 9/5) + 32)) + "˚F"
    }
    return String(Int(temp)) + "˚C"
}

protocol WeatherApiDelegate{
    func updateUIforFirstScreen(deleteRowFrom : Int?)
    func updateUIforSecondScreen()
    func showToast(message : String, seconds : Double, withBackroundColor bgColor : UIColor)
}

extension WeatherApiDelegate{
    func updateUIforFirstScreen(deleteRowFrom : Int? = nil){
        print("Default Inplementation of updateUIforFirstScreen")
    }
    func updateUIforSecondScreen(){
        print("Default Inplementation of updateUIforSecondScreen")
    }
    func showToast(message : String, seconds : Double, withBackroundColor bgColor : UIColor = .darkGray){
        print("Default Inplementation of showToast")
    }
    func showSpinner(){
        print("Default Inplementation of showSpinner")
    }
}

func spinnerSetup(spinner : UIActivityIndicatorView, parentView : UIView){
    spinner.translatesAutoresizingMaskIntoConstraints = false
    parentView.addSubview(spinner)
    NSLayoutConstraint.activate([
        spinner.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
        spinner.centerYAnchor.constraint(equalTo: parentView.centerYAnchor),
        spinner.heightAnchor.constraint(equalTo: parentView.heightAnchor, multiplier: 0.8),
        spinner.widthAnchor.constraint(equalTo: parentView.widthAnchor, multiplier: 0.8),
    ])
    spinner.color = .darkGray
}


func giveDateComponent(fromInt timeInterval : Int64) -> DateComponents{
    
    let dateFromInterval = Date(timeIntervalSince1970: TimeInterval(timeInterval))
    
    let dateComponentFromInterval = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: dateFromInterval)
    return dateComponentFromInterval
    
}
