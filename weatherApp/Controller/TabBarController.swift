//
//  TabBarController.swift
//  weatherApp
//
//  Created by Pranav Pratap on 25/12/23.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = UIColor(white: 226.0 / 255.0, alpha: 1.0)
        self.tabBar.tintColor = .systemTeal
        self.tabBar.unselectedItemTintColor = .gray
        tabBarSetup()
        self.selectedIndex = 0
    }
    
    private func tabBarSetup(){
        
        let homeVC = setupTabBarItems(with: "Weather App", having: UIImage(systemName: "smoke.fill")!, and: HomeViewController(nibName: "HomeViewController", bundle: nil))
        let settingVC = setupTabBarItems(with: "Setting", having: UIImage(systemName: "gearshape")!, and: SettingsViewController(nibName: "SettingsViewController", bundle: nil))
        let forecastVC = setupTabBarItems(with: "Forecast", having: UIImage(systemName: "list.bullet.clipboard")!, and: ForecastViewController(nibName: "ForecastViewController", bundle: nil))
        
        self.setViewControllers([homeVC,forecastVC,settingVC], animated: true)
    }

    private func setupTabBarItems(with title : String, having image : UIImage, and vc : UIViewController) -> UIViewController {
        vc.tabBarItem.title = title
        vc.tabBarItem.image = image
        return vc
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let newTabBarHeight: CGFloat = 120.0  // Replace with your desired height
        
        var tabFrame = tabBar.frame
        tabFrame.size.height = newTabBarHeight
        tabFrame.origin.y = view.frame.size.height - newTabBarHeight
        tabBar.frame = tabFrame
    }
}
