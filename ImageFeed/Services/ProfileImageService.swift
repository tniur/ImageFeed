//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Pavel on 09.08.2024.
//

import Foundation

enum ProfileImageServiceError:Error {
    case invalidRequest
}

struct UserResult: Codable{
    var image: [String: String]
    
    enum CodingKeys: String, CodingKey{
        case image = "profile_image"
    }
}

final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private let tokenStorage = OAuth2TokenStorage()
    
    private (set) var avatarURL: String?
    
    func cleanImage() {
        avatarURL = nil
    }
    
    private func makeURLRequest(token: String, username: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        guard let token = tokenStorage.token else {
            return
        }
        
        guard let request = makeURLRequest(token: token, username: username) else {
            print("Make URLRequest error")
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            
            switch result {
            case .success(let data):
                self?.avatarURL = data.image["small"]
                
                if let url = self?.avatarURL {
                    completion(.success(url))
                    
                    NotificationCenter.default
                        .post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": url])
                }
            case .failure(let error):
                print("[fetchProfileImage]: FetchProfileImageError - \(error)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
