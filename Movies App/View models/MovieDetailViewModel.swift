//
//  MovieDetailViewModel.swift
//  Movies App
//
//  Created by Ivan Ivanušić on 17.10.2022..
//

import Foundation
import UIKit

protocol MovieDetailViewModelDelegate: AnyObject {
    func reloadMovieDetails(movie: MovieDetailsResponse?)
    func setCoverImage(image: UIImage)
    func setPosterImage(image: UIImage)
    func reloadCollectionViewCell(indexPath: IndexPath)
    func reloadCollectionViewData()
}

class MovieDetailViewModel: NSObject {
    weak var delegate: MovieDetailViewModelDelegate?
    
    private var similarMovies = [SimilarMovie]()
    private var posters: [String : UIImage] = [:]
    
    override init() {
        super.init()
    }
    
    //MARK: Private methods
    private func getCoverImage(id: String) {
        NetworkApiClient.client.getImageFor(posterID: id) { [weak self] image in
            guard let imageUnwrapped = image else { return }
            self?.delegate?.setCoverImage(image: imageUnwrapped)
        }
    }
    
    private func getPosterImage(id: String) {
        NetworkApiClient.client.getImageFor(posterID: id) { [weak self] image in
            guard let imageUnwrapped = image else { return }
            self?.delegate?.setPosterImage(image: imageUnwrapped)
        }
    }
    
    private func getSimilarMovies(id: Int) {
        NetworkApiClient.client.getSimilarMovies(id: id) { [weak self] similarMoviesResponse in
            guard let similarMoviesUnwrapped = similarMoviesResponse?.results else { return }
            self?.similarMovies = similarMoviesUnwrapped
            self?.delegate?.reloadCollectionViewData()
        }
    }
    
    //MARK: Public methods
    func getMovieDetailsFor(movieId: Int) {
        NetworkApiClient.client.getMovieDetails(id: movieId) { [weak self] movieDetailResponse in
            guard let movieDetailUnwrapped = movieDetailResponse else { return }
            self?.delegate?.reloadMovieDetails(movie: movieDetailUnwrapped)
            if let backdropPath = movieDetailUnwrapped.backdropPath {
                self?.getCoverImage(id: backdropPath)
            }
            if let posterPath = movieDetailUnwrapped.posterPath {
                self?.getPosterImage(id: posterPath)
            }
            self?.getSimilarMovies(id: movieDetailUnwrapped.id)
        }
    }
    
    func getIdForMovieAt(indexPath: IndexPath) -> Int? {
        if self.similarMovies.count > indexPath.row {
            return self.similarMovies[indexPath.row].id
        }
         return nil
    }
    
    func getPosterForSimilarMovie(indexPath: IndexPath) -> UIImage? {
        if self.similarMovies.count > indexPath.row {
            let movie = self.similarMovies[indexPath.row]
            guard let posterPath = movie.posterPath else { return nil }
            if let poster = posters[posterPath] {
                return poster
            } else {
                NetworkApiClient.client.getImageFor(posterID: posterPath) { [weak self] image in
                    self?.posters[posterPath] = image
                    self?.delegate?.reloadCollectionViewCell(indexPath: indexPath)
                }
            }
        }
        return nil
    }
    
    func getSimilarMoviesCount() -> Int {
        return similarMovies.count
    }
}
