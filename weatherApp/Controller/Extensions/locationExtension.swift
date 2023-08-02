//
//  locationExtension.swift
//  weatherApp
//
//  Created by Pranav Pratap on 02/08/23.
//

import Foundation
import CoreLocation
import UIKit

extension FirstScreenTableViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        getLocationData(locations.last)
        print(#function)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        getLocationData(manager.location)
        print(#function)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authorizationStatus = manager.authorizationStatus
        
        print(authorizationStatus.rawValue)
        
        switch authorizationStatus {
        case .restricted, .denied:
            print("PERMISSION NOT GIVEN")
            locationAlert()
        case .authorizedAlways :
            getLocationData(manager.location)
        case .authorizedWhenInUse :
            locationManager.requestLocation()
        default:
            print("STATUS : UNKNOWN__DEFAULT")
        }
    }
    
    func getLocationData(_ location: CLLocation?){
        print("PERMISSION GIVEN")
        guard let lat = location?.coordinate.latitude, let lon = location?.coordinate.longitude else {
            showToast(message: "Unable to get location", seconds: 1.5)
            spinner.stopAnimating()
            return
        }
        urlMaker?.lat = String(lat)
        urlMaker?.lon = String(lon)
        print("Cordinates : ",lat, lon)
        urlMaker?.getApiData()
    }
    
    func locationAlert(){
        let alertController = UIAlertController(title: "Need location access", message: "Allow location acces to continue this app", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Give permission", style: .destructive,handler: { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }))
        print("SHOWING ALERT")
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true)
        self.spinner.stopAnimating()
    }
    
}
