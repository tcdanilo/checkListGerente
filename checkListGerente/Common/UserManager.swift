//
//  UserManager.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 15/05/24.
//

import Foundation
import UIKit

class UserManager {
    static let shared = UserManager()
    
    private init() {}
    
    private let users = [
        User(email: "admin", password: "admin123", type: .admin),
        User(email: "usuario", password: "user123", type: .user)
    ]
    
    func loginUser(email: String, password: String) -> UserType? {
        if let user = users.first(where: { $0.email == email && $0.password == password }) {
            return user.type
        } else {
            return nil
        }
    }
}

