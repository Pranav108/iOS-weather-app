//
//  UsableDataModel.swift
//  weatherApp
//
//  Created by Pranav Pratap on 23/07/23.
//

import Foundation

struct HourlyDataModel {
    let time : String
    let temperature : String
}

struct Screen2DataModel {
    let city : String
    let day : String
    let icon : String
    let humidity : String
    let feelsLike : String
    let hourlyData : [HourlyDataModel]
}
