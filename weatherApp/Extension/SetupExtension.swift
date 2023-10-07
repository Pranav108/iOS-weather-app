//
//  FirstScreenSetupExtension.swift
//  weatherApp
//
//  Created by Pranav Pratap on 31/08/23.
//

import Foundation
import UIKit

extension FirstScreenTableViewController {
    
    func setupInitialTableView(){
        let defaults = UserDefaults.standard
        if let savedData = defaults.data(forKey: "favouritePlaces") {
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
            print("CANNOT GET ANY DATA FROM USER_DEFAULT")
        }
        
        DispatchQueue.main.async {
            self.screen1TableView.reloadData()
        }
        spinner.startAnimating()
    }
    
    @objc func switchStateChanged(_ sender: UISwitch) {
           if sender.isOn {
               isDegreeCelsius = true
           } else {
               isDegreeCelsius = false
           }
        screen1TableView.reloadData()
       }
    
    func showToast(message: String, seconds: Double,withBackroundColor bgColor : UIColor = .darkGray) {
        self.spinner.stopAnimating()
        let toast = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        toast.view.backgroundColor = bgColor
        toast.view.layer.cornerRadius = 20
        self.present(toast, animated: true)
        DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + seconds){
            toast.dismiss(animated: true)
        }
    }
    
    func setInitialDelegates(){
        screen1TableView.delegate = self
        screen1TableView.dataSource = self
        searchBar.delegate = self
        locationManager.delegate = self
        urlMaker.delegates[0] = self
    }
    
    func setupHeaderAndSwitchView(){
        switchButton.isOn = true
        switchButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switchButton.addTarget(self, action: #selector(switchStateChanged(_:)), for: .valueChanged)
        
        reusableHeader = ReusableHeader(frame:headerView.bounds)
        headerView.addSubview(reusableHeader!)
    }
    func setupSearchBarView(){
        self.searchBar.placeholder = "Search here"
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UISearchTextField
        let imageV = textFieldInsideSearchBar?.leftView as! UIImageView
        imageV.image = imageV.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imageV.tintColor = UIColor.purple
    }
    
    func setRowLayouts(for row : Screen1TableViewCell, withIndex indexPath: IndexPath){
        if selectedIndexSet.contains(indexPath.row) {
            row.layer.borderColor = CGColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
            row.layer.borderWidth = 15
        }else{
            row.layer.borderWidth = 0
        }
    }
}
