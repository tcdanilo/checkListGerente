//
//  SignUpViewModel.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 27/03/24.
//

import Foundation
import UIKit

class SignUpViewModel {
    
    var coordinator : SignUpCoordinator?
    
    
    func goToHome() {
        coordinator?.home()
    }
    
    
}
