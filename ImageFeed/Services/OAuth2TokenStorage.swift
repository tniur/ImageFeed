//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Pavel on 26.07.2024.
//

import Foundation

final class OAuth2TokenStorage {
    var token : String? {
        get {
            guard let token = UserDefaults.standard.string(forKey: "bearer_token") else {
                return nil
            }
            return token
        }
        set {
            UserDefaults.standard.set(newValue,forKey: "bearer_token")
        }
    }
}
