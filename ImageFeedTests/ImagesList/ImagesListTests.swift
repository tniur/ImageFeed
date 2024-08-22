//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Pavel on 22.08.2024.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    func testCountReturn() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        let count = presenter.getPhotosCount()
        
        //then
        XCTAssertEqual(count, 10)
    }
    
    func testTableViewUpdate() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.fetchNewPhotos()
        
        //then
        XCTAssertTrue(viewController.isTableViewUpdated)
    }
}
