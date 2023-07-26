//
//  AppDelegate.swift
//  weatherApp
//
//  Created by Pranav Pratap on 10/07/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
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
        
//        let favouritePlaces = Array(fetchedDataList.prefix(3))
        let favList = favouriteWeatherList.getFavouriteList()
        var favouritePlaces = [WeatherDataModel]()
        
        for el in favList {
            favouritePlaces.append(fetchedDataList[el])
        }
        
        if let encoded = try? JSONEncoder().encode(favouritePlaces) {
            
            print("SETTING value to Default : ", favouritePlaces.count)
            UserDefaults.standard.set(encoded, forKey: "favouritePlaces" )
        }else{
            print("cannot set userDefault values")
        }
    }


}
