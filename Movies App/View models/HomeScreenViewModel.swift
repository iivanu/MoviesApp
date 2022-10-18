//
//  HomeScreenViewModel.swift
//  Movies App
//
//  Created by Ivan Ivanušić on 17.10.2022..
//

import Foundation
import UIKit

protocol HomeScreenViewModelDelegate: AnyObject {
    func reloadMovies()
    func reloadRow(indexPath: IndexPath)
}

class HomeScreenViewModel: NSObject {
    weak var delegate: HomeScreenViewModelDelegate?
    
    private var movies = [TopRatedMovie]()
    private var posters: [String : UIImage] = [:]
    
    private var type = Path.getTopRated(page: 1) {
        didSet {
            fetchMovies()
        }
    }
    private var lastPage = 1
    private var isLoading = true
    
    override init() {
        super.init()
    }
    
    //MARK: Public methods
    func fetchMovies() {
        NetworkApiClient.client.getTopRatedAndPopular(type: type) { [weak self] response in
            if let reponseUnwrapped = response {
                if self?.lastPage == 1 {
                    self?.movies = reponseUnwrapped.results
                } else {
                    self?.movies.append(contentsOf: reponseUnwrapped.results)
                }
                print("Loaded page \(self?.lastPage ?? 0)")
                self?.delegate?.reloadMovies()
                self?.isLoading = false
            }
        }
    }
    
    func changeTypeFor(path: Path) {
        self.posters.removeAll()
        self.lastPage = 1
        self.isLoading = true
        self.type = path
    }
    
    func getPosterFor(indexPath: IndexPath) -> UIImage? {
        if self.movies.count > indexPath.row {
            let movie = self.movies[indexPath.row]
            guard let posterPath = movie.posterPath else { return nil }
            if let poster = self.posters[posterPath] {
                return poster
            } else {
                NetworkApiClient.client.getImageFor(posterID: posterPath) { [weak self] image in
                    self?.posters[posterPath] = image
                    self?.delegate?.reloadRow(indexPath: indexPath)
                }
            }
        }
        
        return nil
    }
    
    func getTitleForMovieAt(indexPath: IndexPath) -> String? {
        if self.movies.count > indexPath.row {
            return self.movies[indexPath.row].title
        }
        return nil
    }
    
    func getIdForMovieAt(indexPath: IndexPath) -> Int? {
        if self.movies.count > indexPath.row {
            return self.movies[indexPath.row].id
        }
        return nil
    }
    
    func getMoviesCount() -> Int {
        return self.movies.count
    }
    
    func checkAndLoadPage() {
        if !self.isLoading {
            self.isLoading = true
            self.lastPage = lastPage + 1
            switch self.type {
            case .getTopRated(page: _):
                self.type = .getTopRated(page: lastPage)
            case .getPopular(page: _):
                self.type = .getPopular(page: lastPage)
            default:
                return
            }
        }
    }
}
