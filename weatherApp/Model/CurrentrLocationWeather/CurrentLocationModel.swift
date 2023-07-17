//
//  CurrentLocationModel.swift
//  weatherApp
//
//  Created by Pranav Pratap on 14/07/23.
//

import Foundation

struct CurrentLocationModel : Decodable, WeatherRequestTypeProtocol{
    var list : [TimeStampData]
    var city : City
}

