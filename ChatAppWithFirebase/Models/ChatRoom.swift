//
//  ChatRoom.swift
//  ChatAppWithFirebase
//
//  Created by 松浦孝太朗 on 2020/09/16.
//  Copyright © 2020 Kotaro. All rights reserved.
//

import Foundation
import Firebase

class ChatRoom {
    
    let latestMessageId: String
    let members: [String]
    let createdAt: Timestamp
    
    var latestMessage: Message?
    var documentId: String?
    var partnerUser: User?
    
    init(dic: [String: Any]) {
        self.latestMessageId = dic["latestMessageId"] as? String ?? ""
        self.members = dic["members"] as? [String] ?? [String]()
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
    
}
