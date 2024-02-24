//
//  UrlMaker.swift
//  weatherApp
//
//  Created by Pranav Pratap on 13/07/23.
//

import Foundation
import UIKit

class WeatherApiHandler{
    
    var delegates : [WeatherApiDelegate?] = [nil,nil]
    private var isApiCallForCurrentLocation : Bool = false
    
    func makeApiCallForCordinate(lat : String, lon : String){
        isApiCallForCurrentLocation = true
        let urlWithCordinates = Constant.API_URL + "&lat=" + (lat) + "&lon=" + (lon)
        performRequest(urlString: urlWithCordinates)
    }
    
    func makeApiCall(for cityName : String){
        isApiCallForCurrentLocation = false
        let urlWithCityName = Constant.API_URL + "&q=\(cityName)"
        performRequest(urlString: urlWithCityName)
    }
    
    private func performRequest(urlString : String){
        
        // 1. Create a url
        if let url = URL(string: urlString) {
            
            // 2. Create a url session
            let session = URLSession.shared
            // 3. Give the session a task
            
            let task = session.dataTask(with: url, completionHandler:  handler(data:urlResponse:error:))
            
            // 4. Start the task
            task.resume()
        }
    }
    
    private func handler(data : Data?, urlResponse : URLResponse?, error : Error?){
        if let apiData = data {
            if let actualData = parseJson(weatherData: apiData){
                // BIND THE DATA TO THE UI, WHEN DATA RECIEVED
                addWeatherUniquely(forData: actualData)
                delegates[0]?.updateUIforFirstScreen()
                delegates[1]?.updateUIforSecondScreen()
            }else{
                showToastMessage(forMessage: "CANNOT GET PARSED_DATA")
            }
        }else {
            showToastMessage(forMessage: "\(String(describing: error?.localizedDescription))")
        }
    }
    
    private func parseJson(weatherData : Data) -> WeatherDataModel?{
        let decoder = JSONDecoder()
        do {
            let decodedWeatherData = try decoder.decode(WeatherDataModel.self, from: weatherData)
            return decodedWeatherData
        } catch{
            showToastMessage(forMessage: "City NOT found", forSeconds: 1.2)
            return nil
        }
    }
    
    private func showToastMessage(forMessage msg : String, forSeconds sec : Double = 1.2, withBackroundColor bgColor: UIColor = .darkGray){
        DispatchQueue.main.async {
            self.delegates[0]?.showToast(message: msg, seconds: sec, withBackroundColor: bgColor)
        }
    }
    
    // TODO: - Have to remove this function from WeatherApiHandler
    private func addWeatherUniquely(forData currentData : WeatherDataModel){
        
        let currentCityID = currentData.city.id
        for (index, data) in fetchedDataList.enumerated(){
            
            if currentCityID == data.city.id {
                
                fetchedDataList.remove(at: index)
                fetchedDataList.insert(currentData, at: 0)
                
                Variable.deleteRowFrom = index
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
        
        // the below block is at inappro
        if (isApiCallForCurrentLocation) {
            let manager = NotificationHandler()
            
            let sunriseDateComponent = giveDateComponent(fromInt: currentData.city.sunset)
            let sunsetDateComponent = giveDateComponent(fromInt: currentData.city.sunset)
            
            manager.addNotification(title: "Heyy, see the Sunrise ",body: "This is sunrise time in \(currentData.city.name)",dateComponent: sunriseDateComponent)
             manager.addNotification(title: "Heyy, see the Sunset",body: "This is sunset time in \(currentData.city.name)",dateComponent: sunsetDateComponent)
            
            manager.schedule()
    
        }
    }
}
