//
//  FeedViewModel.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 24/04/24.
//

import Foundation
import UIKit

class FeedViewModel{
    
    var coordinator : FeedCoordinator?
    
    func goToAddChecklist() {
        coordinator?.addChecklist()
    }
    
    
}
