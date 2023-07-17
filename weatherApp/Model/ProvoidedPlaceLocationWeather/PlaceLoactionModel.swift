//
//  currentWeatherDataFormat.swift
//  weatherApp
//
//  Created by Pranav Pratap on 13/07/23.
//

import Foundation

struct PlaceLoactionModel : Decodable, WeatherRequestTypeProtocol{
    let name : String
    let main : MainWeatherContent
    let weather : [WeatherElement]
//    let imageName : String
}

