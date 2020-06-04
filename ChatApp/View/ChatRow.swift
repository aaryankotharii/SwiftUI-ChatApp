//
//  ChatRow.swift
//  ChatApp
//
//  Created by Aaryan Kothari on 03/06/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import SwiftUI

struct ChatRow : View {
    
    var text = ""
    
    var myMessage = false
    
    var body: some View {
        
        HStack {
            if myMessage {
                HStack {
                    Spacer()
                    Text(text).padding(10)
                        .frame(maxWidth: 300)
                        .fixedSize(horizontal: true, vertical: false)
                        .background(Color.blue)
                        .cornerRadius(7)
                        .foregroundColor(.white)
                }
            } else {
                HStack {
                    Text(text).padding(10)
                        .background(Color.secondary)
                        .cornerRadius(28)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
        }
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


