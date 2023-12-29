//
//  tableViewExtension.swift
//  weatherApp
//
//  Created by Pranav Pratap on 31/08/23.
//

import Foundation
import UIKit

extension HomeViewController : UITableViewDelegate, UITableViewDataSource,TableReloaderDelegate{
    func reloadTableView() {
        DispatchQueue.main.async {
            self.screen1TableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount = fetchedDataList.count
        
        tableView.backgroundView?.isHidden = rowCount > 0
        
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = tableView.dequeueReusableCell(withIdentifier: "Screen1TableViewCell", for: indexPath) as! Screen1TableViewCell
        //        firstScreenTableViewCell?.reloaderDelegate = self
        row.tableView = screen1TableView
        row.delegate = self
        setRowLayouts(for: row,withIndex: indexPath)
        
        let currentWeatherData = getBindedModel(weatherData: fetchedDataList[indexPath.item])
        bindCellData(withData: currentWeatherData, for: row)
        
        let favList = favouriteWeatherList.getFavouriteList()
        if favList.contains(indexPath.row){
            row.favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else{
            row.favButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        return row
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(selectedIndexSet.contains(indexPath.row)){
            selectedIndexSet.removeAll()
        } else {
            selectedIndexSet.removeAll()
            selectedIndexSet.insert(indexPath.row)
        }
        
        selectedRow = indexPath.row
        tableView.beginUpdates()
        tableView.reloadData()
        tableView.endUpdates()
        
        if let tabBarController = self.tabBarController,
           let viewControllers = tabBarController.viewControllers,
           let secondViewController = viewControllers[1] as? ForecastViewController {
            secondViewController.indexOfSelectedRow = indexPath.row
            tabBarController.selectedIndex = 1
        }
        
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            fetchedDataList.remove(at: indexPath.row)
            favouriteWeatherList.deleteRow(withIndex: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        deleteAction.backgroundColor = .systemGray4
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
