//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Pavel on 21.08.2024.
//

import UIKit

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func logoutButtonTapped()
    func getProfile() -> Profile?
    func getAvatarUrl() -> URL?
    func setupObserver()
    func viewDidLoad()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileService: ProfileService = ProfileService.shared
    
    func viewDidLoad() {
        setupObserver()
    }
    
    func setupObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                view?.updateAvatar()
            }
    }
    
    func getProfile() -> Profile? {
        guard let profile = profileService.profile else {
            return nil
        }
        
        return profile
    }
    
    func getAvatarUrl() -> URL? {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else {
            return nil
        }
        
        return url
    }
    
    func logoutButtonTapped() {
        let alert = UIAlertController(
            title: "Выход.",
            message: "Вы действительно хотите выйти?",
            preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "error"
        
        let dismissAction = UIAlertAction(title: "Нет.", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        
        let tryAction = UIAlertAction(title: "Да!", style: .default) { _ in
            let profileLogoutService = ProfileLogoutService.shared
            profileLogoutService.logout()
        }
        
        alert.addAction(dismissAction)
        alert.addAction(tryAction)
        
        view?.showAlert(alert: alert)
    }
}
