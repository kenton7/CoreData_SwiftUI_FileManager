//
//  UserModel.swift
//  CacheHW
//
//  Created by Илья Кузнецов on 27.05.2024.
//

import Foundation

struct UserModel: Codable {
    let id: Int?
    let name, username, email: String?
    let phone, website: String?
}


