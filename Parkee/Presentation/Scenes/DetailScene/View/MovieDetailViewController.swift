//
//  MovieDetailViewController.swift
//  Parkee
//
//  Created by Adhitya Bagas on 31/08/23.
//

import UIKit

class MovieDetailViewController: UIViewController, UIScrollViewDelegate, CollectionViewConfigurable {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sypnosisLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var genresView: UIView!
    
    private var viewModel = MovieDetailViewModel()
    private var refreshControl = UIRefreshControl()
    private var movieId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        setupScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showHideSpinner(true)
    }
    
    init(id: Int) {
        super.init(nibName: nil, bundle: nil)
        
        movieId = id
        fetchData(id: id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MovieDetailViewController {
    
    @objc func didPullToRefresh(_ sender : UIRefreshControl) {
        showHideSpinner(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.fetchData(id: self?.movieId ?? 0)
        }
    }
    
    private func setupDelegate() {
        configurableCollectionView(nibName: "ChipCollectionViewCell")
        viewModel.delegate = self
        scrollView.delegate = self
    }
    
    private func setupScrollView() {
        scrollView.refreshControl = refreshControl
        scrollView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
    }
    
    private func fetchData(id: Int) {
        viewModel.fetchMovieDetail(id: id)
    }
    
    private func setData(_ data: MovieDetail) {
        titleLabel.text = data.title
        sypnosisLabel.text = data.overview
        
        let url = URL(string: ApiURL.imageBaseURL.rawValue + (data.posterPath ?? ""))
        posterImageView.kf.setImage(with: url)
    }
    
    private func showHideSpinner(_ isLoading: Bool) {
        mainView.isHidden = isLoading
        
        if isLoading {
            view.addSpinner()
        } else {
            view.removeSpinner()
        }
    }
}

extension MovieDetailViewController: MovieDetailViewModelDelegate {
    
    func onSuccessGetMovieDetail(_ viewModel: MovieDetailViewModel) {
        DispatchQueue.main.async { [weak self] in
            if let data = viewModel.movie {
                self?.setData(data)
                self?.showHideSpinner(false)
                self?.scrollView?.refreshControl?.endRefreshing()
                self?.collectionView.reloadData()
                self?.genresView.isHidden = data.genres.count == 0
            }
            
        }
    }
    
    func onErrorGetMovieDetail(_ viewModel: MovieDetailViewModel, error: APIError) {
        
    }
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movie?.genres.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChipCollectionViewCell", for: indexPath) as! ChipCollectionViewCell
        
        guard let genres = viewModel.movie?.genres else { return cell }
        let genre = genres[indexPath.row]
        cell.setData(genre.name)
        
        return cell
    }
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let genres = viewModel.movie?.genres else { return CGSize(width: 0, height: 36) }
        let genre = genres[indexPath.row]
        
        let text = genre.name
        let width = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 10)]).width + 24
        
        return CGSize(width: width, height: 36)
    }
}
