//
//  KeyChainHelpers.swift
//  DesarrolloSeguroIOSApp
//
//  Created by Diego Herreros Parron on 16/1/25.
//

import Foundation

final class KeychainHelper {
    
    // MARK: - Properties
    // Singleton -> para llamar a las funciones de keychain, hay que utilizar el Keychain.keychain
    static let keychain = KeychainHelper()
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Functions
    func saveUser(user: String) {
        guard let userData = user.data(using: .utf8) else {
            print("Error: could not convert user to data")
            return
        }
        save(data: userData, account: "user")
    }
    func readUser() -> String? {
        guard let userData = read(account: "user") else {
            print("Error: could not read user from keychain")
            return nil
        }
        return String(data: userData, encoding: .utf8)
    }
    func deleteUser() {
        delete(account: "user")
    }
    
    func saveToken(token: String) {
        // Get token as data
        guard let tokenData = token.data(using: .utf8) else {
            print("Error: could not convert token to data")
            return
        }
        // Get the current date
        let timestamp = Date().timeIntervalSinceReferenceDate
        let timestampData = withUnsafeBytes(of: timestamp) { Data($0) }
        // Save token along with the timestamp
        save(data: tokenData, account: "token")
        save(data: timestampData, account: "tokenDate")
        // Log con prints
        print("Token saved with date: \(Date())")
    }
    func readToken() -> String? {
        // Read the token from keychain
        guard let tokenData = read(account: "token") else {
            print("Error: could not read token from keychain")
            return nil
        }
        // Read the token date from keychain
        guard let tokenDate = read(account: "tokenDate") else {
            print("Error: could not read token date from keychain")
            return nil
        }
        // Check if the token is expired
        let twoWeeksInSeconds: Double = 10
        let currentDate = Date().timeIntervalSinceReferenceDate
        let timestamp = tokenDate.withUnsafeBytes { $0.load(as: Double.self) }
        if currentDate - timestamp > twoWeeksInSeconds {
            print("Error: the token has expired, deleting the token")
            deleteToken()
            return nil
        }
        // Log con prints
        print("Token in keychain with date \(Date(timeIntervalSinceReferenceDate: timestamp)) has not expired yet")
        
        return String(data: tokenData, encoding: .utf8)
    }
    func deleteToken() {
        delete(account: "token")
        delete(account: "tokenDate")
        // Log con prints
        print("Token deleted")
    }
    
    // MARK: - Generic functions
    private func save(data: Data, service: String = "KEEPCODING", account: String) {
        // Petición a keychain para guardar datos
        let query = [
            kSecValueData: data, // los datos que queremos guardar
            kSecClass: kSecClassGenericPassword, // Tipo de encriptación que queremos
            kSecAttrService: service, // Compartimento dentro de keychain donde queremos que se guarde la info
            kSecAttrAccount: account // Clave a la que se asocia la data
        ] as CFDictionary
        
        // Guardar data en keychain.
        let status = SecItemAdd(query, nil)
        
        // En este punto el item está guardado o hay un error
        // Si se guarda y devuelve el error de que ya existe el elemento entonces:
        if status == errSecDuplicateItem {
            // Actualizar datos para el service y el account existentes
            // Query para actualizar datos
            let queryToUpdate = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: account
            ] as CFDictionary
            // Petición con los atributos que queremos que se actualicen
            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            // Actualizamos el data
            SecItemUpdate(queryToUpdate, attributesToUpdate)
            
        } else if status != errSecSuccess {
            print("Error: error adding item")
        }
    }
    
    private func read(service: String = "KEEPCODING", account: String) -> Data? {
        // Petición para leer un data asociado a un account
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true
        ] as CFDictionary
        
        // Crear una variable para almacenar el resultado de la búsqueda
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        // Devolver el resultado después de convertirlo a Data
        return result as? Data
    }
    
    private func delete(service: String = "KEEPCODING", account: String) {
        // Petición para borrar el data que está asociado al account
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as CFDictionary
        // Borras el data
        SecItemDelete(query)
    }
}

// MARK: - Password functions
extension KeychainHelper {
    func savePasswordWithAuthentication(password: String, service: String = "KEEPCODING", account: String = "password", authentication: Authentication) {
        guard let passwordData = password.data(using: .utf8) else {
            print("Error: could not convert password to data")
            return
        }
        // Obtener un control de acceso mediante biometría o passcode
        guard let accessControl = authentication.getAccessControl() else {
            print("Error: could not get access control")
            return
        }
        // Petición a keychain para guardar datos
        let query = [
            kSecValueData: passwordData, // los datos que queremos guardar
            kSecClass: kSecClassGenericPassword, // Tipo de encriptación que queremos
            kSecAttrService: service, // Compartimento dentro de keychain donde queremos que se guarde la info
            kSecAttrAccessControl: accessControl, // Control de acceso a los datos
            kSecAttrAccount: account // Clave a la que se asocia la data
        ] as CFDictionary
        // Guardar data en keychain.
        SecItemAdd(query, nil)
    }
    func readPasswordWithAuthentication(service: String = "KEEPCODING", account: String = "password", authentication: Authentication) -> String? {
        // Get context from authentication
        let context = authentication.context
        // Dar la razón de desbloqueo
        context.localizedReason = "Authenticate to read password"
        // Mensaje de desbloqueo por código
        context.localizedFallbackTitle = "Use Passcode"
        // Set the maximum biometric authentication time
        context.touchIDAuthenticationAllowableReuseDuration = 10
        
        // Crear la petición para lectura
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true,
            kSecUseAuthenticationContext: context
        ] as CFDictionary
        
        // Create a variable to store the result of the search
        var result: AnyObject?
        
        // Read the data from the keychain
        let status = SecItemCopyMatching(query, &result)
        
        guard status == errSecSuccess, let resultData = result as? Data else {
            print("Error: could not retrieve data from keychain")
            return nil
        }
        
        guard let password = String(data: resultData, encoding: .utf8) else {
            print("Error: could not convert data to string")
            return nil
        }
        
        return password
    }
    func deletePassword() {
        delete(account: "password")
    }
}
