//
//  HomeScreenTableViewController.swift
//  Movies App
//
//  Created by Ivan Ivanušić on 17.10.2022..
//

import UIKit

class HomeScreenTableViewController: UITableViewController {
    let viewModel = HomeScreenViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        self.viewModel.fetchMovies()
        self.configureUI()
    }
    
    func configureUI() {
        self.title = "Movies app"
        
        let barButtonMenu = UIMenu(title: "", children: [
            UIAction(title: NSLocalizedString("Top rated", comment: ""), image: nil, handler: { [weak self] _ in
                self?.viewModel.changeTypeFor(path: .getTopRated(page: 1))
            }),
            UIAction(title: NSLocalizedString("Popular", comment: ""), image: nil, handler: { [weak self] _ in
                self?.viewModel.changeTypeFor(path: .getPopular(page: 1))
            })
        ])
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort", image: nil, primaryAction: nil, menu: barButtonMenu)
        
        self.tableView.register(UINib(nibName: "HomeScreenCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getMoviesCount()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? HomeScreenCell else {
            fatalError("HomeScreenCell not loaded!!!")
        }
        cell.movieLabel.text = self.viewModel.getTitleForMovieAt(indexPath: indexPath)
        cell.movieImage.image = self.viewModel.getPosterFor(indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movieID = self.viewModel.getIdForMovieAt(indexPath: indexPath) else { return }
        let vc = MovieDetailViewController(movieId: movieID)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            self.viewModel.checkAndLoadPage()
        }
    }
}

//MARK: ViewModel delegate methods
extension HomeScreenTableViewController: HomeScreenViewModelDelegate {
    func reloadMovies() {
        self.tableView.reloadData()
        print("Reload data")
    }
    
    func reloadRow(indexPath: IndexPath) {
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        print("Reload row \(indexPath.row)")
    }
}
