//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Pavel on 21.08.2024.
//

@testable import ImageFeed
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: (any ImageFeed.ProfilePresenterProtocol)?
    
    func showAlert(alert: UIAlertController) { }
    
    func updateAvatar() { }
}
