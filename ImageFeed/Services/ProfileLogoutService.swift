//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Pavel on 19.08.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    private init() { }
    
    func logout() {
        cleanCookies()
        cleanTokenStorage()
        cleanProfile()
        cleanProfilePhoto()
        cleanImagesList()
        
        guard let window = UIApplication.shared.windows.first else { return }
        window.rootViewController = SplashViewController()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func cleanTokenStorage() {
        let tokenStorage = OAuth2TokenStorage()
        tokenStorage.token = nil
    }
    
    private func cleanProfile() {
        let profileService = ProfileService.shared
        profileService.cleanProfile()
    }
    
    private func cleanProfilePhoto(){
        let profileImageService = ProfileImageService.shared
        profileImageService.cleanImage()
    }
    
    private func cleanImagesList(){
        let imagesListService = ImagesListService()
        imagesListService.cleanImages()
    }
}
