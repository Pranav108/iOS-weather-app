//
//  Utilities.swift
//  weatherApp
//
//  Created by Pranav Pratap on 13/07/23.
//

import UIKit

var fetchedDataList = [WeatherDataModel]()
var favouriteWeatherList = FavouriteQueue(size: 3)

func getTemperatureStringBasedOnScale(forTemp temp : Float) -> String {
    if (Variable.isDegreeFahrenheit) {
        return String(Int((temp * 9/5) + 32)) + "˚F"
    }
    return String(Int(temp)) + "˚C"
}

protocol WeatherApiDelegate{
    func updateUIforFirstScreen()
    func updateUIforSecondScreen()
    func showToast(message : String, seconds : Double, withBackroundColor bgColor : UIColor)
}

extension WeatherApiDelegate{
    func updateUIforFirstScreen(){
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
