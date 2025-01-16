//
//  KeyChainHelpers.swift
//  DesarrolloSeguroIOSApp
//
//  Created by Diego Herreros Parron on 16/1/25.
//

import Foundation


class KeychainHelper {
    
    static let keychain = KeychainHelper()
    
    private init() {}
    // Funciones específicas para cada uno de los usos
    // Funciones para manejar el usuario
    func save(user: String) {
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
    
    // Funciones para manejar el token
    func save(token: String) {
        guard let tokenData = token.data(using: .utf8) else {
              print("Error: could not convert token to data")
              return
          }
        save(data: tokenData, account: "token")
    }
    func readToken() -> String? {
        guard let tokenData = read(account: "token") else {
            print("Error: could not read token from keychain")
            return nil
        }
        return String(data: tokenData, encoding: .utf8)
    }
    func deleteToken() {
        delete(account: "token")
    }
    
    // Funciones genéricas privadas para
    
    // Guardar: información, service, account
    private func save(data: Data, service: String = "KEEPCODING", account: String) {
        // Petición a keychain para guardar datos
        let query = [
            kSecValueData: data, // los datos que queremos guardar
            kSecClass: kSecClassGenericPassword, // Tipo de encriptación que queremos
            kSecAttrService: service, // Compartimento dentro de keychain donde queremos que se guarde la info
            kSecAttrAccount: account // Clave a la que se asocia la data
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil) // 0 si todo ha ido bien -> si hay error tiene código de error
        
        if status == errSecSuccess {
            // Guardamos en keychain
            print("Item añadido")

        } else if status == errSecDuplicateItem {
            // Update
            // Creamos el diccionario de la actualización
            let queryToUpdate = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: account
            ] as CFDictionary
            
            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            print("Item actualizado")

            SecItemUpdate(queryToUpdate, attributesToUpdate)
        } else {
            print("Error while adding item to keychain")
        }
    }
    
    // Leer
    private func read(service: String = "KEEPCODING", account: String) -> Data? {
        // Query para leer la información de la clave account en service
        let query = [
            kSecClass: kSecClassGenericPassword, // Tipo de encriptación que queremos
            kSecAttrService: service, // Compartimento dentro de keychain donde queremos que se guarde la info
            kSecAttrAccount: account, // Clave a la que se asocia la data
            kSecReturnData: true // IMPORTANTISIMO: Para que los datos que queremos leer se puedan almacenar en el segundo parámetro de la función SecItemCopyMatching
        ] as CFDictionary
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        print("Item leído")
        return result as? Data
    }
    
    // Borrar
    private func delete(service: String = "KEEPCODING", account: String) {
        // Query para leer la información de la clave account en service
        let query = [
            kSecClass: kSecClassGenericPassword, // Tipo de encriptación que queremos
            kSecAttrService: service, // Compartimento dentro de keychain donde queremos que se guarde la info
            kSecAttrAccount: account, // Clave a la que se asocia la data
        ] as CFDictionary
        print("Item borrado")
        SecItemDelete(query)
    }
}
