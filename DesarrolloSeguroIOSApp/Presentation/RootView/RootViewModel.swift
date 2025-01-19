//
//  RootViewModel.swift
//  DesarrolloSeguroIOSApp
//
//  Created by Ismael Sabri Pérez on 13/2/24.
//

import Foundation
import LocalAuthentication

enum Status {
    case none, loading, loaded
}

enum LoginError {
    case authenticationError
    case serverError
    case unknownError
    case none
}

final class RootViewModel: ObservableObject {
    
    // MARK: Properties
    let repository: RepositoryProtocol
    @Published var status = Status.none
    let authentication: Authentication


    // MARK: Init
    init(repository: RepositoryProtocol) {
        self.repository = repository
        self.authentication = Authentication(context: LAContext())
    }
        
    // MARK: Functions
    func onLogin(user: String, password: String, completion: ((LoginError) -> Void)?) async {
        
        // Si el token está en keychain, es que ya ha hecho login antes
        if KeychainHelper.keychain.readToken() != nil {
            completion?(.none)
        } else {
            Task {
                do {
                    if let (token, loginError) = try await self.repository.login(user: user, password: password) {
                        switch loginError {
                        case .authenticationError:
                            completion?(.authenticationError)
                        case .serverError:
                            completion?(.serverError)
                        case .unknownError:
                            completion?(.unknownError)
                        case .loginSuccess:
                            print("Token: \(String(describing: token))")
                            KeychainHelper.keychain.saveUser(user: user)
                            KeychainHelper.keychain.saveToken(token: token!) // Force unwrap porque se ha comprobado que no es nil en el remote
                            completion?(.none)
                            KeychainHelper.keychain.savePasswordWithAuthentication(password: password, authentication: self.authentication)
                            completion?(.none)
                        }
                    }
                } catch {
                    print("Error while login in onLogin catch block")
                    completion?(.unknownError)
                }
            }
        }
    }
    
    func onPasswordFieldClick(withUser user: String, completion: @escaping (String) -> Void) {
        // Comprobar si existe usuario en el keychain
        guard KeychainHelper.keychain.readUser() == user else {
            print("The user for which the password request was made is not in the keychain")
            completion("")
            return
        }
        // Autenticación biométrica para autocompletado de contraseña
        guard let password = KeychainHelper.keychain.readPasswordWithAuthentication(authentication: self.authentication) else {
            print("Error: could not read password from keychain")
            completion("")
            return
        }
        completion(password)
    }
}
