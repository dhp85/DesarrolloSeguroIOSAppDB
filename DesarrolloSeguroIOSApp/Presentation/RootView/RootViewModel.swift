//
//  RootViewModel.swift
//  DesarrolloSeguroIOSApp
//
//  Created by Ismael Sabri Pérez on 13/2/24.
//

import Foundation

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


    // MARK: Init
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
        
    // MARK: Functions
    func onLogin(user: String, password: String, completion: ((LoginError) -> Void)?) async {
        
        // Si el usuario está en user defaults, es que ya ha hecho login antes
        if UserDefaultsHelper.defaults.readUser() != nil {
            completion?(.none)
            return
        }
        
        do {
            if let (token, loginError) = try await repository.login(user: user, password: password) {
                switch loginError {
                case .authenticationError:
                    completion?(.authenticationError)
                case .serverError:
                    completion?(.serverError)
                case .unknownError:
                    completion?(.unknownError)
                case .loginSuccess:
                    print("Token: \(String(describing: token))")
                    UserDefaultsHelper.defaults.save(user: user)
                    UserDefaultsHelper.defaults.save(token: token!) // Force unwrap porque se ha comprobado que no es nil en el remote
                    completion?(.none)
                }
            }
        } catch {
            print("Error while login in onLogin catch block")
            completion?(.unknownError)
        }
    }
}
