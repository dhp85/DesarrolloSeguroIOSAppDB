//
//  RemoteDataSourceImpl.swift
//  DesarrolloSeguroIOSApp
//
//  Created by Ismael Sabri Pérez on 23/1/24.
//

import Foundation
import os

final class RemoteDataSourceImpl: RemoteDataSourceProtocol {
    
    var urlRequestHelper: URLRequestHelperProtocol = URLRequestHelperImpl()
    
    func login(user: String, password: String) async throws -> (String?, LoginServerError)? {
        
        // Get the URLRequest
        guard let URLRequest = urlRequestHelper.login(user: user, password: password) else {
            print("Error while creating the URLRequest for the login of \(user)")
            return nil
        }
        
        // Get the data
        let (data, response) = try await URLSession.shared.data(for: URLRequest)
        
        // Transform the response into a HTTPURLResponse to access the status code
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Error while casting the response to HTTPURLResponse")
            return nil
        }
        let statusCode = httpResponse.statusCode
        
        // Check the status code
        switch statusCode {
            
        // If the status code is 200, return (token, loginSuccess)
        case 200:
            // Convert the data into a String and check if it is empty
            guard let token = String(data: data, encoding: .utf8), token != "" else {
                print("Error while converting the data of the token into a String or the token is empty")
                return nil
            }
            print("Token: \(token)")
            AppLogger.debug(token)
            Logger.remoteDataSource.error("Login efectuado con el token \(token, privacy: .private)")
            return (token, .loginSuccess)
            
        // If the status code is 401, return (nil, authenticationError)
        case 401:
            print("Error while authenticating the user")
            return (nil, .authenticationError)
            
        // If the status code is 500, return (nil, serverError)
        case 500:
            print("Error while authenticating the user")
            return (nil, .serverError)
            
        // If the status code is unknown, return (nil, unknownError)
        default:
            print("Unknown error")
            return (nil, .unknownError)
        }
    }
    
    func heroes(name: String) async throws -> [Hero]? {
        // Obtenemos la request
        guard let URLRequest = urlRequestHelper.heroes(name: "") else {
            print("Error while creating the URLRequest for the heroes")
            return nil
        }
        
        // Get data and response from the server
        let (data, response) = try await URLSession.shared.data(for: URLRequest)
        
        // Transform the response into a HTTPURLResponse to access the status code
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Error while casting the response to HTTPURLResponse")
            return nil
        }
        let statusCode = httpResponse.statusCode
        
        // Check the status code
        switch statusCode {
            
        // If the status code is 200, return heroes, print heroes fetching success
        case 200:
            // Convert the data into a array of heros and return it
            guard let heroes = try? JSONDecoder().decode([Hero].self, from: data) else {
                print("Error: error while decoding the response from the server")
                return nil
            }
            print("Heroes successfully fetched from server:")
            return heroes
        // If the status code is 400, return nil, print bad request error
        case 400:
            print("Bad request error while fetching heroes from the API")
            return nil
        // If the status code is 401, return nil, print auth error
        case 401:
            print("Authentication error while fetching heroes from the API")
            return nil
        // If the status code is 500, return nil print server error
        case 500:
            print("Server error while fetching heroes from the API")
            return nil
        // If the status code is unknown, return (nil, unknownError)
        default:
            print("Unknown error while fetching heroes from the API")
            return nil
        }
    }
    
}
