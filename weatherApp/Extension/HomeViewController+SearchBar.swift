//
//  searchExtension.swift
//  weatherApp
//
//  Created by Pranav Pratap on 31/08/23.
//

import Foundation
import UIKit

extension HomeViewController : UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        applyBlurEffect()
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        removeBlurEffect()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        selectedIndexSet.removeAll()
        screen1TableView.reloadRows(at: [IndexPath(item: selectedRow, section: 0)], with: .automatic)
        
        searchBar.endEditing(true)
        let providedCityName = searchBar.text!
        let cityWithoutSpaces = providedCityName.trimmingCharacters(in: .whitespacesAndNewlines)
        let cityName = cityWithoutSpaces.replacingOccurrences(of: " ", with: "+")
        if cityName == "" {
            showToast(message: "Please enter city name", seconds: 1.2,withBackroundColor: .orange)
        }else if isReachableToNetwork{
            spinner.startAnimating()
            urlMaker.makeApiCall(for: cityName)
        }else {
            self.showToast(message: "Internet Connection Needed", seconds: 1.5,withBackroundColor: .red)
        }
        searchBar.text = ""
    }
}
