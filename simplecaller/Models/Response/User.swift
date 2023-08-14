//
//  User.swift
//  simplecaller
//
//  Created by Bertay Yönel on 12.08.2023.
//

import Foundation

struct User: Decodable {
    let identity: Identity
}

struct Identity: Decodable {
    let onesignal_id: String
    let external_id: String
}
