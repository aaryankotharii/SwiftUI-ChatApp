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
    @ObservedObject var session : SessionStore
    @State var messages = [Message]()
    @State var write = ""

    var body: some View {
        VStack {
            List(messages, id:\.self) { message in
                if message.fromId == self.session.session?.uid{
                    ChatRow(text: message.text ?? "", myMessage: false)
                } else {
                    ChatRow(text: message.text ?? "", myMessage: true)
                }
            }
            HStack {
                TextField("message...",text: self.$write).padding(10)
                    .background(Color(red: 233.0/255, green: 234.0/255, blue: 243.0/255))
                .cornerRadius(25)
                
                Button(action: {
                    if self.write.count > 0 {
                        /// send message
                        self.session.sendData(user: self.user, message: self.write)
                        self.write = ""
                    } else {
                        
                    }
                }) {
                    Image(systemName: "paperplane.fill").font(.system(size: 20))
                        .foregroundColor((self.write.count > 0) ? Color.blue : Color.gray)
                        .rotationEffect(.degrees(50))
                    
                }
            }.padding()
            
        }.navigationBarTitle(Text(user.name ?? "Unknown"), displayMode: .inline)
        .onAppear(perform: getMessages)
    }
    func getMessages(){
        session.observeMessages { (dictionary,id) in
            var message = Message()
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


