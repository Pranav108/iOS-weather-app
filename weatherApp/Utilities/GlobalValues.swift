//
//  GlobalValues.swift
//  weatherApp
//
//  Created by Pranav Pratap on 24/02/24.
//

import Foundation

// Global Constants
enum Constant {
    static let API_ID = ServerConfig.shared.WEATHER_API_ID
    
    static let API_URL = "https://api.openweathermap.org/data/2.5/forecast?appid=\(API_ID)&units=metric"

}

// Global Constants
enum Variable {
    static var isDegreeFahrenheit = false
    static var deleteRowFrom: Int?
}
