//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Pavel on 22.08.2024.
//

@testable import ImageFeed
import UIKit

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: (any ImageFeed.ImagesListViewControllerProtocol)?
    
    private let count = 10
    
    func getCellHeight(indexPath: IndexPath, tableView: UITableView) -> CGFloat {
        0
    }
    
    func getPhotosCount() -> Int {
        count
    }
    
    func fetchNewPhotos() { 
        view?.updateTableView()
    }
    
    func didTapLike(_ cell: ImageFeed.ImagesListCell, tableView: UITableView) { }
    
    func getPhotos() -> [ImageFeed.Photo] {
        []
    }
    
    func configCell(for cell: ImageFeed.ImagesListCell, with indexPath: IndexPath) { }
    
    func getLargeImageUrl(indexPath: IndexPath) -> URL? {
        nil
    }
    
    func viewDidLoad() { }
}
