//
//  ApiRequestType.swift
//  weatherApp
//
//  Created by Pranav Pratap on 13/07/23.
//

import Foundation
import UIKit

let API_KEY = "c79b6cb39826aca9755ade5999cd13bd"
let API_URL = "https://api.openweathermap.org/data/2.5/forecast?appid=\(API_KEY)&units=metric"

var fetchedDataList = [WeatherDataModel]()
var favouriteWeatherList = FavouriteQueue(size: 3)

protocol WeatherApiDelegate{
    func updateUIforFirstScreen(deleteRowFrom : Int?)
    func updateUIforSecondScreen()
    func showToast(message : String, seconds : Double)
}

extension WeatherApiDelegate{
    func updateUIforFirstScreen(deleteRowFrom : Int? = nil){
        print("Default Inplementation of updateUIforFirstScreen")
    }
    func updateUIforSecondScreen(){
        print("Default Inplementation of updateUIforSecondScreen")
    }
    func showToast(message : String, seconds : Double){
        print("Default Inplementation of showToast")
    }
    func showSpinner(){
        print("Default Inplementation of showSpinner")
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        print(#function)
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
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
