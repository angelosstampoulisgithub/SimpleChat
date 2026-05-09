//
//  CloudKitDataManager.swift
//  SimpleChat
//
//  Created by Angelos Staboulis on 9/5/26.
//

import Foundation
import CloudKit

final class CloudKitChatManager {

    static let shared = CloudKitChatManager()
    private init() {}

    private let database = CKContainer.default().publicCloudDatabase

    func fetchConversation(senderID: String,
                           receiverID: String,
                           completion: @escaping (Result<[ChatMessage], Error>) -> Void) {

          var allMessages: [ChatMessage] = []
           let group = DispatchGroup()

                let predicate2 = NSPredicate(format: "senderID == %@ AND receiverID == %@", receiverID, senderID)
           let query2 = CKQuery(recordType: "Messages", predicate: predicate2)
           query2.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]

           group.enter()
           database.perform(query2, inZoneWith: nil) { records, error in
               if let records = records {
                   allMessages.append(contentsOf: records.map(ChatMessage.init))
               }
               group.leave()
           }

           group.notify(queue: .main) {
               let sorted = allMessages.sorted { $0.createdAt < $1.createdAt }
               completion(.success(sorted))
           }
    }

    func sendMessage(senderID: String,
                     receiverID: String,
                     text: String,
                     completion: @escaping (Result<ChatMessage, Error>) -> Void) {

        let record = CKRecord(recordType: "Messages")
        record["senderID"] = senderID
        record["receiverID"] = receiverID
        record["text"] = text
        record["createdAt"] = Date()

        database.save(record) { record, error in
            DispatchQueue.main.async {
                if let record = record {
                    completion(.success(ChatMessage(record: record)))
                } else {
                    completion(.failure(error!))
                }
            }
        }
    }
}
