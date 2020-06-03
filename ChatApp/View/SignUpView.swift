//
//  SignUpView.swift
//  ChatApp
//
//  Created by Aaryan Kothari on 02/06/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import SwiftUI

struct SignupView: View {

    @EnvironmentObject var session : SessionStore

    @State private var name : String = ""
    @State private var email : String = ""
    @State private var password : String = ""
    @State private var confirmpassword : String = ""
    @State var error : String = ""
    @State private var showingImagePicker = false
    @State private var inputImage : UIImage?
    @State var profileImage : Image?
    @State private var showingAlert = false
    @State var alertTitle : String = "Uh Oh 🙁"
    @State private var showingActionSheet = false
    @State private var sourceType : UIImagePickerController.SourceType = .photoLibrary


    @ObservedObject private var keyboard = KeyboardInfo.shared

    var body: some View {
        VStack(spacing: 0){
            ZStack{
                if profileImage != nil {
                    profileImage!
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: self.keyboard.keyboardIsUp ? 50 : 88, height: self.keyboard.keyboardIsUp ? 50 : 88)
                        .padding(.top, self.keyboard.keyboardIsUp ? 0 : 20)
                        .padding(.bottom,20)
                        .onTapGesture {
                              self.showingActionSheet = true
                    }
                }else {
                    Image("default")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: self.keyboard.keyboardIsUp ? 50 : 88, height: self.keyboard.keyboardIsUp ? 50 : 88)
                        .padding(.top, self.keyboard.keyboardIsUp ? 0 : 20)
                        .padding(.bottom,20)
                         .onTapGesture {
                                  self.showingActionSheet = true
                        }
                }
            }

            VStack(spacing:20){
                Group{
                TextField("Full Name", text: $name)
                TextField("Email ID", text: $email)
                TextField("Password", text: $password)
                TextField("Confirm Password", text: $confirmpassword)

                }.modifier(CustomTextField())
                
                Button(action: signUp){
                    Text("SIGN UP")
                    .modifier(CustomButton())
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(alertTitle), message: Text(error), dismissButton: .default(Text("OK")))
                }
            }
            .padding(.horizontal,40)
            Spacer()
        }.navigationBarTitle(Text("Sign Up"), displayMode: .large)
            .sheet(isPresented: $showingImagePicker,onDismiss: loadImage){
                ImagePicker(image: self.$inputImage, source: self.sourceType)
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text(""), buttons: [
                .default(Text("Choose Photo")) {
                    self.sourceType = .photoLibrary
                    self.showingImagePicker = true
                },
                .default(Text("Take Photo")) {
                    self.sourceType = .camera
                    self.showingImagePicker = true
                },
                .cancel()
            ])
        }
    }

    func signUp(){
        if let error = errorCheck(){
            self.error = error
            self.showingAlert = true
            return
        }

        session.signUp(email: email, password: password) { (result, error) in
            if let error = error{
                self.error = error.authErrorValue
                self.showingAlert = true
                return
            }
            ///UPLAOD USER DATA
            
            /*
             self.session.uploadUser(name: self.name, image: "imageUrl", user: self.session.session!) { (error) in
                if let error = error{
                    print(error.localizedDescription)
                }else {
                    self.sendImage()
                }
            }
             */
            self.email = ""
            self.password = ""
        }
    }

    func sendImage(){
         guard let inputImage = inputImage else { return}
        //session.createProfile(inputImage)
    }

    func errorCheck()->String?{
        if email.trimmingCharacters(in: .whitespaces).isEmpty ||
            password.trimmingCharacters(in: .whitespaces).isEmpty ||
            confirmpassword.trimmingCharacters(in: .whitespaces).isEmpty ||
            name.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Please Fill in all the fields"
        }
        if !(password == confirmpassword) {
            return "Passwords do not match"
        }
        return nil
    }

    func loadImage(){
        guard let inputImage = inputImage else { return}
        profileImage = Image(uiImage: inputImage)
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
