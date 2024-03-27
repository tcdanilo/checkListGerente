//
//  SignInCoordinator.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 26/03/24.
//

import Foundation
import UIKit

class SignInCoordinator {
    
    private let window : UIWindow?
    private let navigationController : UINavigationController
    
    init(window : UIWindow?){
        self.window = window
        self.navigationController = UINavigationController()
    }
    func start(){
        
        let viewModel = SignInViewModel()
        let signInVc = SignInViewController()
        viewModel.coordinator = self
        signInVc.viewModel = viewModel
        
        
        navigationController.pushViewController(signInVc, animated: true)// igual a rootviewcontroller
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()  // Deixar a tela vísivel
        
        //                 Em resumo, como deletamos o storyBoard, agora precisamos criar uma caixa vazia (tela vazia) e iremos colocar um navigationController dentro para gerenciar essa caixa
    }
    
    func signUp() {
        let signUpCoordinator = SignUpCoordinator(navigationController: navigationController)
        signUpCoordinator.parentCoordinator = self
        signUpCoordinator.start()
        
    }
    
    
}
    

