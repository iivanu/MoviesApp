//
//  NetworkApiManager.swift
//  Movies App
//
//  Created by Ivan Ivanušić on 17.10.2022..
//

import Foundation

enum Path {
    case getTopRated(page: Int)
    case getPopular(page: Int)
    case getMovieDetails(id: Int)
    case getSimilarMovies(id: Int)
    case getImageFor(posterId: String)
}

enum HTTPMethod: String {
    case get
    var string: String {
        switch self {
        case .get:
            return "GET"
        }
    }
}

enum ContentType: String {
    case json = "application/json"
}

struct Endpoint {
    let path: Path
    let method: HTTPMethod
    let accept: ContentType
    var queryItems: [URLQueryItem]
    
    static func search(for path: Path) -> Endpoint {
        switch path {
        case .getTopRated(page: let page), .getPopular(page: let page):
            return Endpoint(
                path: path,
                method: .get,
                accept: .json,
                queryItems: [URLQueryItem(name: "api_key", value: "7c85d5dba97737369346d19801142233"),
                            URLQueryItem(name: "page", value: "\(page)")])
        case .getMovieDetails(id: _), .getSimilarMovies(id: _):
            return Endpoint(
                path: path,
                method: .get,
                accept: .json,
                queryItems: [URLQueryItem(name: "api_key", value: "7c85d5dba97737369346d19801142233")])
        case .getImageFor(posterId: _):
            return Endpoint(
                path: path,
                method: .get,
                accept: .json,
                queryItems: [])
        }
    }
    
    var url: URL? {
        var components = URLComponents()
        switch path {
        case .getTopRated:
            components.scheme = "https"
            components.host = "api.themoviedb.org"
            components.path = "/3/movie/top_rated"
        case .getPopular:
            components.scheme = "https"
            components.host = "api.themoviedb.org"
            components.path = "/3/movie/popular"
        case .getMovieDetails(id: let id):
            components.scheme = "https"
            components.host = "api.themoviedb.org"
            components.path = "/3/movie/\(id)"
        case .getSimilarMovies(id: let id):
            components.scheme = "https"
            components.host = "api.themoviedb.org"
            components.path = "/3/movie/\(id)/similar"
        case .getImageFor(posterId: let id):
            components.scheme = "https"
            components.host = "image.tmdb.org"
            components.path = "/t/p/w400\(id)"
        }
        
        components.queryItems = queryItems
        
        return components.url
    }
}

class ApiManager {
    static var client = ApiManager()
    
    func request(_ endpoint: Endpoint, handler: @escaping ((Data) -> Void)) {
        guard let url = endpoint.url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.string
        request.setValue(endpoint.accept.rawValue, forHTTPHeaderField: "Accept")
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadRevalidatingCacheData
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { data, urlResponse, error in
            if let errorUnwrapped = error {
                print("Error: \(errorUnwrapped.localizedDescription)")
                return
            }
            
            if let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Response code: \(httpResponse.statusCode)")
                return
            }
            
            guard let dataUnwrapped = data else {
                fatalError("Data should not be empty, impossible scenario!")
            }
            
            handler(dataUnwrapped)
        }
        task.resume()
    }
}
