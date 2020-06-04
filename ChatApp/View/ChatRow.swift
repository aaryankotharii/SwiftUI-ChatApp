//
//  ChatRow.swift
//  ChatApp
//
//  Created by Aaryan Kothari on 03/06/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import SwiftUI

struct ChatRow : View {
    
    var message : Message
    var uid : String
    @Environment(\.imageCache) var cache: ImageCache
    
    var body: some View {
        
        HStack {
            if message.imageUrl != nil{
                if message.fromId == uid {
                    HStack {
                        Spacer()
                        image
                    }.padding(.leading,75)
                } else {
                    HStack {
                        image
                        Spacer()
                    }.padding(.trailing,75)
                }
            } else {
                if message.fromId == uid {
                    HStack {
                        Spacer()
                        Text(message.text ?? "")
                            .modifier(chatModifier(myMessage: true))
                    }.padding(.leading,75)
                } else {
                    HStack {
                        Text(message.text ?? "")
                            .modifier(chatModifier(myMessage: false))
                        Spacer()
                    }.padding(.trailing,75)
                }
            }
        }
    }
    
    private var image: some View {
        AsyncImage(
            url: URL(string: message.imageUrl ?? "")!,
            cache: cache,
            placeholder: Image(systemName: "person.fill"),
            configuration: { $0.resizable().renderingMode(.original) }
        )
            .aspectRatio(contentMode: .fit)
            .frame(idealWidth: 300)
            .cornerRadius(10)
    }
}


struct chatModifier : ViewModifier{
    var myMessage : Bool
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(myMessage ? Color.blue : Color.secondary)
            .cornerRadius(7)
            .foregroundColor(Color.white)
    }
}


struct ChatViewRow : View {
    var user : UserData
    var message : Message
    
    @Environment(\.imageCache) var cache: ImageCache
    
    
    var body : some View {
        HStack{
            profilePicture.padding(.trailing,10)
            VStack(alignment: .leading, spacing: 3){
                HStack{
                    Text(user.name ?? "")
                        .font(.system(size: 15, weight: .semibold))
                    Spacer()
                    Text("\(message.timestamp?.timeStringConverter ?? "")")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.blue)
                }
                Text(message.text ?? "")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var profilePicture: some View {
        AsyncImage(
            url: URL(string: user.profileImageUrl ?? "")!,
            cache: cache,
            placeholder: Image(systemName: "person.fill"),
            configuration: { $0.resizable().renderingMode(.original) }
        )
            .aspectRatio(contentMode: .fit)
            .frame(idealHeight: 56 )
            .clipShape(Circle())
    }
}


