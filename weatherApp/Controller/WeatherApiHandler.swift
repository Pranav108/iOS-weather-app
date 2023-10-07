//
//  UrlMaker.swift
//  weatherApp
//
//  Created by Pranav Pratap on 13/07/23.
//

import Foundation
import UIKit

class WeatherApiHandler{
    
    var city : String?
    var lat : String?
    var lon : String?
    var isInitalLocationCallDone = false
    
    var delegates : [WeatherApiDelegate?] = [nil,nil]
    
    func getApiData(){
        var urlString = API_URL
        if (city != nil) && isInitalLocationCallDone{
            urlString += "&q=\(city ?? "")"
            performRequest(urlString: urlString)
        }else if lat == nil || lon == nil{
            print("CANNOT get LAT and LON")
        }else{
            urlString += "&lat=" + (lat ?? "LAT") + "&lon=" + (lon ?? "LON")
            performRequest(urlString: urlString)
            isInitalLocationCallDone = true
        }
    }
    
    func performRequest(urlString : String){
        
        // 1. Create a url
        
        if let url = URL(string: urlString) {
            
            // 2. Create a url session
            
            let session = URLSession.shared
            // 3. Give the session a task
            
            let task = session.dataTask(with: url, completionHandler:  handler(data:urlResponse:error:))
            // I THINK THIS IS JUST ESCAPING, BUT I'M EXPECTING TO COMPLETE
            
            // 4. Start the task
            
            task.resume()
        }
    }
    
    func handler(data : Data?, urlResponse : URLResponse?, error : Error?){
        if let apiData = data {
            if let actualData = parseJson(weatherData: apiData){
                // BIND THE DATA TO THE UI, WHEN DATA RECIEVED
                addWeatherUniquely(forData: actualData)
                delegates[0]?.updateUIforFirstScreen()
                delegates[1]?.updateUIforSecondScreen()
            }else{
                print("CANNOT GET PARSED_DATA")
            }
        }else {
            print("ERROR FROM HANDLER : ",error!)
        }
        
    }
    func parseJson(weatherData : Data) -> WeatherDataModel?{
        let decoder = JSONDecoder()
        do {
            let decodedWeatherData = try decoder.decode(WeatherDataModel.self, from: weatherData)
            return decodedWeatherData
        } catch{
            showToastMessage(forMessage: "City NOT found", forSeconds: 1.2)
            return nil
        }
    }
    
    private func showToastMessage(forMessage msg : String, forSeconds sec : Double, withBackroundColor bgColor: UIColor = .darkGray){
        DispatchQueue.main.async {
            self.delegates[0]?.showToast(message: msg, seconds: sec, withBackroundColor: bgColor)
        }
    }
    
    func addWeatherUniquely(forData currentData : WeatherDataModel){
        
        let currentCityID = currentData.city.id
        for (index, data) in fetchedDataList.enumerated(){
            
            if currentCityID == data.city.id {
                
                fetchedDataList.remove(at: index)
                fetchedDataList.insert(currentData, at: 0)
                
                deleteRowFrom = index
                favouriteWeatherList.swapFavouriteWeather(forIndex : index)
                if index == 0 {
                    showToastMessage(forMessage: "Weather updated for \(currentData.city.name)",forSeconds: 1,withBackroundColor: .green)
                }
                return
            }else{
                print("city name is \(data.city.name)")
            }
        }
        favouriteWeatherList.slideFavList()
        fetchedDataList.insert(currentData, at: 0)
    }
    
}
