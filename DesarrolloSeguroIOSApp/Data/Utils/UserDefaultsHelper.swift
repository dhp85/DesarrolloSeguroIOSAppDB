//
//  UserDefaultsHelper.swift
//  DesarrolloSeguroIOSApp
//
//  Created by Ismael Sabri Pérez on 14/2/24.
//

import Foundation

final class UserDefaultsHelper {
    
    // MARK: - Properties
    static let defaults = UserDefaultsHelper()
    
    // MARK: - Functions
    private init() {}
    
    func save(user: String) {
        UserDefaults.standard.setValue(user, forKey: "user")
    }
    func readUser() -> String? {
        return UserDefaults.standard.string(forKey: "user")
    }
    func deleteUser() {
        UserDefaults.standard.removeObject(forKey: "user")
    }
    
    func save(token: String) {
        UserDefaults.standard.setValue(token, forKey: "token")
    }
    func readToken() -> String? {
        return UserDefaults.standard.string(forKey: "token")
    }
    func deleteToken() {
        UserDefaults.standard.removeObject(forKey: "token")
    }
    
}
