//
//  UserDetailView.swift
//  FriendFace
//
//  Created by RqwerKnot on 11/03/2022.
//

import SwiftUI

// to make String confomr to Identifiable protocol and to be able to use it in .sheet modifier:
extension String: Identifiable {
    
    public var id: String {
        self
    }
}

struct UserDetailView: View {
    // the user to show details of
    let user: User
    // users that are his friends:
    let friends: [User]
    // list of users that has a tag in common with this user:
    let usersForTag: [String: [User]]
    // layout used for the Friends Grid View:
    let layout = [ GridItem(.adaptive(minimum: 150)) ]
    // contains the Friend to show details about:
    @State private var selectedUser: User?
    @State private var selectedTag: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
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
                    .padding(4)
                    .frame(width: 100)
                
                VStack(alignment: .leading) {
                    Text(user.name)
                        .font(.title.bold())
                    
                    Text(user.email)
                        .font(.headline)
                    
                    HStack {
                        Text("\(user.age) ans")
                            .font(.title3)
                        
                        Text("working at: \(user.company)")
                            .foregroundColor(.secondary)
                    }
                    
                    Text(user.address)
                        .font(.caption2)
                }
            }

            Divider()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(user.tags, id: \.self) { tag in
                        Button {
                            selectedTag = tag
                        } label: {
                            Text("#\(tag)")
                                .foregroundColor(Color("tag"))
                                .bold()
                                .padding(3)
                                .background(Color.mint)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .padding(.leading, 2)
                        }
                    }
                }
            }
            
            Divider()
            
            ScrollView {
                VStack(alignment: .leading) {
                    Text("About me")
                        .font(.headline)
                        .padding(.top)
                    
                    Text(user.about)
                    
                    Text("My friends")
                        .font(.headline)
                        .padding(.top)
                }
                .padding(.horizontal)
                
                LazyVGrid(columns: layout) {
                    ForEach(friends, id: \.id) { friend in
                        FriendGridView(user: friend)
                            .onTapGesture {
                                selectedUser = friend
                            }
                    }
                }
                .padding(.horizontal)
            }

        }
        .navigationTitle(user.isActive ? "Online" : "Offline")
        .navigationBarTitleDisplayMode(.inline)
        // this .sheet init is the proper way to show a sheet whose content depends on a choice made in a button:
        .sheet(item: $selectedUser) { user in
            UserDetailQuickView(user: user)
                .onTapGesture {
                    selectedUser = nil // dismiss the sheet view by pressing on it
                }
        }
        .sheet(item: $selectedTag) { tag in
            TagDetailsView(tag: tag, users: usersForTag[tag] ?? [])
                .onTapGesture {
                    selectedTag = nil // dismiss the sheet view by pressing on it
                }
        }
    }
    
    init(user: User, users: [User]) {
        self.user = user
        
        // creating a dictionnary of users out of the array of users:
        var dict = [String: User]()
        for u in users {
            dict["\(u.id)"] = u
        }
        // filtering friends among users
        self.friends = user.friends.map { friend in
            if let us = dict[friend.id] {
                return us
            } else {
                fatalError("Missing friend \(friend.name) in Users DB")
            }
        }
        
        var usersForTag = [String: [User]]()
        
        for t in user.tags {
            usersForTag[t] = [] // need to initialize the array of Users here, otherwise the .append func below will fail
            for u in users {
                if u.tags.contains(t) {
                    usersForTag[t]?.append(u)
                }
            }
        }
        
        self.usersForTag = usersForTag
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                UserDetailView(user: Self.sampleUsers.randomElement()!, users: Self.sampleUsers)
            }
            .preferredColorScheme(.light)
            
            NavigationView {
                UserDetailView(user: User.users[0], users: User.users)
            }
            .preferredColorScheme(.dark)
        }
    }
    
    static var sampleUsers: [User] {
        guard let url = Bundle.main.url(forResource: "friendface.json", withExtension: nil) else {
            return []
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return []
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let users = try? decoder.decode([User].self, from: data)

        return users ?? [] // will crash if it's not been decoded properly
    }
}
