//
//  UrlMaker.swift
//  weatherApp
//
//  Created by Pranav Pratap on 13/07/23.
//

import Foundation

class WeatherApiHandler{
    
    var city : String?
    var lat : String = "25.5788"
    var lon : String = "91.8831"
    //    var lat : String = "23.424076"
    //    var lon : String = "53.847816"
    
    // PROVIDING CUSTOM LOCATION SO THAT APP DOESN'T CRASH
    
    var fetchedDataList = [WeatherDataModel]()
    
    var delegates : [WeatherApiDelegate?] = [nil,nil]
    
    func getApiData(){
        print(#function)
        var urlString = API_URL
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
            print(#function)
            if let actualData = parseJson(weatherData: apiData){
                // BIND THE DATA TO THE UI, WHEN DATA RECIEVED
                print(#function)
//                print(actualData)
                fetchedDataList.insert(actualData, at: 0)
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
            DispatchQueue.main.async {
                self.delegates[0]?.showToast(message: "City Not found", seconds: 1.2)
            }
            print(error)
            return nil
        }
    }
    
}
