//
//  UserRow.swift
//  FriendFace
//
//  Created by RqwerKnot on 11/03/2022.
//

import SwiftUI

struct UserRow: View {
    
    let user: User
    
    var status: String {
        user.isActive ? "smallcircle.filled.circle.fill" : "smallcircle.filled.circle"
    }
    
    var body: some View {
        HStack {
            Text(user.name)
            Spacer()
            Image(systemName: status)
                .foregroundColor(user.isActive ? .green : .gray)
        }
    }
}

struct UserRow_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(DynamicTypeSize.allCases, id: \.self) { item in
            UserRow(user: User.defaultUser)
                .previewLayout(.sizeThatFits)
                .environment(\.dynamicTypeSize, item)
                .previewDisplayName("\(item)")
        }
        
    }
}
