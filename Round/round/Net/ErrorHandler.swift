//
//  ErrorHandler.swift
//  round
//
//  Created by Denis Kotelnikov on 06.05.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import FirebaseAuth

class ErrorHandler {
    init() {
        
    }
    
    func HandleAuthError(_ error: Error?){
        guard let error = error else {
            return
        }
        
        let errorCode = AuthErrorCode(rawValue: (error as NSError).code)
        switch errorCode {
        case .invalidEmail:
            Notifications.shared.Show(text: "invalid Email", icon: Icons.emailCircle.image(), iconColor: .systemRed)
        case .emailAlreadyInUse:
            Notifications.shared.Show(text: "Email already in use", icon: Icons.editInCircle.image(), iconColor: .systemRed)
        case .wrongPassword:
            Notifications.shared.Show(text: "Wrong password", icon: Icons.password.image(), iconColor: .systemRed)
        case .tooManyRequests:
            Notifications.shared.Show(text: "Too many requests", icon: Icons.cloudError.image(), iconColor: .systemRed)
        case .userNotFound:
            Notifications.shared.Show(text: "User not found", icon: Icons.noUser.image(), iconColor: .systemRed)
        case .networkError:
            Notifications.shared.Show(text: "Network error", icon: Icons.wifiError.image(), iconColor: .systemRed)
        case .weakPassword:
            Notifications.shared.Show(text: "Weak password", icon: Icons.password.image(), iconColor: .systemRed)
        case .missingEmail:
            Notifications.shared.Show(text: "Missing email", icon: Icons.emailCircle.image(), iconColor: .systemRed)
        case .nullUser:
            Notifications.shared.Show(text: "No user", icon: Icons.noUser.image(), iconColor: .systemRed)
        default:
            Notifications.shared.Show(text: "Auth error", icon: Icons.xmarkOctagon.image(), iconColor: .systemRed)
        }
    }
}
