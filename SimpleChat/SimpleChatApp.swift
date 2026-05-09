//
//  SimpleChatApp.swift
//  SimpleChat
//
//  Created by Angelos Staboulis on 9/5/26.
//

import SwiftUI

@main
struct SimpleChatApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                ContentView(currentUser: .userA, otherUser: .userB)
            }
        }
    }
}
