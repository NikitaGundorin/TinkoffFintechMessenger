//
//  FirestoreNetworkManager.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 17.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Firebase

class FirestoreNetworkManager: NetworkManager {
    private lazy var db = Firestore.firestore()
    private lazy var channelsReference = db.collection("channels")
    private var messagesReference: CollectionReference?
    private var messageListener: ListenerRegistration?
    
    func subscribeChannels(completion: @escaping ([Channel]?, Error?) -> Void) {
        channelsReference.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                if let error = error {
                    completion(nil, error)
                }
                return
            }
            
            let data = snapshot.documents.compactMap { document -> Channel? in
                let lastMessage = document["lastMessage"] as? String
                let lastActivity = (document["lastActivity"] as? Timestamp)?.dateValue()
                guard let name = document["name"] as? String,
                    !name.isEmptyOrOnlyWhitespaces,
                    (lastMessage != nil && lastActivity != nil)
                    || (lastActivity == nil && lastMessage == nil)
                    
                else { return nil }
                
                return .init(identifier: document.documentID,
                             name: name,
                             lastMessage: lastMessage,
                             lastActivity: lastActivity)
            }.sorted { ($0.lastActivity ?? .distantPast) > ($1.lastActivity ?? .distantPast) }
            
            completion(data, nil)
        }
    }
    
    func subscribeMessages(forChannelWithId channelId: String,
                           completion: @escaping ([Message]?, Error?) -> Void) {
        messagesReference = db.collection("channels").document(channelId).collection("messages")
        
        messageListener = messagesReference?.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                if let error = error {
                    completion(nil, error)
                }
                return
            }
            
            let data = snapshot.documents.compactMap { document -> Message? in
                guard let content = document["content"] as? String,
                    !content.isEmptyOrOnlyWhitespaces,
                    let created = (document["created"] as? Timestamp)?.dateValue(),
                    let senderId = document["senderId"] as? String,
                    !senderId.isEmptyOrOnlyWhitespaces,
                    let senderName = document["senderName"] as? String,
                    !senderName.isEmptyOrOnlyWhitespaces
                else { return nil }
                
                return .init(content: content, created: created, senderId: senderId, senderName: senderName)
            }.sorted { $0.created < $1.created }
            
            completion(data, nil)
        }
    }
    
    func unsubscribeChannel() {
        messageListener?.remove()
    }
    
    func createChannel(withName name: String, completion: @escaping (String) -> Void) {
        var document: DocumentReference?
        document = channelsReference.addDocument(data: ["name": name]) { _ in
                    completion(document?.documentID ?? "")
        }
    }
    
    func sendMessage(widthContent content: String, senderId: String, senderName: String, completion: @escaping () -> Void) {
        messagesReference?.addDocument(data: ["content": content,
                                              "created": Timestamp(date: Date()),
                                              "senderName": senderName,
                                              "senderId": senderId]) { _ in
                                                completion()
        }
    }
}
