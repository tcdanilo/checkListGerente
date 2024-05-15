//
//  HomeUserCoordinator.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 15/05/24.
//

import Foundation
import UIKit

class HomeUserCoordinator {
    
    
    private let window : UIWindow?
    
    init(window : UIWindow?) {
        
        self.window = window
        
    }
    
    func start(){
        
        let homeVC = HomeUserViewController()
        window?.rootViewController = homeVC
      
    }
    
}
