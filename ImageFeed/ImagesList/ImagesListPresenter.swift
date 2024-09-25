//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Pavel on 21.08.2024.
//

import UIKit

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    
    func getCellHeight(indexPath: IndexPath, tableView: UITableView) -> CGFloat
    func getPhotosCount() -> Int
    func fetchNewPhotos()
    func didTapLike(_ cell: ImagesListCell, tableView: UITableView)
    func getPhotos() -> [Photo]
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)
    func getLargeImageUrl(indexPath: IndexPath) -> URL?
    func viewDidLoad()
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    private var imagesListServiceObserver: NSObjectProtocol?
    private let imagesListService = ImagesListService()
    
    func viewDidLoad() {
        setServiceObserver()
        fetchNewPhotos()
    }
    
    func getCellHeight(indexPath: IndexPath, tableView: UITableView) -> CGFloat {
        let image = imagesListService.photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func getPhotos() -> [Photo] {
        return imagesListService.photos
    }
    
    func getPhotosCount() -> Int {
        return imagesListService.photos.count
    }
    
    func fetchNewPhotos() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func didTapLike(_ cell: ImagesListCell, tableView: UITableView) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = imagesListService.photos[indexPath.row]
        UIBlockingProgressHUD.show()
        
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    cell.setIsLiked(!photo.isLiked)
                    UIBlockingProgressHUD.dismiss()
                case .failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    print(error)
                }
            }
        }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = imagesListService.photos[indexPath.row]
        
        guard let url = URL(string: photo.thumbImageURL) else {
            return
        }
        
        cell.configCell(photoUrl: url, isLiked: photo.isLiked, date: photo.createdAt)
    }
    
    func getLargeImageUrl(indexPath: IndexPath) -> URL? {
        guard let url = URL(string: imagesListService.photos[indexPath.row].largeImageURL) else {
            return nil
        }
        return url
    }
    
    func setServiceObserver() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.view?.updateTableView()
        }
    }
}
