//
//  AddChecklistCoordinator.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 23/04/24.
//

import Foundation
import UIKit

class AddChecklistCoordinator {
   
    private let navigationController : UINavigationController
    
    init( navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
       
        let viewModel = AddChecklistViewModel()
        let addChecklistVC = AddChecklistViewController()
        
        viewModel.coordinator = self
        addChecklistVC.viewModel = viewModel
        
        navigationController.pushViewController(addChecklistVC, animated: true)
        
        
    }
    
    
    
    
}
