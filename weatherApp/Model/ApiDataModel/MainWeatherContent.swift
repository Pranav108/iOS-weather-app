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
        return String(Int(temp)) + "˚C"
    }
    var feels_likeString : String{
        return String(Int(feels_like)) + "˚C"
    }
    
    var tempRangeString : String{
        return "H:\(temp_maxString)˚ L:\(temp_minString)˚"
    }
    var temp_minString : String{
        return String(Int(temp_min))
    }
    
    var temp_maxString : String{
        return String(Int(temp_max))
    }
    
}
