//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Pavel on 05.02.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Views
    
    private let userImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "UserPhoto"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "logout"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .ypRed
        return button
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    
    private let userLoginLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let userDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.translatesAutoresizingMaskIntoConstraints = false
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
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        self.view.backgroundColor = .ypBlack
        self.view.addSubview(userImage)
        self.view.addSubview(logoutButton)
        self.view.addSubview(userNameLabel)
        self.view.addSubview(userLoginLabel)
        self.view.addSubview(userDescriptionLabel)
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
    
    @objc private func didTapLogoutButton() {}
}
