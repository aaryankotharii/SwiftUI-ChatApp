//
//  SessionStore.swift
//  ChatApp
//
//  Created by Aaryan Kothari on 02/06/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import SwiftUI
import Firebase
import Combine

class SessionStore : ObservableObject{
    
    let ref = Database.database().reference()
    
    var didChange = PassthroughSubject<SessionStore,Never>()
    
    let uid = Auth.auth().currentUser?.uid ?? "uid"
    
    @Published var session : User? {
        didSet {
            self.didChange.send(self)
        }
    }
    
    @Published var users = [UserData]()
    @Published var messages = [Message](){
        didSet{
            print(messages)
        }
    }
    @Published var messagesDictionary = [String:Message]()
    
    var handle : AuthStateDidChangeListenerHandle?
    
    func listen(){
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                print("user state changed")
                self.session = User(uid: user.uid, email: user.email)
                self.fetchUsers()
                self.observeUserMessages()
            } else {
                self.session = nil
            }
        })
    }
    
    func signUp(email:String,password:String, handler : @escaping AuthDataResultCallback){
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func signIn(email:String,password:String,handler : @escaping AuthDataResultCallback){
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func signOut(){
        do {
            try Auth.auth().signOut()
            self.session = nil
        } catch {
            print("Error signing out")
        }
    }
    
    func unbind(){
        if let handle = handle {
            print("unbind")
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    deinit {
        unbind()
    }
    
    func observeUserMessages(){

        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let reference = self.ref.child("user-messages").child(uid)
        
        reference.observe(.childAdded, with: { (snapshot) in

            let messageId = snapshot.key
            
            let messagesReference = Database.database().reference().child("messages").child(messageId)
            
            messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in

                if let dictionary = snapshot.value as? [String:AnyObject]{
                    
                    var message = Message(id: snapshot.key)
                    
                    if let text = dictionary["text"]{ message.text = text  as? String }
                    message.fromId = (dictionary["fromId"] as! String)
                    message.toId = (dictionary["toId"] as! String)
                    message.timestamp = (dictionary["timestamp"] as! Int)
                    
                    print(message)
                    if let chatPatnerId = message.chatPatnerId() {
                        
                        self.messagesDictionary[chatPatnerId]  = message
                        
                        self.messages = Array(self.messagesDictionary.values)
                        
                        //MARK:- Sort messages Array
                        self.messages.sort { (message1, message2) -> Bool in
                            var bool = false
                            if let time1 = message1.timestamp, let time2 = message2.timestamp {
                                bool = time1 > time2
                            }
                            return bool
                        }
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    func observeMessages(completion : @escaping ([String:AnyObject],String)->()){
     guard let uid = Auth.auth().currentUser?.uid else {return}
     
     let userMessagesref = ref.child("user-messages").child(uid)
     
     userMessagesref.observe(.childAdded, with: { (snapshot) in
        
         let messageId = snapshot.key
         
         let messagesRef = Database.database().reference().child("messages").child(messageId)
        
         messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
        guard let dictionary = snapshot.value as?[String:AnyObject] else { return }
             
            completion(dictionary,snapshot.key)
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    func fetchUsers(){
        ref.child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                var user = UserData()
                user.name = (dictionary["name"] as! String)
                user.email = (dictionary["email"] as! String)
                user.id = snapshot.key
                self.users.append(user)
            }
        }, withCancel: nil)
    }
    
    func createUser(user:UserData){
        let param = ["name":user.name,"email":user.email,"imageUrl":user.profileImageUrl]
        ref.child("users").child(getUID()).setValue(param) { (error, ref) in
            if let error = error{
                print(error)
            }
        }
    }
    
    func getUserFromMessage(_ message : Message,completion: @escaping (UserData)->()){
        guard let chatPatnerId = message.chatPatnerId() else { return }
        
        
        ref.child("users").child(chatPatnerId).observe(.value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String:AnyObject]  else { return}
            
            var user = UserData()
            
            user.name = (dictionary["name"] as! String)
            user.email = (dictionary["email"] as! String)
            user.profileImageUrl = (dictionary["profileImageUrl"] as! String)
            user.id = chatPatnerId
            
            completion(user)
        }
    }
}

struct User {
    var uid : String
    var email : String?
    
    init(uid:String,email:String?){
        self.uid = uid
        self.email = email
    }
}
