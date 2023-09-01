//
//  FavoriteViewModel.swift
//  Parkee
//
//  Created by Adhitya Bagas on 01/09/23.
//

import Foundation

protocol FavoriteViewModelDelegate: AnyObject {
    func onSuccessGetMoviesFavorite(_ viewModel: FavoriteViewModel)
    func onErrorGetMoviesFavorite(_ viewModel: FavoriteViewModel, error: DBError)
    
    func onSuccessDeleteMoviesFavorite(_ viewModel: Bool)
    func onErrorDeleteMoviesFavorite(_ viewModel: FavoriteViewModel, error: DBError)
}

class FavoriteViewModel {
    
    let databaseManager = DatabaseManager()
    
    weak var delegate: FavoriteViewModelDelegate?
    
    var movies: [Movie] = [Movie]()
    
    func deleteMoviesFavorite(_ movieId: Int) {
        databaseManager.deleteMovieFromDb(movieId: movieId, completion: { result in
            switch result {
                case .success(let isSuccess):
                    self.delegate?.onSuccessDeleteMoviesFavorite(isSuccess)
                case .failure(let error):
                    self.delegate?.onErrorDeleteMoviesFavorite(self, error: error)
            }
        })
    }
    
    func fetchMoviesFavorite() {
        movies = []
        
        databaseManager.fetchMovieFromDb(completion: { result in
            switch result {
                case .success(let data):
                    let movies = data
                    movies.forEach { movie in
                        self.movies.append(movie)
                    }
                    
                    self.delegate?.onSuccessGetMoviesFavorite(self)
                case .failure(let error):
                    self.delegate?.onErrorGetMoviesFavorite(self, error: error)
            }
        })
    }
}
