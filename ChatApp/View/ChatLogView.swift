//
//  ChatLogView.swift
//  ChatApp
//
//  Created by Aaryan Kothari on 03/06/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import SwiftUI

struct ChatLogView: View {
    var user : UserData
    var body: some View {
        Text("Hello, World!")
            .navigationBarTitle(Text(user.name ?? "Unknown"), displayMode: .inline)
    }
}


