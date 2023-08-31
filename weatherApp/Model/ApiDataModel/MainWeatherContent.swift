//
//  MainContent.swift
//  weatherApp
//
//  Created by Pranav Pratap on 13/07/23.
//

import Foundation

struct MainWeatherContent : Codable {
    let temp : Float
    let temp_min : Float
    let temp_max : Float
    let humidity : Int
    let feels_like : Float
    
    var humidityString : String{
        return String(Int(humidity)) + "% H"
    }
    var tempString : String{
        return getTemperatureStringBasedOnScale(forTemp: temp)
    }
    var feels_likeString : String{
        return getTemperatureStringBasedOnScale(forTemp: feels_like)
    }
    
    var tempRangeString : String{
        return "H:\(temp_maxString) L:\(temp_minString)"
    }
    var temp_minString : String{
        return String(getTemperatureStringBasedOnScale(forTemp: temp_min).dropLast(1))
    }
    
    var temp_maxString : String{
        return String(getTemperatureStringBasedOnScale(forTemp: temp_max).dropLast(1))
    }
    
}
