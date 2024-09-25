//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Pavel on 21.08.2024.
//

@testable import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: (any ImageFeed.ProfileViewControllerProtocol)?
    var isLogoutButtonTapped: Bool = false
    
    func logoutButtonTapped() {
        isLogoutButtonTapped = true
    }
    
    func getProfile() -> ImageFeed.Profile? {
        return Profile(username: "username", firstName: "firstName", lastName: nil, bio: nil)
    }
    
    func viewDidLoad() { }
    
    func getAvatarUrl() -> URL? {
        nil
    }
    
    func setupObserver() { }
}
