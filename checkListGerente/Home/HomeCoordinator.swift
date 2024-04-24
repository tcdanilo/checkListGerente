//
//  HomeCoordinator.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 27/03/24.
//

import Foundation
import UIKit

class HomeCoordinator {
   
    private let window : UIWindow?
    
    init(window : UIWindow?) {
        
        self.window = window
        
    }
    
    func start(){
        
        let homeVC = HomeViewController()
        window?.rootViewController = homeVC
      
    }
    
    
}
