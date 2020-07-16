//
//  UTabBarController.swift
//  ficker
//
//  Created by Chenpoting on 2020/7/15.
//  Copyright © 2020 Chenpoting. All rights reserved.
//

import UIKit

class UTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc1 = SearchViewController()
        let vc2 = FavoriteViewController()
        vc1.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.featured, tag: 1)
        vc2.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.favorites, tag: 2)
        viewControllers = [UNavigationController(rootViewController: vc1),
                           UNavigationController(rootViewController: vc2)]
    }

}
