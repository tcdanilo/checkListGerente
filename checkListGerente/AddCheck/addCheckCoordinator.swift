//
//  addCheckCoordinator.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 23/04/24.
//

import Foundation
import UIKit

 private let window : UIWindow?
 
 init(window : UIWindow?) {
     
     self.window = window
     
 }
 
 func start(){
     
     let addVC = HomeViewController()
     window?.rootViewController = addVC
   
 }
