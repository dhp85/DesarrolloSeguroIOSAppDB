//
//  Hero.swift
//  DesarrolloSeguroIOSApp
//
//  Created by Ismael Sabri Pérez on 16/2/24.
//

import Foundation

struct Hero: Identifiable, Decodable {
    let photo: String
    let id: String
    let name: String
    let description: String
}
