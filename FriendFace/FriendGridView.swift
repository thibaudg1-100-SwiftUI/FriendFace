//
//  FriendGridView.swift
//  FriendFace
//
//  Created by RqwerKnot on 14/03/2022.
//

import SwiftUI

struct FriendGridView: View {
    
    let user: User
    
    var body: some View {
        VStack {
            Image("userFace")
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
                .padding(2)
                .overlay(
                    Circle()
                        .strokeBorder(.black.opacity(0.1))
                )
                .shadow(radius: 3)
//                .padding(4)
                .padding()
            
            VStack {
                Text(user.name)
                    .font(.title3)
                    .lineLimit(1)
                
                Text(user.company)
                    .font(.caption)
                    .lineLimit(1)
            }
            .foregroundColor(Color("tag"))
            .frame(maxWidth: .infinity)
            .background(Color.mint)
        }
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke()
        }
    }
}

struct FriendGridView_Previews: PreviewProvider {
    static var previews: some View {
        FriendGridView(user: User.defaultUser)
            .previewLayout(.sizeThatFits)
    }
}
