//
//  AppDelegate.swift
//  weatherApp
//
//  Created by Pranav Pratap on 10/07/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        readValuesFromUserDefault()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // Added my me
    func applicationWillTerminate(_ application: UIApplication) {
        setValuesInUSerDefault()
    }

    // MARK: Custom properties
    private enum UserDefaultKeys: String {
        case favouritePlaces = "favouritePlaces"
        case isDegreeFahrenheit = "isDegreeFahrenheit"
    }
    
    // MARK: Custom methods
    private func setValuesInUSerDefault(){
        // For favouriteWeatherList
        let favList = favouriteWeatherList.getFavouriteList()
        var favouritePlaces = [WeatherDataModel]()
        
        for el in favList {
            favouritePlaces.append(fetchedDataList[el])
        }
        
        if let encoded = try? JSONEncoder().encode(favouritePlaces) {
            UserDefaults.standard.set(encoded, forKey: UserDefaultKeys.favouritePlaces.rawValue )
        }else{
            print("cannot set favouritePlaces values")
        }
        
        // For isDegreeFahrenheit
        UserDefaults.standard.set(Variable.isDegreeFahrenheit, forKey: UserDefaultKeys.isDegreeFahrenheit.rawValue)
        
    }
    
    private func readValuesFromUserDefault(){
        let defaults = UserDefaults.standard
        if let savedData = defaults.data(forKey: UserDefaultKeys.favouritePlaces.rawValue) {
            do {
                let decoder = JSONDecoder()
                
                let decodedData = try decoder.decode([WeatherDataModel].self, from: savedData)
                
                fetchedDataList = decodedData
                
                for index in stride(from: fetchedDataList.count - 1, through: 0, by: -1) {
                    favouriteWeatherList.selectFavourite(havingIndex: index)
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        } else {
            print("CANNOT GET favouritePlaces DATA FROM USER_DEFAULT")
        }
        
        Variable.isDegreeFahrenheit = defaults.bool(forKey: UserDefaultKeys.isDegreeFahrenheit.rawValue)
        
    }

}
