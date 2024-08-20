//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Pavel on 09.08.2024.
//

import Foundation

enum ProfileServiceError: Error {
    case profileNotFound
}

struct ProfileResult: Codable {
    var username: String
    var firstName: String
    var lastName: String?
    var bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

struct Profile {
    var username: String
    var name: String
    var loginName: String
    var bio: String?
    
    init(username: String, firstName: String, lastName: String?, bio: String?) {
        self.username = username
        
        if let lastName {
            name = firstName + " " + lastName
        } else {
            name = firstName
        }
        
        self.loginName = "@" + username
        self.bio = bio
    }
}

final class ProfileService {
    static let shared = ProfileService()
    private init() {}
    
    private let tokenStorage = OAuth2TokenStorage()
    private(set) var profile : Profile?
    
    func cleanProfile() {
        profile = nil
    }
    
    private func makeURLRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        guard let request = makeURLRequest(token: token) else {
            print("Make URLRequest error")
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            
            switch result {
            case .success(let data):
                self?.profile = Profile(username: data.username, firstName: data.firstName, lastName: data.lastName, bio: data.bio)
                
                if let profile = self?.profile {
                    completion(.success(profile))
                } else {
                    completion(.failure(ProfileServiceError.profileNotFound))
                }
            case .failure(let error):
                print("[fetchProfile]: FetchProfileError - \(error)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
