//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Pavel on 24.07.2024.
//

import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    private var task: URLSessionTask?
    private var lastCode: String?
    
    static let shared = OAuth2Service()
    private init() {}
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        let baseURL = URL(string: "https://unsplash.com")!
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL
        ) else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String,Error>) -> Void) {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.fetchOAuthToken(code: code, completion: completion)
            }
            return
        }
        
        if lastCode == code {
            print("[fetchOAuthToken]: AuthServiceError - \(AuthServiceError.invalidRequest)")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("[fetchOAuthToken]: AuthServiceError - \(AuthServiceError.invalidRequest)")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            
            switch result {
            case .success(let data):
                let token = data.accessToken
                completion(.success(token))
            case .failure(let error):
                print("[fetchOAuthToken]: AuthServiceError - \(error)")
                completion(.failure(error))
            }
            self?.task = nil
            self?.lastCode = nil
        }
        
        self.task = task
        task.resume()
    }
}
