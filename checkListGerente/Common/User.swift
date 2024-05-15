//
//  User.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 15/05/24.
//

import Foundation
import UIKit

enum UserType {
    case admin
    case user
}

class User {
    let email: String
    let password: String
    let type: UserType
        
        init(email: String, password: String, type: UserType) {
            self.email = email
            self.password = password
            self.type = type
        }
}
