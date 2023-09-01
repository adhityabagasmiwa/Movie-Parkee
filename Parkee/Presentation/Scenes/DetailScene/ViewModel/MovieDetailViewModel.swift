//
//  MovieDetailViewModel.swift
//  Parkee
//
//  Created by Adhitya Bagas on 31/08/23.
//

import Foundation

protocol MovieDetailViewModelDelegate: AnyObject {
    func onSuccessGetMovieDetail(_ viewModel: MovieDetailViewModel)
    func onErrorGetMovieDetail(_ viewModel: MovieDetailViewModel, error: APIError)
}

class MovieDetailViewModel {
    
    let movieInteractor = MovieInteractor()
    
    weak var delegate: MovieDetailViewModelDelegate?
    
    var movie: MovieDetail?
    
    func fetchMovieDetail(id: Int) {
        movieInteractor.fetchMovieDetail(movieId: id, completion: { result in
            switch result {
                case .success(let response):
                    self.movie = response
                    self.delegate?.onSuccessGetMovieDetail(self)
                case .failure(let error):
                    self.delegate?.onErrorGetMovieDetail(self, error: error)
            }
        })
    }
}
