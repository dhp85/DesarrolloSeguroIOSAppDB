//
//  RootView.swift
//  DesarrolloSeguroIOSApp
//
//  Created by Ismael Sabri Pérez on 13/2/24.
//

import SwiftUI

struct RootView: View {

    // MARK: - Properties
    @EnvironmentObject var rootViewModel: RootViewModel

    var body: some View {
        switch (rootViewModel.status) {
        case Status.none:
            LoginView()
            
        case Status.loading:
            Text("Loading")
            
        case Status.loaded:
            TabView {
                HomeView(homeViewModel: HomeViewModel(repository: rootViewModel.repository),
                         heroes: [])
                    .tabItem {
                        Image("tab1")
                        Text("First")
                    }
                
                Button("Logout") {
                    KeychainHelper.keychain.deleteUser()
                    KeychainHelper.keychain.deleteToken()
                    rootViewModel.status = .none
                }
                    .tabItem {
                        Image("tab2")
                        Text("Second")
                    }
            }
        }
    }
}

#Preview {
    RootView()
}
