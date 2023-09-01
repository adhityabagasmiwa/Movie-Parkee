//
//  FavoriteViewController.swift
//  Parkee
//
//  Created by Adhitya Bagas on 01/09/23.
//

import UIKit

class FavoriteViewController: UIViewController, TableViewConfigurable {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    private var viewModel = FavoriteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        setupTableView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchMovieList()
    }
}

private extension FavoriteViewController {
    
    private func setupDelegate() {
        viewModel.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Favorite"
    }
    
    private func setupTableView() {
        configureTableView(nibName: "CardListTableViewCell")
    }
    
    private func fetchMovieList() {
        viewModel.fetchMoviesFavorite()
        view.addSpinner()
    }
    
    private func onReloadPage() {
        fetchMovieList()
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

extension FavoriteViewController: FavoriteViewModelDelegate {
    
    func onSuccessDeleteMoviesFavorite(_ viewModel: Bool) {
        showConfirmationSheet(isSuccess: viewModel, title: "Yeaa!!, Berhasil Menghapus dari Favorit")
    }
    
    func onErrorDeleteMoviesFavorite(_ viewModel: FavoriteViewModel, error: DBError) {
        showConfirmationSheet(isSuccess: false, title: "Upss!!, Gagal Menghapus dari Favorit")
    }
    
    func onSuccessGetMoviesFavorite(_ viewModel: FavoriteViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.view.removeSpinner()
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
            self?.emptyView.isHidden = viewModel.movies.count != 0
        }
    }
    
    func onErrorGetMoviesFavorite(_ viewModel: FavoriteViewModel, error: DBError) {
        
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    
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
            self?.viewModel.deleteMoviesFavorite(movie.id)
        }
        cell.onPressCard = { [weak self] in
            let vc = MovieDetailViewController(id: movie.id)
            self?.navigatePushToPage(vc)
        }
        
        return cell
    }
}
