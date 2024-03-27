//
//  SignInViewModel.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 26/03/24.
//

import Foundation
import UIKit

class SignInViewModel {
    
    var coordinator : SignInCoordinator?
    
    func send() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            
        }
        
    }
   
    func goToSignUp() {
        coordinator?.signUp()
    }
}
