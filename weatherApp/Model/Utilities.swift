//
//  ApiRequestType.swift
//  weatherApp
//
//  Created by Pranav Pratap on 13/07/23.
//

import Foundation
import UIKit

enum ApiRequestType : String{
    case weatherOfRerquestedPlace = "https://api.openweathermap.org/data/2.5/weather?appid=c79b6cb39826aca9755ade5999cd13bd&units=metric"
    case weatherOfCurrentLocation = "https://api.openweathermap.org/data/2.5/forecast?appid=c79b6cb39826aca9755ade5999cd13bd&units=metric"
}

protocol WeatherRequestTypeProtocol{
    
}

protocol WeatherApiDelegate{
    func updateUIforFirstScreen(_ weatherData : WeatherRequestTypeProtocol)
    func updateUIforSecondScreen(_ weatherData : WeatherRequestTypeProtocol)
    func updateUIforThirdScreen(_ weatherData : WeatherRequestTypeProtocol)
    func showToast(message : String, seconds : Double)
}

extension WeatherApiDelegate{
    func updateUIforFirstScreen(_ weatherData : WeatherRequestTypeProtocol){
        print("Default Inplementation of updateUIforFirstScreen")
    }
     func updateUIforSecondScreen(_ weatherData : WeatherRequestTypeProtocol){
        print("Default Inplementation of updateUIforSecondScreen")
    }
     func updateUIforThirdScreen(_ weatherData : WeatherRequestTypeProtocol){
        print("Default Inplementation of updateUIforThirdScreen")
    }
    func showToast(message : String, seconds : Double){
        print("Default Inplementation of showToast")
    }
}

//            PlaceLoactionModel

//            name : String
//            main : MainWeatherContent
//            weather : [WeatherElement]
//
//            MainWeatherContent
//            temp : Float
//            temp_min : Float
//            temp_max : Float
//            humidity : Int
//            tempRangeString : String
//
//            [WeatherElement]
//            id : Int
//            main : String
//            description : String
//            icon : String


//            CurrentLocationModel

//            list : [TimeStampData]
//            city : City
//
//            City
//            name : String
//
//            [TimeStampData]
//            dt_txt : String
//            main : MainWeatherContent
//            weather : [WeatherElement]
//
