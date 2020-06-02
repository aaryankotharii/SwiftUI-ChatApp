//
//  CustomModifiers.swift
//  ChatApp
//
//  Created by Aaryan Kothari on 02/06/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import SwiftUI

struct CustomTextField : ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.system(size:14))
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("bg1"), lineWidth: 1 ))
    }
}

struct CustomButton : ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 50)
            .foregroundColor(.white)
            .font(.system(size:14, weight: .bold))
            .background(LinearGradient(gradient: Gradient(colors: [Color("bg1"),Color("bg2")]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(5)
    }
}
