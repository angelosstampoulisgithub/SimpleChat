//
//  ChatMessage.swift
//  SimpleChat
//
//  Created by Angelos Staboulis on 9/5/26.
//

import Foundation
import CloudKit

struct ChatMessage: Identifiable {
    let id: CKRecord.ID
    let senderID: String
    let receiverID: String
    let text: String
    let createdAt: Date

    init(record: CKRecord) {
        id = record.recordID
        senderID = record["senderID"] as? String ?? ""
        receiverID = record["receiverID"] as? String ?? ""
        text = record["text"] as? String ?? ""
        createdAt = record["createdAt"] as? Date ?? Date()
    }

    static func newRecord(senderID: String, receiverID: String, text: String) -> CKRecord {
        let record = CKRecord(recordType: "Messages")
        record["senderID"] = senderID as CKRecordValue
        record["receiverID"] = receiverID as CKRecordValue
        record["text"] = text as CKRecordValue
        record["createdAt"] = Date() as CKRecordValue
        return record
    }
}
