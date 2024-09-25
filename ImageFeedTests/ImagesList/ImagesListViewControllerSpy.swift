//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Pavel on 22.08.2024.
//

@testable import ImageFeed
import Foundation

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: (any ImageFeed.ImagesListPresenterProtocol)!
    
    var isTableViewUpdated: Bool = false
    
    func updateTableView() {
        isTableViewUpdated = true
    }
}
