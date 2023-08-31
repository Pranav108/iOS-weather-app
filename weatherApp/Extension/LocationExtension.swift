//
//  LocationExtension.swift
//  weatherApp
//
//  Created by Pranav Pratap on 31/08/23.
//

import Foundation
import CoreLocation
import UIKit

extension FirstScreenTableViewController : CLLocationManagerDelegate {
    
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
            print(authorizationStatus.rawValue)
            showAlert(forPromptTitle: "Need location access", withMessage: "Allow location acces to continue this app")
        case .authorizedAlways :
            print(authorizationStatus.rawValue)
            getLocationData(manager.location)
        case .authorizedWhenInUse :
            print(authorizationStatus.rawValue)
            locationManager.requestLocation()
        default:
            print("STATUS : UNKNOWN__DEFAULT")
        }
    }
    
    func getLocationData(_ location: CLLocation?){
        guard let lat = location?.coordinate.latitude, let lon = location?.coordinate.longitude else {
            showToast(message: "Unable to get location", seconds: 1.5)
            spinner.stopAnimating()
            return
        }
        urlMaker.lat = String(lat)
        urlMaker.lon = String(lon)
        print("Cordinates : ",lat, lon)
        if isReachableToNetwork {
            spinner.startAnimating()
            urlMaker.getApiData()
        }else {
            self.showToast(message: "Internet Connection Needed", seconds: 2,withBackroundColor: .red)
        }
    }
    func showAlert(forPromptTitle title : String,withMessage message : String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let alertController = UIAlertController(title: "Need location access", message: "Allow location acces to continue this app", preferredStyle: .alert)
//
        alertController.addAction(UIAlertAction(title: "Give permission", style: .destructive,handler: { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    self.spinner.stopAnimating()
                })
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: { _ in
            self.spinner.stopAnimating()
        }))
        
        present(alertController, animated: true)
    }
    
}
