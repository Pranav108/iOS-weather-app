//
//  TabBarController.swift
//  weatherApp
//
//  Created by Pranav Pratap on 25/07/23.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(switchTabScreen(notification:)), name: Notification.Name("changeIndex"), object: nil)
    }
    
    @objc func switchTabScreen(notification : Notification){
        let index : Int = notification.userInfo?["index"] as? Int ?? 1
        self.selectedIndex = index
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
