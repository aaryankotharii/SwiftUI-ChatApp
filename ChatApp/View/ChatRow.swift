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
    //  var user = ""
    
    // @Binding var image : Data
    var body: some View {
        
        HStack {
            if myMessage {
                Spacer()
                
                HStack {
                    Text(text).padding(10)
                        .background(Color.blue)
                        .cornerRadius(18)
                        .foregroundColor(.white)
//                        Image(uiImage: UIImage(data: self.image)!)
//                            .resizable()
//                                .frame(width: 45, height: 45)
//                                .clipShape(Circle())
//                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                }
            } else {
                HStack {
                    //                    Image(uiImage: UIImage(data: self.image)!).resizable()
                    //                        .frame(width: 45, height: 45)
                    //                    .clipShape(Circle())
                    //                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    
                    Text(text).padding(10)
                        .background(Color.secondary)
                        .cornerRadius(28)
                        .foregroundColor(.white)
                }
                Spacer()
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

