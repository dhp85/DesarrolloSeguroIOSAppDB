//
//  URLRequestHelperProtocol.swift
//  DesarrolloSeguroIOSApp
//
//  Created by Ismael Sabri Pérez on 23/1/24.
//

import Foundation

protocol URLRequestHelperProtocol {
    
    // MARK: Properties
    var baseURL: String { get }
    var endpoints: Endpoints { get }

    // MARK: Functions
    func login(user: String, password: String) -> URLRequest?
    func heroes(name: String) -> URLRequest?
}
