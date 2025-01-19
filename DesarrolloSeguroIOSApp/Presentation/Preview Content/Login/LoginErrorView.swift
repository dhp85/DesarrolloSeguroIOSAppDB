//
//  LoginErrorView.swift
//  DesarrolloSeguroIOSApp
//
//  Created by Ismael Sabri Pérez on 7/2/24.
//

import SwiftUI

struct LoginErrorView: View {
    
    var error: LoginError
    var closure: (() -> Void)?
    
    var body: some View {
        
        VStack {
            
            
            // Symbol for the error
            Image(systemName: "multiply.circle")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.top, 10)
                .foregroundColor(.white)
            Spacer()
            
            // Error message
            switch error {
            case LoginError.authenticationError:
                Text("Authentication error").foregroundColor(.white)
            case LoginError.serverError:
                Text("Server error").foregroundColor(.white)
            case LoginError.unknownError:
                Text("Unknown error").foregroundColor(.white)
            case .none:
                EmptyView()
            }
            Spacer()
            
            // Divider
            Divider()
                .overlay(.white)
            
            // Close button
            Button("Close") {
                print("Close")
                closure?()
            }.foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width/2-30, height: 40)
        }
        .frame(width: UIScreen.main.bounds.width-50, height: 150)
        .background(Color.gray)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.white, lineWidth: 5)
        )
        .cornerRadius(12)
        .clipped() // No queremos que el contenido se salga del marco
    }
}

#Preview {
    LoginErrorView(error: .unknownError)
}
