//
//  ContentView.swift
//  ChatApp
//
//  Created by Aaryan Kothari on 02/06/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session : SessionStore
    
    func getUser(){
        session.listen()
    }
    var body: some View {
        Group{
            if (session.session != nil){
                ChatsView(session: self.session)
            }
            else{
                HomeView()
            }
        }.onAppear(perform: getUser)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SessionStore())
    }
}
