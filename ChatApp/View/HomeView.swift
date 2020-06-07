//
//  ContentView.swift
//  ChatApp
//
//  Created by Aaryan Kothari on 02/06/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @State var email : String = ""
    @State var password : String = ""
    @State var error : String = ""
    @State var scale: CGFloat = 0
    @State var blur : CGFloat = 10
    @State var angle : Double = 0
    @State var scale2 : CGFloat = 1.1
    @EnvironmentObject var session : SessionStore
    
    @State private var showingAlert = false
    @State var alertTitle : String = "Uh Oh 🙁"
    
    
    var bg1 = Color.init(red: 158/255, green: 152/255, blue: 240/255)
    var bg2 = Color.init(red: 109/255, green: 124/255, blue: 240/255)
    
    var body: some View {
        NavigationView{
            VStack {
                logo
                welcomeBack
                VStack(spacing: 18){
                    Group{
                        TextField("Email address", text: $email)
                        SecureField("Password", text: $password)
                    }
                    .modifier(CustomTextField())
                }.padding(.top,10)
                    .padding(.bottom,50)
                
                Button(action: signIn){
                    Text("SIGN IN")
                        .modifier(CustomButton())
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(alertTitle), message: Text(error), dismissButton: .default(Text("OK")))
                }
                Spacer()
                HStack{
                    Text("new here?")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(.primary)
                    NavigationLink(destination: SignupView()){
                        Text("Create an account")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(bg2)
                    }
                }
            }
            .padding(.horizontal, 32)
        }
    }
    
    func signIn(){
        if let error = errorCheck(){
            self.error = error
            self.showingAlert = true
            return
        }
        
        session.signIn(email: email, password: password) { (result, error) in
            if let error = error{
                self.error = error.authErrorValue
                self.showingAlert = true
                return
            }
            self.email = ""
            self.password = ""
        }
    }
    
    func errorCheck()->String?{
        if email.trimmingCharacters(in: .whitespaces).isEmpty || password.trimmingCharacters(in: .whitespaces).isEmpty{
            return "Please Fill in all the fields"
        }
        return nil
    }
    
    var welcomeBack : some View {
     return HStack{
            VStack(alignment: .leading){
                Text("Welcome Back!")
                    .font(.system(size: 32, weight: .heavy, design: .default))
                Text("sign in to continue")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(bg1)
            }
            Spacer()
        }
    }
    
    var logo : some View {
      return  ZStack(alignment: .bottomTrailing){
                             Image("bigchat")
                                 .scaleEffect(scale2)
                             Image("smallchat")
                                 .scaleEffect(scale)
                                 .rotationEffect(.init(degrees: angle), anchor: .center)
                                 .onAppear {
                                     let baseAnimation = Animation.spring(response: 0.5, dampingFraction: 1.1, blendDuration: 0.5)
                                     return withAnimation(baseAnimation) {
                                         self.scale = 1
                                         self.scale2 = 1
                                         self.angle = 1080
                                     }
                                 }
                             .onDisappear{
                                 self.scale = 0
                                 self.scale2 = 1.1
                                 self.angle = 0
                             }
                         }.padding(.bottom,74)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

