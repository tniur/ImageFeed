//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Pavel on 17.08.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let description: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct PhotoResult: Codable{
    var id: String
    var width: Int
    var height: Int
    var createdAt: String?
    var description: String?
    var isLiked: Bool
    var urls: [String: String]
    
    enum CodingKeys: String, CodingKey{
        case id = "id"
        case width = "width"
        case height = "height"
        case createdAt = "created_at"
        case description = "description"
        case isLiked = "liked_by_user"
        case urls = "urls"
    }
}

struct LikeResult: Codable {
    var photoResult: PhotoResult
    enum CodingKeys: String, CodingKey{
        case photoResult = "photo"
    }
}

struct UrlsResult{
    var full: String
    var thumb: String
}

final class ImagesListService {
    private var task: URLSessionTask?
    private var lastLoadedPage: Int?
    private (set) var photos: [Photo] = []
    
    private let tokenStorage = OAuth2TokenStorage()
    private let dateFormatter = ISO8601DateFormatter()
    private let perPage = 10
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func cleanImages(){
        photos.removeAll()
        lastLoadedPage = nil
    }
    
    func makeFetchPhotosURLRequest(token: String, page: Int) -> URLRequest? {
        var urlComponents = URLComponents(string: "https://api.unsplash.com/photos")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        
        guard let url = urlComponents?.url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }
    
    func makeChangeLikeURLRequest(token: String, id: String, isLike: Bool) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/photos/\(id)/like") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        if isLike {
            request.httpMethod = "DELETE"
        } else {
            request.httpMethod = "POST"
        }
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func fetchPhotosNextPage(){
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        if task != nil {
            return
        }
        
        guard let token = tokenStorage.token,
              let request = makeFetchPhotosURLRequest(token: token, page: nextPage) else {
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            
            switch result {
            case .success(let data):
                
                data.forEach {
                    let urls = $0.urls
                    guard let full = urls["full"],
                          let thumb = urls["thumb"] else {
                        return
                    }
                    let urlsResult = UrlsResult(full: full , thumb: thumb)
                    
                    var date: Date? = nil
                    if let createdAt = $0.createdAt {
                        date = self?.dateFormatter.date(from: createdAt)
                    }
                    
                    let photo = Photo(id: $0.id, size: CGSize(width: $0.width, height: $0.height), createdAt: date, description: $0.description, thumbImageURL: urlsResult.thumb, largeImageURL: urlsResult.full, isLiked: $0.isLiked)
                    self?.photos.append(photo)
                }
                
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                self?.lastLoadedPage = nextPage
                
            case .failure(let error):
                print("[fetchPhotosNextPage]: FetchPhotosNextPageError - \(error)")
            }
            
            self?.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let token = tokenStorage.token,
              let request = makeChangeLikeURLRequest(token: token, id: photoId, isLike: isLike) else {
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            
            switch result {
            case .success(let data):
                
                let photoResult = data.photoResult
                
                let urls = data.photoResult.urls
                guard let full = urls["full"],
                      let thumb = urls["thumb"] else {
                    return
                }
                let urlsResult = UrlsResult(full: full , thumb: thumb)
                
                var date: Date? = nil
                if let createdAt = photoResult.createdAt {
                    date = self?.dateFormatter.date(from: createdAt)
                }
                
                let changedPhoto = Photo(id: photoResult.id, size: CGSize(width: photoResult.width, height: photoResult.height), createdAt: date, description: photoResult.description, thumbImageURL: urlsResult.thumb, largeImageURL: urlsResult.full, isLiked: photoResult.isLiked)
                
                if let index = self?.photos.firstIndex(where: { $0.id == photoId }) {
                    DispatchQueue.main.async{
                        self?.photos[index] = changedPhoto
                    }
                }
                
                completion(.success(Void()))
            case .failure(let error):
                print("[changeLike]: ChangeLike - \(error)")
                completion(.failure(error))
            }
            
        }
        
        task.resume()
    }
}
