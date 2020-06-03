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
                    Text(text).padding(10).background(Color.secondary)
                        .cornerRadius(18)
                        .foregroundColor(.white)
                    //                    Image(uiImage: UIImage(data: self.image)!).resizable()
                    //                        .frame(width: 45, height: 45)
                    //                    .clipShape(Circle())
                    //                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                }
            } else {
                HStack {
                    //                    Image(uiImage: UIImage(data: self.image)!).resizable()
                    //                        .frame(width: 45, height: 45)
                    //                    .clipShape(Circle())
                    //                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    
                    Text(text).padding(10).background(Color.blue)
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
    var body : some View {
        HStack{
            Image(systemName : "person.fill")
            VStack{
                Text(user.name ?? "")
                Text(message.text ?? "")
            }
        }
    }
}

