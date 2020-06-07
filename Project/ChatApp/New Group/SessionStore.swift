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
    @Published var messages = [Message]()
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
            self.users = []
            self.messages = [Message]()
            self.messagesDictionary = [String:Message]()
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
                    
                    var message = Message()
                    
                    if let text = dictionary["text"]{ message.text = text  as? String }
                    if let imageUrl = dictionary["imageUrl"]{ message.imageUrl = imageUrl  as? String }
                    message.fromId = (dictionary["fromId"] as! String)
                    message.toId = (dictionary["toId"] as! String)
                    message.timestamp = (dictionary["timestamp"] as! Int)
                    
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
                user.profileImageUrl = (dictionary["profileImageUrl"] as! String)
                user.id = snapshot.key
                self.users.append(user)
            }
        }, withCancel: nil)
    }
    
    func createUser(user:UserData){
        let param = ["name":user.name,"email":user.email,"profileImageUrl":user.profileImageUrl]
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
    
    func getUserFromMSG(_ message : Message)->UserData{
        
        if let chatPatnerId = message.chatPatnerId(){
            
            let user =  self.users.filter { $0.id == chatPatnerId }
            
            return user.first!
        }
        return UserData()
    }
    
    
    //MARK:- Send Message to firebase
    func sendData(user : UserData, message : String, imageUrl : String? = nil){
        let reference = ref.child("messages")
        
        let childRef = reference.childByAutoId()
        
        let toId = user.id
        
        let fromId = Auth.auth().currentUser!.uid
        
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        
        var values = ["text":message, "toId":toId!, "fromId":fromId,"timestamp":timeStamp] as [String : Any]
        
        if let imageUrl = imageUrl { values["imageUrl"] = imageUrl }
        
        childRef.updateChildValues(values) { (error, ref) in
            
            if let error = error{
                
                print(error.localizedDescription)
                
            }else{
                
                let userMessagesRef = Database.database().reference().child("user-messages").child(fromId)
                
                let messageId = childRef.key!
                
                userMessagesRef.updateChildValues([messageId:"a"])
                
                let recipientUserMessagesReference = Database.database().reference().child("user-messages").child(toId ?? "")
                
                recipientUserMessagesReference.updateChildValues([messageId:"a"])
            }
        }
    }
    
    //MARK:- Update profile picture
     func updateProfileImage(url: String) {
        let ref = self.ref.child("users").child(session?.uid ?? "uid")
        ref.updateChildValues(["imageUrl":url])
    }
    
    func createProfile(_ profileImage : UIImage){
        uplaodImage(profileImage) { (url) in
            if let url = url {
            self.updateProfileImage(url: url)
            }
        }
    }

func uplaodImage(_ profileImage : UIImage, completion : @escaping (String?)->()){
    print("IMAGE UPLAOD")
    let ref = Storage.storage().reference()
    let storageRef = ref.child("profile_images").child("\(uid).jpg")
    
    if let uploadData = profileImage.jpegData(compressionQuality: 0.2){    /// convert image to data
        storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
            if let error = error {
                completion(nil)
                print(error.localizedDescription)
            } else {
                
                storageRef.downloadURL { (url, error) in    /// get url from storage
                    if let error = error {
                        completion(nil)
                        print(error.localizedDescription)
                    }else{
                        completion(url?.absoluteString ?? "inavlid")
                    }
                }
            }
        }
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
