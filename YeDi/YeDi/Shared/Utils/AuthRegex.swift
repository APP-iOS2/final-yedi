//
//  AuthRegex.swift
//  YeDi
//
//  Created by yunjikim on 2023/10/16.
//

import Foundation

final class AuthRegex {
    static let shared = AuthRegex()
    
    func checkEmailValid(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func checkPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*[0-9]).{6,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    func checkPhoneNumberValid(_ phoneNumber: String) -> Bool {
        let regex = "^01([0|1|6|7|8|9]?) ?([0-9]{4}) ?([0-9]{4})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: phoneNumber)
    }
}
