//
//  MovieDetailViewController.swift
//  Movies App
//
//  Created by Ivan Ivanušić on 17.10.2022..
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var overviewTextVIew: UITextView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var similarMoviesCollectionView: UICollectionView!
    
    var viewModel = MovieDetailViewModel()
    let movieId: Int
    
    init(movieId: Int) {
        self.movieId = movieId
        super.init(nibName: "MovieDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.similarMoviesCollectionView.delegate = self
        self.similarMoviesCollectionView.dataSource = self
        self.viewModel.delegate = self
        
        self.similarMoviesCollectionView.register(UINib(nibName: "SimilarMovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.viewModel.getMovieDetailsFor(movieId: movieId)
    }
}

//MARK: CollectionView methods
extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.getSimilarMoviesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.similarMoviesCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? SimilarMovieCollectionViewCell else {
            fatalError("SimilarMovieCollectionViewCell not found!!!")
        }
        
        cell.moviePosterImageView.image = self.viewModel.getPosterForSimilarMovie(indexPath: indexPath)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movieID = self.viewModel.getIdForMovieAt(indexPath: indexPath) else { return }
        let vc = MovieDetailViewController(movieId: movieID)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: ViewModel delegate methods
extension MovieDetailViewController: MovieDetailViewModelDelegate {
    func reloadCollectionViewCell(indexPath: IndexPath) {
        self.similarMoviesCollectionView.reloadItems(at: [indexPath])
        print("Reload item at \(indexPath.row)")
    }
    
    func reloadCollectionViewData() {
        self.similarMoviesCollectionView.reloadData()
        print("Reload data")
    }
    
    func reloadMovieDetails(movie: MovieDetailsResponse?) {
        self.movieTitleLabel.text = movie?.title
        self.releaseDateLabel.text = movie?.releaseDate
        let array = movie?.genres.map{ $0.name }
        self.genresLabel.text = array?.joined(separator: ", ")
        self.overviewTextVIew.text = movie?.overview
    }
    
    func setPosterImage(image: UIImage) {
        self.posterImageView.image = image
    }
    
    func setCoverImage(image: UIImage) {
        self.coverImageView.image = image
    }
}
