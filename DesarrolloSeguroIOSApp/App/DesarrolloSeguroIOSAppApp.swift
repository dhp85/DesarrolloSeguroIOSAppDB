//
//  DesarrolloSeguroIOSAppApp.swift
//  DesarrolloSeguroIOSApp
//
//  Created by Ismael Sabri Pérez on 25/10/23.
//

import SwiftUI

@main
struct DesarrolloSeguroIOSAppApp: App {
    var body: some Scene {
        WindowGroup {
            let remoteDataSource = RemoteDataSourceImpl()
            let repository = RepositoryImpl(remoteDataSource: remoteDataSource)
            RootView()
                .environmentObject(RootViewModel(repository: repository))
        }
    }
}
