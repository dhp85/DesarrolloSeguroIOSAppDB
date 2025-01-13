//
//  RemoteDataSourceProtocol.swift
//  DesarrolloSeguroIOSApp
//
//  Created by Ismael Sabri Pérez on 23/1/24.
//

import Foundation

protocol RemoteDataSourceProtocol {
    
    // MARK: Properties
    var urlRequestHelper: URLRequestHelperProtocol { get }
    
    // MARK: Functions
    func login(user: String, password: String) async throws -> (String?, LoginServerError)?
    func heroes(name: String) async throws -> [Hero]?
}

enum LoginServerError {
    case authenticationError
    case serverError
    case unknownError
    case loginSuccess
}
