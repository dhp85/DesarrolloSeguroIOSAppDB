//
//  HomeView.swift
//  DesarrolloSeguroIOSApp
//
//  Created by Ismael Sabri Pérez on 19/2/24.
//

import SwiftUI

struct HomeView: View {
        
    // MARK: - Properties
    @ObservedObject var homeViewModel: HomeViewModel
    var heroes: [Hero] = []
    
    // MARK: - Functions
    init(homeViewModel: HomeViewModel, heroes: [Hero]) {
        self.homeViewModel = homeViewModel
        for i in 1...10 {
            let hero = Hero(
                photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300",
                id: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94\(i)",
                name: "Goku\(i)",
                description: "Sobran las presentaciones cuando se habla de Goku. El Saiyan fue enviado al planeta Tierra, pero hay dos versiones sobre el origen del personaje."
            )
            self.heroes.append(hero)
        }
    }

    var body: some View {
        NavigationView {
            List(homeViewModel.heroes) { hero in
                HeroCellView(hero: hero)
            }
            .navigationTitle("Heroes")
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    HomeView(homeViewModel: HomeViewModel(repository: RepositoryImpl(remoteDataSource: RemoteDataSourceImpl())),
             heroes: [])
}

