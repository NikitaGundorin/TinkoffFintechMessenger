//
//  FirestoreNetworkManager.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 17.10.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Firebase

class FirestoreNetworkManager: IConversationNetworkManager {
    
    // MARK: - Private properties
    
    private lazy var db = Firestore.firestore()
    private lazy var channelsReference = db.collection("channels")
    private var messagesReference: CollectionReference?
    private var messageListener: ListenerRegistration?
    
    // MARK: - INetworkManager
    
    func getChannels(completion: @escaping ([Channel]?, Error?) -> Void) {
        channelsReference.getDocuments { snapshot, error in
            guard let snapshot = snapshot else {
                if let error = error {
                    completion(nil, error)
                }
                return
            }
            
            let data = snapshot.documents.compactMap { Channel(document: $0) }
            
            completion(data, nil)
        }
    }
    
    func subscribeChannels(completion: @escaping ([DocumentChange]?, Error?) -> Void) {
        channelsReference.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                if let error = error {
                    completion(nil, error)
                }
                return
            }
            
            completion(snapshot.documentChanges, nil)
        }
    }
    
    func getMessages(forChannelWithId channelId: String,
                     completion: @escaping ([Message]?, Error?) -> Void) {
        
        channelsReference.document(channelId).collection("messages").getDocuments { snapshot, error in
            guard let snapshot = snapshot else {
                if let error = error {
                    completion(nil, error)
                }
                return
            }
            
            let data = snapshot.documents.compactMap { Message(document: $0) }
            
            completion(data, nil)
        }
    }
    
    func subscribeMessages(forChannelWithId channelId: String,
                           completion: @escaping ([DocumentChange]?, Error?) -> Void) {
        messagesReference = db.collection("channels").document(channelId).collection("messages")
        
        messageListener = messagesReference?.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                if let error = error {
                    completion(nil, error)
                }
                return
            }
            
            completion(snapshot.documentChanges, nil)
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
    
    func deleteChannel(withId identifier: String, completion: @escaping (Bool) -> Void) {
        channelsReference.document(identifier).delete { error in
            completion(error == nil)
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
