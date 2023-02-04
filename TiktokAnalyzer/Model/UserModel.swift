//
//  UserModel.swift
//  TikAnalyzer
//
//  Created by Christina Santana on 7/12/22.
//

import Foundation

struct UserModel: Codable{
    let profilePicUrl: String
    let nickname: String
    let userId: String
    let follower: Int
    let following: Int
    let likes: Int
    var commentCount: Int
}



