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
    @EnvironmentObject var session : SessionStore
    @State var showNewChatsView : Bool = false
    @State var user = UserData()
    @State var activateNavigation : Bool = false
    
    var body: some View {
        NavigationView{
            List(session.messages) { message in
                NavigationLink(destination: ChatLogView(user: self.session.getUserFromMSG(message))) {
                    ChatViewRow(user: self.session.getUserFromMSG(message), message : message)
                    }
            }
            .navigationBarTitle(Text("Chats"), displayMode: .large)
            .navigationBarItems(leading: logoutButton, trailing: newChatButton
            .sheet(isPresented: $showNewChatsView) {
                NewChatsView().environmentObject(self.session)
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

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView()
    }
}
