//
//  FeedCoordinator.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 24/04/24.
//

import Foundation
import UIKit

class FeedCoordinator {
   
    private let navigationController : UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func addChecklist() {
        let addChecklistCoordinator = AddChecklistCoordinator(navigationController: navigationController)
            addChecklistCoordinator.start()
        
    }
}
