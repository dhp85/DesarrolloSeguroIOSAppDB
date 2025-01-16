//
//  URLRequestHelperImpl.swift
//  DesarrolloSeguroIOSApp
//
//  Created by Ismael Sabri Pérez on 23/1/24.
//

import Foundation

final class URLRequestHelperImpl: URLRequestHelperProtocol {
    
    
    // MARK: Properties
    var baseURL: String = "https://dragonball.keepcoding.education/"
    var endpoints: Endpoints = Endpoints()
    
    // MARK: Functions
    func login(user: String, password: String) -> URLRequest? {
        // Basic authentication -> user:password encoded in base64
        let loginString = String(format: "%@:%@", user, password) // user:password
        let loginData = loginString.data(using: .utf8) // user:password string as data
        guard let base64loginString = loginData?.base64EncodedString() else {
            print("Error while encoding user \(user) and password \(password) into base64 string")
            return nil
        }
        
        // Get the URL
        guard let url = URL(string: "\(baseURL)\(endpoints.login)") else {
            print("Error while creating URL from \(baseURL)\(endpoints.login)")
            return nil
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64loginString)", forHTTPHeaderField: "Authorization")
        
        // Return the request
        return request
    }
    
    func heroes(name: String) -> URLRequest? {
        // Get URL
        guard let url = URL(string: "\(baseURL)\(endpoints.heroes)") else {
            print("Error while creating URL from \(baseURL)\(endpoints.heroes)")
            return nil
        }
        
        // Get token
        guard let token = KeychainHelper.keychain.readToken() else {
            print("Error while retrieving the token in the creation of the heroes list request")
            return nil
        }
        
        // URL request
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Get body
        struct Body: Encodable {
            let name: String
        }
        let body = Body(name: name)
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        return urlRequest
    }
}
