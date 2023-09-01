//
//  MainViewController.swift
//  Parkee
//
//  Created by Adhitya Bagas on 31/08/23.
//

import UIKit

class MainViewController: UIViewController, TableViewConfigurable {
    
    @IBOutlet weak var searchBarMain: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel = MovieListViewModel()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchMovieList()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func onPressFavoriteButton(_ sender: Any) {
        let vc = FavoriteViewController()
        navigatePushToPage(vc)
    }
}

private extension MainViewController {
    
    @objc func didPullToRefresh(_ sender : UIRefreshControl) {
        view.addSpinner()
        viewModel.removeAllMovies()
        tableView.reloadData()
        viewModel.resetMoviePage()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            if self?.viewModel.query != "" {
                self?.viewModel.fetchSearchMovie(query: self?.viewModel.query ?? "")
            } else {
                self?.viewModel.fetchMovieList()
            }
        }
    }
    
    private func setupDelegate() {
        viewModel.delegate = self
        searchBarMain.delegate = self
    }
    
    private func setupTableView() {
        configureTableView(nibName: "CardListTableViewCell")
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
    }
    
    private func fetchMovieList() {
        viewModel.fetchMovieList()
        view.addSpinner()
    }
    
    private func fetchMovieSearch(query: String) {
        if query != "" {
            viewModel.fetchSearchMovie(query: query)
        } else {
            fetchMovieList()
        }
    }
    
    private func onReloadPage() {
        fetchMovieSearch(query: viewModel.query)
        dismiss(animated: true)
    }
    
    private func showConfirmationSheet(isSuccess: Bool, title: String) {
        let vc = ConfirmationSheetViewController()
        vc.isSuccess = isSuccess
        vc.setTitleLabel = title
        vc.onPressReloadPage = onReloadPage
        showBottomSheet(controller: vc, sizes: [.fixed(340)], dismissOnPull: false, dismissOnOverlayTap: false)
    }
}

extension MainViewController: MovieListViewModelDelegate {
    
    func onSuccessDeleteMoviesFavorite(_ viewModel: Bool) {
        showConfirmationSheet(isSuccess: viewModel, title: "Yeaa!!, Berhasil Menghapus dari Favorit")
    }
    
    func onErrorDeleteMoviesFavorite(_ viewModel: MovieListViewModel, error: DBError) {
        showConfirmationSheet(isSuccess: false, title: "Upss!!, Gagal Menghapus dari Favorit")
    }
    
    func onSuccessSaveMovieToDb(_ viewModel: Bool) {
        showConfirmationSheet(isSuccess: viewModel, title: "Yeaa!!, Berhasil Menambahkan ke Favorit")
    }
    
    func onErrorSaveMovieToDb(_ viewModel: MovieListViewModel, error: DBError) {
        showConfirmationSheet(isSuccess: false, title: "Upss!!, Gagal Menambahkan ke Favorit")
    }
    
    func onSuccessGetMovieList(_ viewModel: MovieListViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.view.removeSpinner()
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        }
    }
    
    func onErrorGetMovieList(_ viewModel: MovieListViewModel, error: APIError) {
        
    }
    
    func onSuccessGetMovieSearch(_ viewModel: MovieListViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.view.removeSpinner()
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        }
    }
    
    func onErrorGetMovieSearch(_ viewModel: MovieListViewModel, error: APIError) {
        
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardListTableViewCell", for: indexPath) as! CardListTableViewCell
        
        let movie = viewModel.movies[indexPath.row]
        cell.setData(movie)
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = .zero
        cell.onPressFavorite = { [weak self] in
            if movie.isFavorite ?? false {
                self?.viewModel.deleteMoviesFavorite(movie.id)
            } else {
                self?.viewModel.saveMovieToDb(movie)
            }
        }
        cell.onPressCard = { [weak self] in
            let vc = MovieDetailViewController(id: movie.id)
            self?.navigatePushToPage(vc)
        }
        
        return cell
    }
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.query = searchBar.text ?? ""
        fetchMovieSearch(query: viewModel.query)
    }
}
