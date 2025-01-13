//
//  HeroCellView.swift
//  DesarrolloSeguroIOSApp
//
//  Created by Ismael Sabri Pérez on 16/2/24.
//

import SwiftUI

struct HeroCellView: View {
    
    var hero: Hero
    
    init(hero: Hero) {
        self.hero = hero
    }
    
    var body: some View {
        HStack {
            // Imagen
            AsyncImage(url: URL(string: hero.photo),
                       content: { image in
                           image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 130, height: 73)
                       },
                       placeholder: {
                           ProgressView()
                       })
            // VStack con nombre y descripción
            // Nombre y descripción alineados al principio
            VStack (alignment: .leading, content: {
                Text(hero.name)
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
                Text(hero.description)
                    .font(.system(size: 12))
                    .lineLimit(3)
            })
        }
    }
}

#Preview {
    HeroCellView(hero:
        Hero(
            photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300",
            id: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94",
            name: "Goku",
            description: "Sobran las presentaciones cuando se habla de Goku. El Saiyan fue enviado al planeta Tierra, pero hay dos versiones sobre el origen del personaje. Según una publicación especial, cuando Goku nació midieron su poder y apenas llegaba a dos unidades, siendo el Saiyan más débil. Aun así se pensaba que le bastaría para conquistar el planeta. Sin embargo, la versión más popular es que Freezer era una amenaza para su planeta natal y antes de que fuera destruido, se envió a Goku en una incubadora para salvarle."
        )
    )
}
