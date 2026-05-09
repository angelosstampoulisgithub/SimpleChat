//
//  ContentView.swift
//  SimpleChat
//
//  Created by Angelos Staboulis on 9/5/26.
//

import SwiftUI
enum DemoUser: String {
    case userA = "userA_id"
    case userB = "userB_id"

    var displayName: String {
        switch self {
        case .userA: return "User A"
        case .userB: return "User B"
        }
    }
}

struct ContentView: View {
    @State private var currentUser: DemoUser
    @State private var otherUser: DemoUser

    @StateObject private var viewModel: ChatViewModel

    init(currentUser: DemoUser, otherUser: DemoUser) {
        _currentUser = State(initialValue: currentUser)
        _otherUser = State(initialValue: otherUser)

        _viewModel = StateObject(
            wrappedValue: ChatViewModel(
                senderID: currentUser.rawValue,
                receiverID: otherUser.rawValue
            )
        )
    }

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.messages) { msg in
                        HStack {
                            if msg.senderID == viewModel.senderID {
                                Spacer()
                                Text(msg.text)
                                    .padding()
                                    .background(Color.blue.opacity(0.3))
                                    .cornerRadius(10)
                            } else {
                                Text(msg.text)
                                    .padding()
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(10)
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }

            HStack {
                TextField("Message…", text: $viewModel.text)
                    .textFieldStyle(.roundedBorder)

                Button("Send") {
                    viewModel.send()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .onAppear {
            viewModel.fetch()
        }
        .toolbar {
            Menu {
                Button("User A") {
                    switchUser(to: .userA)
                }
                Button("User B") {
                    switchUser(to: .userB)
                }
            } label: {
                Label("Switch User", systemImage: "person.crop.circle")
            }
        }
        .navigationTitle("Chat (\(currentUser.displayName))")
    }

    // MARK: - Switch User Logic
    private func switchUser(to newUser: DemoUser) {
        currentUser = newUser
        otherUser = (newUser == .userA) ? .userB : .userA

        viewModel.updateUsers(
            senderID: currentUser.rawValue,
            receiverID: otherUser.rawValue
        )
    }
}
