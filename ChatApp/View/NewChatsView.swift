//
//  NewChatsView.swift
//  ChatApp
//
//  Created by Aaryan Kothari on 03/06/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import SwiftUI

struct NewChatsView: View {
    @ObservedObject var session : SessionStore
    var body: some View {
        NavigationView{
            List(session.users) { user in
                NavigationLink(destination: ChatLogView(user: user, session: self.session)) {
                    Text(user.name ?? "Unknown")
                }
            }.navigationBarTitle(Text("New Chat"), displayMode: .inline)
        }
    }
}


