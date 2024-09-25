//
//  ProfileTest.swift
//  ImageFeedTests
//
//  Created by Pavel on 21.08.2024.
//

@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    func testViewControllerLogoutButtonTapped() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.logoutButtonTapped()
        
        //then
        XCTAssertTrue(presenter.isLogoutButtonTapped)
    }
    
    func testProfileReturn() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        let result = presenter.getProfile()
        
        //then
        XCTAssertNotNil(result)
    }
}
