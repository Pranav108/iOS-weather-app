//
//  TimeStampData.swift
//  weatherApp
//
//  Created by Pranav Pratap on 14/07/23.
//

import Foundation


struct ForeCastDataElement : Decodable{
    let dt_txt : String
    let main : MainWeatherContent
    let weather : [WeatherElement]
    
    var timeString : String{
        let hour : Int = Int(dt_txt.split(separator: " ")[1].split(separator: ":")[0])!
        if hour == 0 {
            return "12AM"
        }else if hour == 12 {
            return "12PM"
        }else if hour > 12 {
            return "\(hour%12)PM"
        }else{
            return "\(hour)AM"
        }
    }
    
    var dayName : String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let forecastDate = dateFormatter.date(from: dt_txt)
        let myCalendar = Calendar(identifier: .indian)
        let weekDayIndex = myCalendar.component(.weekday, from: forecastDate!)
        return dateFormatter.shortWeekdaySymbols[weekDayIndex - 1]
        
    }
}
