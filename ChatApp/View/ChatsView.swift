//
//  ChatsView.swift
//  ChatApp
//
//  Created by Aaryan Kothari on 03/06/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import SwiftUI

struct ChatsView: View {
   @State var messages = [Message]()
   @State var messagesDictionary = [String:Message]()
    @EnvironmentObject var session : SessionStore
    @State var showNewChatsView : Bool = false

    var body: some View {
        NavigationView{
        List(messages) { message in
            Text(message.text!)
        }
        .navigationBarTitle(Text("Chats"), displayMode: .large)
        .navigationBarItems(leading: logoutButton, trailing: newChatButton
        .sheet(isPresented: $showNewChatsView) {
            NewChatsView()
        })
        }
    }
    
    var logoutButton : Button<Text> {
        return Button(action: session.signOut){
            Text("Logout")
        }
    }
    
    var newChatButton : Button<Image>{
        return Button(action : newChat){
            Image(systemName: "plus")
        }
    }
    
    func observe(){
        session.observeUserMessages(completion: getMessages(messages:messagesDictionary:))
    }
    func getMessages(messages:[Message],messagesDictionary:[String:Message]){
        self.messages = messages
        self.messagesDictionary = messagesDictionary
    }
    func newChat(){
        showNewChatsView = true
    }
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView()
    }
}
