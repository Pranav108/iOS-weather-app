//
//  SettingModals.swift
//  weatherApp
//
//  Created by Pranav Pratap on 30/12/23.
//

import Foundation

// MARK: - ENUMS

enum ToggleType : String {
    case themeSwitch = "Dark Mode"
    case temperatureScaleSwitch = "Show in Fahrenheit"
    case locationPermissionSwitch = "Location Permission"
    case none = "Not applicable"
}

enum NestedSettingType : String {
    case aboutApp = "About App"
    case contactSupport = "Contact Support"
}

// MARK: - MODALS

protocol SettingSectionProtocol {
    var headerString : String { get set}
}

struct ToggleSwitchSectionModal : SettingSectionProtocol {
    var headerString: String
    var toggelableCells : [ToggleSettingCell]
}

struct ToggleSettingCell {
    var cellLabel : ToggleType
    var switchStatus : Bool
}

struct InfoSettingSectionModal : SettingSectionProtocol {
    var headerString : String
    var moreInfoCells : [InfoSettingCell]
}

struct InfoSettingCell {
    var cellLabel : NestedSettingType
}

