//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Pavel on 05.02.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        
        let userImage = UIImageView(image: UIImage(named: "UserPhoto"))
        let logoutButton = UIButton.systemButton(with: UIImage(named: "logout")!, target: self, action: #selector(self.didTapLogoutButton))
        let userName = UILabel()
        let userLogin = UILabel()
        let userDescription = UILabel()
        
        setUserImageView(userImage)
        setLogoutButton(button: logoutButton, image: userImage)
        setUserName(label: userName, image: userImage)
        setUserLogin(label: userLogin, topLabel: userName)
        setUserDescription(label: userDescription, topLabel: userLogin)
    }
    
    private func setUserImageView(_ image: UIImageView) {
        image.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(image)
        image.heightAnchor.constraint(equalToConstant: 70).isActive = true
        image.widthAnchor.constraint(equalToConstant: 70).isActive = true
        image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        image.topAnchor.constraint(equalTo: view.topAnchor, constant: 76).isActive = true
    }
    
    private func setLogoutButton(button: UIButton, image: UIImageView) {
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.tintColor = .ypRed
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        button.centerYAnchor.constraint(equalTo: image.centerYAnchor).isActive = true
    }
    
    private func setUserName(label: UILabel, image: UIImageView) {
        label.text = "Екатерина Новикова"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.leadingAnchor.constraint(equalTo: image.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 8).isActive = true
    }
    
    private func setUserLogin(label: UILabel, topLabel: UILabel) {
        label.text = "@ekaterina_nov"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.textColor = .ypGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.leadingAnchor.constraint(equalTo: topLabel.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func setUserDescription(label: UILabel, topLabel: UILabel) {
        label.text = "Hello, world!"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.leadingAnchor.constraint(equalTo: topLabel.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    @objc private func didTapLogoutButton() {}
}
