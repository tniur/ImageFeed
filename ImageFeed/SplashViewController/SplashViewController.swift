//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Pavel on 28.07.2024.
//

import UIKit


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
            print("hello")
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
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                fetchProfileImage(profile.username)
                self.switchToTabBarController()
            case .failure(let error):
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
    func didAuthenticate(_ vc: AuthViewController) {
        guard let token = storage.token else {
            return
        }
        
        fetchProfile(token)
        
        vc.dismiss(animated: true)
    }
}
