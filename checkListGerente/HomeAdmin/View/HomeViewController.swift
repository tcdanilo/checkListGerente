//
//  HomeViewController.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 27/03/24.
//

import UIKit

class HomeViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let feedVC = UINavigationController(rootViewController: FeedViewController())
        let profileVC = UINavigationController(rootViewController:ProfileViewController())
        let reportVC = UINavigationController(rootViewController: ReportViewController())
       
        
        feedVC.title = "Início"
        profileVC.title = "Perfil"
        reportVC.title = "Relatórios"
        tabBar.tintColor = .systemOrange
        
        setViewControllers([feedVC,reportVC,profileVC], animated: true)
        feedVC.tabBarItem.image = UIImage(systemName: "house")
        profileVC.tabBarItem.image = UIImage(systemName: "person.circle")
        reportVC.tabBarItem.image = UIImage(systemName: "list.bullet.clipboard")
    
    }
    

    

}
