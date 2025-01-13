//
//  RepositoryProtocol.swift
//  DesarrolloSeguroIOSApp
//
//  Created by Ismael Sabri Pérez on 26/1/24.
//

import Foundation

protocol RepositoryProtocol {
    
    // MARK: Properties
    var remoteDataSource: RemoteDataSourceProtocol { get }
    
    // MARK: Functions
    func login(user: String, password: String) async throws -> (String?, LoginServerError)?
    func heroes(name: String) async throws -> [Hero]?
}
