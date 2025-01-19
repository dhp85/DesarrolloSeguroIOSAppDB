//
//  LoginView.swift
//  DesarrolloSeguroIOSApp
//
//  Created by Ismael Sabri Pérez on 23/11/23.
//

import SwiftUI

enum PopUp {
    case none
    case authenticationPopUp
    case serverErrorPopUp
    case unknownErrorPopUp
}

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State var popUp: PopUp = .none
    @EnvironmentObject var rootViewModel: RootViewModel
    
    var body: some View {
        ZStack {
            Image(decorative: "fondo2")
                .resizable()
                .opacity(1)
            
            // MARK: - User mail, password and login button
            VStack {
                
                VStack {
                    TextField("User mail", text: self.$email)
                        .padding(10.5) // Padding
                        .background(Color.white) // Background color
                        .foregroundColor(Color.blue) // Text color
                        .multilineTextAlignment(.center) // Center text
                        .cornerRadius(8.0) // Circular alike shape
                        .shadow(radius: 10.0, x: 20, y: 10) // Projects shadow on the background image
                        .textInputAutocapitalization(.never) // First letter of the text is not capitalized by default
                        .autocorrectionDisabled()
                    

                    Spacer() // Spacing between the text fields
                
                    SecureField("Password", text: self.$password)
                        .padding(10.5) // Padding
                        .background(Color.white) // Background color
                        .foregroundColor(Color.blue) // Text color
                        .multilineTextAlignment(.center) // Center text
                        .cornerRadius(8.0) // Circular alike shape
                        .shadow(radius: 10.0, x: 20, y: 10) // Projects shadow on the background image
                        .textInputAutocapitalization(.never) // First letter of the text is not capitalized by default
                        .autocorrectionDisabled()
                }
                .frame(width: 272,height: 112)

                Spacer() // Spacing between the text fields and the login button
                
                Button {
                    print("Login")
                    Task {
                        await rootViewModel.onLogin(user: "bejl@keepcoding.es", password: "123456") {
                            loginError in
                            DispatchQueue.main.async {
                                switch loginError {
                                case .authenticationError:
                                    print("Auth error popup")
                                    popUp = .authenticationPopUp
                                case .serverError:
                                    print("Server error pop up")
                                    popUp = .serverErrorPopUp
                                case .unknownError:
                                    print("Unknown error pop up")
                                    popUp = .unknownErrorPopUp
                                case .none:
                                    print("Navigating to home")
                                    rootViewModel.status = .loaded
                                }
                            }
                        }
                    }
                } label: {
                    Text("Login")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 138, height: 40)
                        .background(Color(uiColor: UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0))) // Color background
                        .cornerRadius(8.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                }
            }
            .frame(width: 272, height: 216)
            
            // MARK: - Pop up error
            if(popUp != .none) {
                switch popUp {
                case .authenticationPopUp:
                    LoginErrorView(error: .authenticationError) {
                        popUp = .none
                    }
                case .serverErrorPopUp:
                    LoginErrorView(error: .serverError) {
                        popUp = .none
                    }
                case .unknownErrorPopUp:
                    LoginErrorView(error: .unknownError) {
                        popUp = .none
                    }
                default:
                    EmptyView()
                }
            }

        }
        .ignoresSafeArea()
    }
}


#Preview {
    LoginView()
}
