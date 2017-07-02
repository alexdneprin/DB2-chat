//
//  BaseTabBarViewController.swift
//  DB2-chat
//
//  Created by Alexander Slobodjanjuk on 30.06.17.
//  Copyright © 2017 Alexander Slobodjanjuk. All rights reserved.
//

import UIKit

class BaseTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.barTintColor = UIColor.navyBlueColor()
        self.tabBar.isTranslucent = false
        
        UITabBar.appearance().tintColor = .white
        let appearance = UITabBarItem.appearance()
        let attributes = [NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 12)]
        appearance.setTitleTextAttributes(attributes, for: .normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
