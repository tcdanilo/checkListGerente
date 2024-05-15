//
//  HomeUserViewController.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 15/05/24.
//

import Foundation
import UIKit

class HomeUserViewController : UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let feedVC = UINavigationController(rootViewController: FeedUserViewController())
        let profileVC = UINavigationController(rootViewController:ProfileUserViewController())
       
       
        
        feedVC.title = "Início"
        profileVC.title = "Perfil"
        tabBar.tintColor = .systemOrange
        setViewControllers([feedVC,profileVC], animated: true)
        feedVC.tabBarItem.image = UIImage(systemName: "house")
        profileVC.tabBarItem.image = UIImage(systemName: "person.circle")
       
    
    }
    

    
    
}
