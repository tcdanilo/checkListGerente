//
//  SignUpCoordinator.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 27/03/24.
//

import Foundation
import UIKit

class SignUpCoordinator {
   
    var parentCoordinator : SignInCoordinator?
    private let navigationController : UINavigationController
    
    init( navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
       
        let viewModel = SignUpViewModel()
        let signUpVC = SignUpViewController()
        
        viewModel.coordinator = self
        signUpVC.viewModel = viewModel
        
        navigationController.pushViewController(signUpVC, animated: true)
        
        
    }
    func home() {
        parentCoordinator?.home()
    }
    
    
  
    
}
