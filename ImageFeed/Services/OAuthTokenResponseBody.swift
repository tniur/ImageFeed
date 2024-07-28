//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Pavel on 26.07.2024.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    var accessToken: String
    var tokenType: String
    var scope: String
    var createdAt: Int
    
    enum CodingKeys: String, CodingKey{
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope = "scope"
        case createdAt = "created_at"
    }
    
    init(accessToken: String,tokenType: String, scope: String, createdAt: Int) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.scope = scope
        self.createdAt = createdAt
    }
}
