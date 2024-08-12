//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Pavel on 05.02.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileService: ProfileService = ProfileService.shared
    
    // MARK: - Views
    
    private let userImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "UserPhoto"))
        image.layer.cornerRadius = 35
        return image
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "logout"), for: .normal)
        button.tintColor = .ypRed
        return button
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    
    private let userLoginLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = .ypGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let userDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setups
    
    private func setup() {
        setupObserver()
        updateAvatar()
        setupView()
        setupConstraints()
        
        guard let profile = profileService.profile else {
            return
        }
        updateProfileDetails(profile: profile)
    }
    
    private func setupObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
    }
    
    private func setupView() {
        view.backgroundColor = .ypBlack
        
        [userImage, logoutButton, userNameLabel, userLoginLabel, userDescriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        setupUserImageConstraints()
        setupLogoutButtonConstraints()
        setupUserNameLabelConstraints()
        setupUserLoginLabelConstraints()
        setupUserDescriptionLabelConstraints()
    }
    
    private func setupActions() {
        logoutButton.addTarget(self, action: #selector(self.didTapLogoutButton), for: .touchUpInside)
    }
    
    private func updateProfileDetails(profile: Profile) {
        userNameLabel.text = profile.name
        userLoginLabel.text = profile.loginName
        userDescriptionLabel.text = profile.bio
    }
    
    // MARK: - Constraints
    
    private func setupUserImageConstraints() {
        NSLayoutConstraint.activate([
            userImage.heightAnchor.constraint(equalToConstant: 70),
            userImage.widthAnchor.constraint(equalToConstant: 70),
            userImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 76)
        ])
    }
    
    private func setupLogoutButtonConstraints() {
        NSLayoutConstraint.activate([
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: userImage.centerYAnchor)
        ])
    }
    
    private func setupUserNameLabelConstraints() {
        NSLayoutConstraint.activate([
            userNameLabel.leadingAnchor.constraint(equalTo: userImage.leadingAnchor),
            userNameLabel.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 8)
        ])
    }
    
    private func setupUserLoginLabelConstraints() {
        NSLayoutConstraint.activate([
            userLoginLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            userLoginLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8)
        ])
    }
    
    private func setupUserDescriptionLabelConstraints() {
        NSLayoutConstraint.activate([
            userDescriptionLabel.leadingAnchor.constraint(equalTo: userLoginLabel.leadingAnchor),
            userDescriptionLabel.topAnchor.constraint(equalTo: userLoginLabel.bottomAnchor, constant: 8)
        ])
    }
    
    // MARK: - Functions
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else {
            return
        }
        
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        userImage.kf.setImage(with: url,
                              placeholder: UIImage(named: "UserPhoto"),
                              options: [.processor(processor)])
    }
    
    @objc private func didTapLogoutButton() {}
}
