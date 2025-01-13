//
//  RepositoryImpl.swift
//  DesarrolloSeguroIOSApp
//
//  Created by Ismael Sabri Pérez on 26/1/24.
//

import Foundation

final class RepositoryImpl: RepositoryProtocol {

    // MARK: Properties
    var remoteDataSource: RemoteDataSourceProtocol
    
    // MARK: Init
    init(remoteDataSource: RemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    // MARK: Functions
    func login(user: String, password: String) async throws -> (String?, LoginServerError)? {
        return try await remoteDataSource.login(user: user, password: password)
    }
    
    func heroes(name: String) async throws -> [Hero]? {
        return try await remoteDataSource.heroes(name: name)
    }
}
