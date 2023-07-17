//
//  WeatherElement.swift
//  weatherApp
//
//  Created by Pranav Pratap on 13/07/23.
//

import Foundation

struct WeatherElement : Decodable {
    let id : Int
    let main : String
    let description : String
    
    var icon : String{
        if (700..<800).contains(id) {
            return "Else"
        }else{
            return main
        }
    }
    
    var imageName : String{
        if (700..<800).contains(id) {
            return "Else_Img.jpg"
        }else{
            return main + "_Img.jpg"
        }
    }
    
}
