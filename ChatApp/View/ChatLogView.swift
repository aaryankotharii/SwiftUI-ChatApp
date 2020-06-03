//
//  ChatLogView.swift
//  ChatApp
//
//  Created by Aaryan Kothari on 03/06/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import SwiftUI

struct ChatLogView: View {
    var user : UserData
    @EnvironmentObject var session : SessionStore
    @State var messages = [Message]()
    @State var write = ""

    var body: some View {
        VStack {
            List(messages) { message in
                Text(message.text!)
            }.navigationBarTitle(Text(user.name ?? "Unknown"), displayMode: .inline)
            
            HStack {
                TextField("message...",text: self.$write).padding(10)
                    .background(Color(red: 233.0/255, green: 234.0/255, blue: 243.0/255))
                .cornerRadius(25)
                
                Button(action: {
                    if self.write.count > 0 {
                        /// send message
                       // self.message.addInfo(msg: self.write, user: self.name, image: self.image)
                        self.write = ""
                    } else {
                        
                    }
                }) {
                    Image(systemName: "paperplane.fill").font(.system(size: 20))
                        .foregroundColor((self.write.count > 0) ? Color.blue : Color.gray)
                        .rotationEffect(.degrees(50))
                    
                }
            }.padding()
            
    }
    }
    func getMessages(){
        session.observeMessages { (dictionary,id) in
            var message = Message(id: id)
             if let text = dictionary["text"]{ message.text = (text as! String) }
             message.fromId = (dictionary["fromId"] as! String)
             message.toId = (dictionary["toId"] as! String)
             message.timestamp = (dictionary["timestamp"] as! Int)
             
            if message.chatPatnerId() == self.user.id {
                self.messages.append(message)
                }
        }
    }
}


