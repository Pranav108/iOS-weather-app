//
//  WeatherDataModel.swift
//  weatherApp
//
//  Created by Pranav Pratap on 23/07/23.
//

import Foundation

struct WeatherDataModel : Decodable {
    let list : [ForeCastDataElement]
    let city : City
    
}
