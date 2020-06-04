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
    @Environment(\.imageCache) var cache: ImageCache


    init(user : UserData, session : SessionStore) {
        self.user = user
        self.session = session
       UITableView.appearance().separatorStyle = .none
       UITableView.appearance().tableFooterView = UIView()
    }

    var body: some View {
        VStack {
            List(messages, id:\.self) { message in
                if message.fromId == self.session.session?.uid{
                    ChatRow(text: message.text ?? "", myMessage: true)
                } else {
                    ChatRow(text: message.text ?? "", myMessage: false)
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
            
            }.navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarItems(leading: titleBar)
        .onAppear(perform: getMessages)
    }
    
    private var titleBar: some View {
        HStack{
        AsyncImage(
            url: URL(string: user.profileImageUrl ?? "")!,
            cache: cache,
            placeholder: Image(systemName: "person.fill"),
            configuration: { $0.resizable().renderingMode(.original) }
        )
            .aspectRatio(contentMode: .fit)
            .frame(idealHeight: 30 )
            .clipShape(Circle())
            Text(user.name ?? "").fontWeight(.medium)
        }.padding(.leading,30)
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


