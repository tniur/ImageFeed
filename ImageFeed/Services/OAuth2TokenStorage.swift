//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Pavel on 26.07.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    var token : String? {
        get {
            let token: String? = KeychainWrapper.standard.string(forKey: "bearer_token")
            return token
        }
        set {
            guard let newValue else {
                return
            }
            let isSuccess = KeychainWrapper.standard.set(newValue, forKey: "bearer_token")
            guard isSuccess else {
                return
            }
        }
    }
}
