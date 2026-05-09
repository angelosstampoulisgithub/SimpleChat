//
//  ChatViewModel.swift
//  SimpleChat
//
//  Created by Angelos Staboulis on 9/5/26.
//

import Foundation
import SwiftUI

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var text: String = ""

    var senderID: String
    var receiverID: String
    private let manager = CloudKitChatManager.shared

    init(senderID: String, receiverID: String) {
        self.senderID = senderID
        self.receiverID = receiverID
        fetch()
    }

    func fetch() {
        manager.fetchConversation(senderID: senderID,
                                  receiverID: receiverID) { result in
            if case .success(let msgs) = result {
                self.messages = msgs
            }
        }
    }

    func send() {
        manager.sendMessage(senderID: senderID,
                            receiverID: receiverID,
                            text: text) { result in
            if case .success(let msg) = result {
                self.messages.append(msg)
                self.text = ""
            }
        }
    }
}
extension ChatViewModel {
    func updateUsers(senderID: String, receiverID: String) {
        self.senderID = senderID
        self.receiverID = receiverID
        self.messages.removeAll()
        fetch()
    }
}
