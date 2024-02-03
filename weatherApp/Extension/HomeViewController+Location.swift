//
//  LocationExtension.swift
//  weatherApp
//
//  Created by Pranav Pratap on 31/08/23.
//

import Foundation
import CoreLocation
import UIKit

extension HomeViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        getLocationData(locations.last)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        getLocationData(manager.location)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authorizationStatus = manager.authorizationStatus
        switch authorizationStatus {
        case .restricted, .denied:
            showAlert(forPromptTitle: "Need location access", withMessage: "Allow location acces to continue this app")
        case .authorizedAlways :
            getLocationData(manager.location)
        case .authorizedWhenInUse :
            locationManager.requestLocation()
        default:
            print("STATUS : UNKNOWN__DEFAULT")
            self.spinner.stopAnimating()
        }
    }
    
    func getLocationData(_ location: CLLocation?){
        guard let lat = location?.coordinate.latitude, let lon = location?.coordinate.longitude else {
            showToast(message: "Unable to get location", seconds: 1.5)
            spinner.stopAnimating()
            return
        }
        print("Cordinates : ",lat, lon)
        if isReachableToNetwork {
            spinner.startAnimating()
            urlMaker.makeApiCallForCordinate(lat: String(lat), lon: String(lon))
        }else {
            self.showToast(message: "Internet Connection Needed", seconds: 2,withBackroundColor: .red)
        }
    }
}
