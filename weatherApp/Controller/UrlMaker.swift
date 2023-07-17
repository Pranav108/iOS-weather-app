//
//  UrlMaker.swift
//  weatherApp
//
//  Created by Pranav Pratap on 13/07/23.
//

import Foundation

class UrlMaker{
    
    private var apiRequestType : ApiRequestType = .weatherOfCurrentLocation
 
    var city : String?
    var lat : String = "25.5788"
    var lon : String = "91.8831"
//    var lat : String = "23.424076"
//    var lon : String = "53.847816"
    
    // PROVIDING CUSTOM LOCATION SO THAT APP DOESN'T CRASH
    
    var dataByCurrentLocation : WeatherRequestTypeProtocol?
    
    var delegates : [WeatherApiDelegate?] = [nil,nil,nil]
    
    
    func urlStringMaker(){
        print(#function)
        if city != nil {
            apiRequestType = .weatherOfRerquestedPlace
        }
        var urlString = apiRequestType.rawValue
        if let city = city {
            urlString += "&q=\(city)"
        }else{
            urlString += "&lat=" + lat + "&lon=" + lon
        }
        print(urlString)
        performRequest(urlString: urlString)
        print(#function)
    }
    
    func performRequest(urlString : String){
        
        // 1. Create a url
        
        if let url = URL(string: urlString) {
            
            // 2. Create a url session
            
            let session = URLSession.shared
            print(#function)
            // 3. Give the session a task
            
            let task = session.dataTask(with: url, completionHandler:  handler(data:urlResponse:error:))
            // I THINK THIS IS JUST ESCAPING, BUT I'M EXPECTING TO COMPLETE
            
            print(#function)
            // 4. Start the task
            
            task.resume()
        }
    }
    
    func handler(data : Data?, urlResponse : URLResponse?, error : Error?){
        if let apiData = data {
            //            let dataString = String(data: apiData, encoding: .utf8)
            //            print(dataString!)
            print(#function)
            if let actualData = parseJson(weatherData: apiData){
                // BIND THE DATA TO THE UI
                print(#function)
                print(self.apiRequestType)
                print(actualData)
                delegates[0]?.updateUIforFirstScreen(actualData)
                print(apiRequestType)
                
                if apiRequestType == .weatherOfCurrentLocation {
                    print("delegates[1]?.updateUIforSecondScreen(actualData)")
                    self.dataByCurrentLocation = actualData
                    print(delegates)
                    delegates[1]?.updateUIforSecondScreen(actualData)
                    delegates[2]?.updateUIforThirdScreen(actualData)
                    print("delegates[1]?.updateUIforSecondScreen(actualData) - COMPLETED")
                }
            }
        }else {
            print(error!)
        }
    }
    
    func parseJson(weatherData : Data) -> WeatherRequestTypeProtocol?{
        let decoder = JSONDecoder()
        print(#function)
        do {
            print(apiRequestType," in parseJson")
            var decodedWeatherData : WeatherRequestTypeProtocol
            if apiRequestType == .weatherOfRerquestedPlace {
                decodedWeatherData = try decoder.decode(PlaceLoactionModel.self, from: weatherData)
            }else{
                decodedWeatherData = try decoder.decode(CurrentLocationModel.self, from: weatherData)
            }
            // WHY TO USE SELF
            
            print(#function)
            return decodedWeatherData
        } catch{
            print(error)
            return nil
        }
    }
}
