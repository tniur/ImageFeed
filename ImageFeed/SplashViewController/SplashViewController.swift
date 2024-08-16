//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Pavel on 28.07.2024.
//

import UIKit
import SwiftKeychainWrapper

final class SplashViewController: UIViewController {
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let storage = OAuth2TokenStorage()
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreenSegueIdentifier"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = storage.token {
            fetchProfile(token)
        }  else {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
                return
            }
            authViewController.delegate = self
            let authNavigationController = UINavigationController(rootViewController: authViewController)
            authNavigationController.modalPresentationStyle = .fullScreen
            present(authNavigationController, animated: true)
        }
    }
    
    // MARK: - View
    
    private let logoImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "yp_logo"))
        return image
    }()
    
    // MARK: - Setups
    
    private func setup() {
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = .ypBlack
        
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImage)
    }
    
    private func setupConstraints() {
        setupLogoImageConstraints()
    }
    
    private func setupLogoImageConstraints() {
        NSLayoutConstraint.activate([
            logoImage.heightAnchor.constraint(equalToConstant: 77),
            logoImage.widthAnchor.constraint(equalToConstant: 75),
            logoImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    // MARK: - Functions
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                self.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
                fetchProfileImage(profile.username)
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print(error)
                break
            }
        }
    }
    
    private func fetchProfileImage(_ username: String) {
        profileImageService.fetchProfileImageURL(username: username) { _ in }
    }
    
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true){ [weak self] in
            guard let self = self else {return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else {return }
            switch result {
            case .success(let token):
                self.storage.token = token
                self.fetchProfile(token)
            case .failure:
                self.showErrorAlert()
            }
        }
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему",
            preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "error"
        
        let action = UIAlertAction(title: "Ок", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
