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
            showAlert(forPromptTitle: "Need location access", withMessage: "Allow location acces to continue this app")
        case .authorizedAlways :
            getLocationData(manager.location)
        case .authorizedWhenInUse :
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
        print("Cordinates : ",lat, lon)
        if isReachableToNetwork {
            spinner.startAnimating()
            urlMaker.makeApiCallForCordinate(lat: String(lat), lon: String(lon))
        }else {
            self.showToast(message: "Internet Connection Needed", seconds: 2,withBackroundColor: .red)
        }
    }
    func showAlert(forPromptTitle title : String,withMessage message : String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

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
