//
//  ListView.swift
//  SongRight
//
//  Created by Caitlin Price on 4/24/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    enum Field {
        case email, password
    }
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonsDisabled = true
    @State private var presentSheet = false
    @FocusState private var focusField: Field?
    
    var body: some View {
        NavigationStack {
            Image("login")
                .resizable()
                .scaledToFit()
            
            Text("Welcome to songRight")
                .font(Font.custom("TAN - SONGBIRD", size: 15))
                .foregroundColor(Color("Gray"))
                .padding()
            
            Group {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .focused($focusField, equals: .email)
                    .onSubmit {
                        focusField = .password
                    }
                    .onChange(of: email) { _ in
                        enableButtons() //each time email changes, checked by enableButtons function
                    }
                SecureField("Password", text: $password)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.done)
                    .focused($focusField, equals: .password)
                    .onSubmit {
                        focusField = nil
                    }
                    .onChange(of: password) { _ in
                        enableButtons()
                    }
            }
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: 2)
            }
            .padding(.horizontal)
            HStack {
                Button {
                    register()
                } label: {
                    Text("Sign Up")
                }
                .padding(.trailing)
                
                Button {
                    login()
                } label: {
                    Text("Log In")
                }
                .padding(.leading)
            }
            .disabled(buttonsDisabled)
            .buttonStyle(.borderedProminent)
            .tint(.accentColor)
            .padding(.top)
            .navigationBarTitleDisplayMode(.inline)
            .font(Font.custom("TAN - SONGBIRD", size: 12))
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
        .onAppear {
            //if logged in when app runs, navigate to list screen
            if Auth.auth().currentUser != nil {
               print("🪵Login Successful!")
                presentSheet = true
            }
        }
        .fullScreenCover(isPresented: $presentSheet) {
            ListView()
        }
    }
    func enableButtons () {
        let emailIsGood = email.count >= 6 && email.contains("@")
        let passwordIsGood = password.count >= 6
        buttonsDisabled = !(emailIsGood && passwordIsGood)
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("LOGIN ERROR: \(error.localizedDescription)")
                alertMessage = "LOGIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("Registration Success!😎")
             presentSheet = true
            }
        }
    }
    func login () {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("LOGIN ERROR: \(error.localizedDescription)")
                alertMessage = "LOGIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("🪵Login Successful!")
                presentSheet = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoginView()
                .environmentObject(SongsViewModel())
                .environmentObject(QuoteViewModel())
        }
    }
}
