//
//  NewChatsView.swift
//  ChatApp
//
//  Created by Aaryan Kothari on 03/06/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import SwiftUI

struct NewChatsView: View {
    @EnvironmentObject var session : SessionStore
    var body: some View {
        NavigationView{
            List(session.users) { user in
                Text(user.name!)
            }
        }.onAppear(perform: session.fetchUsers)
    }
}

struct NewChatsView_Previews: PreviewProvider {
    static var previews: some View {
        NewChatsView()
    }
}
