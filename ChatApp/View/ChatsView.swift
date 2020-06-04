//
//  ChatsView.swift
//  ChatApp
//
//  Created by Aaryan Kothari on 03/06/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import SwiftUI

struct ChatsView: View {
    @State var messagesDictionary = [String:Message]()
    @ObservedObject var session : SessionStore
    @State var showNewChatsView : Bool = false
    @State var user = UserData()
    @State var activateNavigation : Bool = false
    
    
    var body: some View {
        NavigationView{
            List(session.messages, id: \.id) { message in
                ZStack {
                    NavigationLink(destination: ChatLogView(user: self.session.getUserFromMSG(message), session: self.session)) {
                        EmptyView()
                    }.hidden()
                    ChatViewRow(user: self.session.getUserFromMSG(message), message : message)
                }
            }
            .navigationBarTitle(Text("Chats"), displayMode: .large)
            .navigationBarItems(leading: logoutButton, trailing: newChatButton
            .sheet(isPresented: $showNewChatsView) {
                NewChatsView(session: self.session)
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
    
    func newChat(){
        showNewChatsView = true
    }
    
    func getUser(_ message : Message){
        session.getUserFromMessage(message) { (user) in
            self.user = user
            self.activateNavigation = true
        }
    }
}
