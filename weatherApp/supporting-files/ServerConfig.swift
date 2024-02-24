//
//  ServerConfig.swift
//  weatherApp
//
//  Created by Pranav Pratap on 02/02/24.
//

import Foundation

class ServerConfig {
    static let shared : ServerConfig = ServerConfig()
    
    private init() {}
    
    // make all the properties as getter only
    var SERVER_URL: String { return self.getValue(for: "SERVER_URL") }
    var CURRENT_ENV: String { return self.getValue(for: "CURRENT_ENV") }
    var WEATHER_API_ID: String { return self.getValue(for: "WEATHER_API_ID") }
    var isDebug: Bool { return (self.CURRENT_ENV == "DEBUG") }
    
    private func getValue(for key : String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
            return "DEFAULT_VALUE_FOR_\(key)"
        }
        return value
    }
}

