//
//  SSLPinningSecureURLSession.swift
//  DesarrolloSeguroIOSApp
//
//  Created by Diego Herreros Parron on 10/1/25.
//

import Foundation

class SSLPinningSecureURLSession {
    
    // MARK: - Variables
    let session: URLSession
    
    // MARK: - Initializers
    init() {
        self.session = URLSession(
            configuration: .ephemeral,
            delegate: SSLPinningDelegate(),
            delegateQueue: nil
        )
    }
}

//MARK: - URLSession extension: shared
extension URLSession {
    static var shared: URLSession {
        return SSLPinningSecureURLSession().session
    }
}


