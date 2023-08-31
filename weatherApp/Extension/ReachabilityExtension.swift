//
//  ReachabilityExtension.swift
//  weatherApp
//
//  Created by Pranav Pratap on 31/08/23.
//

import Foundation
import UIKit
extension FirstScreenTableViewController {
    func checkNetworkConnectionStatus(){
        DispatchQueue.main.async {
            self.reachability.whenReachable = {
                reachability in
                if reachability.connection == .wifi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
                self.isReachableToNetwork = true
                self.reusableHeader?.binddataToCard(withText: "Weather App",withBackgroundColor: self.greenHeader)
                self.locationManager.requestWhenInUseAuthorization()
                
                if self.shouldNotifyOnInternetAvailable {
                    self.showToast(message: "Internet Connection Available", seconds: 1.2,withBackroundColor: .green)
                }
                
            }
            self.reachability.whenUnreachable = { _ in
                self.isReachableToNetwork = false
                self.reusableHeader?.binddataToCard(withText: "No Internet",withBackgroundColor: self.redHeader)
                self.showAlert(forPromptTitle: "Need internet access", withMessage: "Need internet acces to continue this app")
                self.shouldNotifyOnInternetAvailable = true
            }

            do {
                try self.reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }
    }
}
