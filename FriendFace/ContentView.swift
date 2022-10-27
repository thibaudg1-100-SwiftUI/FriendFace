//
//  ContentView.swift
//  FriendFace
//
//  Created by RqwerKnot on 11/03/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var users = [User]()
    
    var body: some View {
        
        NavigationView {
            List(users, id: \.id) { user in
                
                NavigationLink {
                    UserDetailView(user: user, users: self.users)
                } label: {
                    UserRow(user: user)
                }
            }
            .navigationTitle("FriendFace")
        }
        .task {
            if self.users.isEmpty {
                await loadData()
            }
        }
        
    }
    
    func loadData() async {
        // 1: define an URL object from a String representing the URI:
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            fatalError()
        }
        
        // 2: download data using URLSession shared singleton session object:
        guard let (data, _) = try? await URLSession.shared.data(from: url) else {
            print("Couldn't download data")
            return
        }
        
        // 3: Decode JSON:
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard let decodedResponse = try? decoder.decode([User].self, from: data) else {
            print("Failed to decode JSON")
            return
        }
        print("Data decoded, first element's name: \(decodedResponse[0].name)") // Quick check for data
        
        // 4: Assign value to this View's Users array
        self.users = decodedResponse
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
