//
//  NetworkApiClient.swift
//  Movies App
//
//  Created by Ivan Ivanušić on 17.10.2022..
//

import Foundation
import UIKit

class NetworkApiClient {
    static let client = NetworkApiClient()
    
    func getTopRatedAndPopular(type: Path, completion: ((TopRatedAndPopularResponse?) -> Void)?) {
        ApiManager.client.request(.search(for: type)) { (data) in
            DispatchQueue.main.async {
                do {
                    let topRatedReponse = try JSONDecoder().decode(TopRatedAndPopularResponse.self, from: data)
                    completion?(topRatedReponse)
                } catch {
                    completion?(nil)
                }
            }
        }
    }
    
    func getMovieDetails(id: Int, completion: ((MovieDetailsResponse?) -> Void)?) {
        ApiManager.client.request(.search(for: .getMovieDetails(id: id))) { (data) in
            DispatchQueue.main.async {
                do {
                    let movieDetails = try JSONDecoder().decode(MovieDetailsResponse.self, from: data)
                    completion?(movieDetails)
                } catch {
                    completion?(nil)
                }
            }
        }
    }
    
    func getSimilarMovies(id: Int, completion: ((SimilarMoviesResponse?) -> Void)?) {
        ApiManager.client.request(.search(for: .getSimilarMovies(id: id))) { (data) in
            DispatchQueue.main.async {
                do {
                    let similarMovies = try JSONDecoder().decode(SimilarMoviesResponse.self, from: data)
                    completion?(similarMovies)
                } catch {
                    completion?(nil)
                }
            }
        }
    }
    
    func getImageFor(posterID: String, completion: ((UIImage?) -> Void)?) {
        ApiManager.client.request(.search(for: .getImageFor(posterId: posterID))) { (data) in
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                completion?(image)
            }
        }
    }
}
