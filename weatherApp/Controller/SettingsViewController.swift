//
//  SettingsViewController.swift
//  weatherApp
//
//  Created by Pranav Pratap on 25/12/23.
//

import UIKit

class SettingsViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    
    let headerHeightInTableView : Double =  35
    let cellHeightInTableView : Double =  50
    var settingModalArray : [SettingSectionProtocol] {
        let locationCell = ToggleSettingCell(cellLabel: .locationPermissionSwitch, switchStatus: true)
        let themeCell = ToggleSettingCell(cellLabel: .themeSwitch, switchStatus: false)
        let temperatureScaleCell = ToggleSettingCell(cellLabel: .temperatureScaleSwitch, switchStatus: true)
        let basicSection = ToggleSwitchSectionModal(headerString: "Basics", toggelableCells: [locationCell, themeCell,temperatureScaleCell ])
        
        let aboutApp = InfoSettingCell(cellLabel: .aboutApp)
        let contactSupport = InfoSettingCell(cellLabel: .contactSupport)
        let moreInfoSection = InfoSettingSectionModal(headerString: "More Info", moreInfoCells: [aboutApp, contactSupport])
        
        return [basicSection, moreInfoSection]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemTeal
        tableView.register(ToggleSettingTableViewCell.nibName, forCellReuseIdentifier: ToggleSettingTableViewCell.identifier)
        tableView.register(SettingInfoTableViewCell.nibName, forCellReuseIdentifier: SettingInfoTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
    }
}

extension SettingsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let currentSectionValue = settingModalArray[section]
        let sectionHeaderString = currentSectionValue.headerString
        return configureHeader(for: sectionHeaderString)
    }
    
    private func configureHeader(for headerString : String) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.contentSize.width, height: headerHeightInTableView))
        
        let labelView = UILabel(frame: CGRect(x: 10, y: 0, width: (headerView.frame.width) , height: headerHeightInTableView))
        labelView.bounds = labelView.frame
        labelView.text = headerString
        labelView.textColor = .darkGray
        headerView.addSubview(labelView)
        return headerView
    }
}
extension SettingsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSectionValue = settingModalArray[section]
        switch section {
        case 0:
            let toggleSwitchSectionModal = currentSectionValue as! ToggleSwitchSectionModal, toggelableCells = toggleSwitchSectionModal.toggelableCells
            return toggelableCells.count
            
        case 1:
            let moreInfoSectionModal = currentSectionValue as! InfoSettingSectionModal, moreInfoCells = moreInfoSectionModal.moreInfoCells
            return moreInfoCells.count
        default: break
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingModalArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeightInTableView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeightInTableView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentSectionValue = settingModalArray[indexPath.section]
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ToggleSettingTableViewCell.identifier, for: indexPath) as! ToggleSettingTableViewCell
            cell.switchCallBackDelegate = self
            let toggleSwitchSectionModal = currentSectionValue as! ToggleSwitchSectionModal, toggelableCells = toggleSwitchSectionModal.toggelableCells
            cell.configureToggelableCell(for: toggelableCells[indexPath.row].cellLabel , with: toggelableCells[indexPath.row].switchStatus)
            return cell
            
        case 1 :
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingInfoTableViewCell.identifier, for: indexPath) as! SettingInfoTableViewCell
            cell.settInfoCallBackDelegate = self
            let moreInfoSectionModal = currentSectionValue as! InfoSettingSectionModal, moreInfoCells = moreInfoSectionModal.moreInfoCells
            cell.configureMoreInfoLableCell(for: moreInfoCells[indexPath.row].cellLabel)
            return cell
        default:break        }
        return UITableViewCell()
    }
}

extension SettingsViewController : SettingSwitchDelegateProtocol {
    func didSwitchTapped(for toggleType: ToggleType, changedTo isSwitchOn: Bool) {
        print("Button with label :\(toggleType.rawValue) is changed to \(isSwitchOn)")
    }
}

extension SettingsViewController : SettingMoreInfoDelegateProtocol {
    func openInfoScreenTapped(for nestedSettingType: NestedSettingType) {
        print("have to open another screen for : \(nestedSettingType.rawValue)")
    }
}
