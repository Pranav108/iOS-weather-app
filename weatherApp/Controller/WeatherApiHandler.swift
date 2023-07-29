//
//  UrlMaker.swift
//  weatherApp
//
//  Created by Pranav Pratap on 13/07/23.
//

import Foundation

class WeatherApiHandler{
    
    var city : String?
    var lat : String?
    var lon : String?
    
    var delegates : [WeatherApiDelegate?] = [nil,nil]
    
    func getApiData(){
        print(#function, "__START")
        var urlString = API_URL
        if let city = city {
            urlString += "&q=\(city)"
        }else if lat == nil || lon == nil{
            print("CANNOT get LAT and LON")
        }else{
            urlString += "&lat=" + (lat ?? "LAT") + "&lon=" + (lon ?? "LON")
        }
        print(urlString)
        performRequest(urlString: urlString)
        print(#function, "__END")
    }
    
    func performRequest(urlString : String){
        
        // 1. Create a url
        
        if let url = URL(string: urlString) {
            
            // 2. Create a url session
            
            let session = URLSession.shared
            print(#function,"__START")
            // 3. Give the session a task
            
            let task = session.dataTask(with: url, completionHandler:  handler(data:urlResponse:error:))
            // I THINK THIS IS JUST ESCAPING, BUT I'M EXPECTING TO COMPLETE
            
            print(#function,"__END")
            // 4. Start the task
            
            task.resume()
        }
    }
    
    func handler(data : Data?, urlResponse : URLResponse?, error : Error?){
        if let apiData = data {
            print(#function)
            if let actualData = parseJson(weatherData: apiData){
                // BIND THE DATA TO THE UI, WHEN DATA RECIEVED
                print(#function)
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
        print(#function)
        do {
            let decodedWeatherData = try decoder.decode(WeatherDataModel.self, from: weatherData)
            print(#function)
            return decodedWeatherData
        } catch{
            
            print("calling showToast")
            showToastMessage(forMessage: "City NOT found", forSeconds: 1.2)
            print(error)
            return nil
        }
    }
    
    private func showToastMessage(forMessage msg : String,forSeconds sec : Double){
        DispatchQueue.main.async {
            self.delegates[0]?.showToast(message: msg, seconds: sec)
        }
    }
    
    func addWeatherUniquely(forData currentData : WeatherDataModel){
        
        let currentCityID = currentData.city.id
        print(currentData.city.name)
        for (index, data) in fetchedDataList.enumerated(){
            
            if currentCityID == data.city.id {
                
                fetchedDataList.remove(at: index)
                fetchedDataList.insert(currentData, at: 0)
                
                deleteRowFrom = index
                favouriteWeatherList.swapFavouriteWeather(forIndex : index)
                if index == 0 {
                    showToastMessage(forMessage: "Weather updated for \(currentData.city.name)", forSeconds: 1)
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
