//
//  MovieListViewModel.swift
//  Parkee
//
//  Created by Adhitya Bagas on 31/08/23.
//

import Foundation

protocol MovieListViewModelDelegate: AnyObject {
    func onSuccessGetMovieList(_ viewModel: MovieListViewModel)
    func onErrorGetMovieList(_ viewModel: MovieListViewModel, error: APIError)
    
    func onSuccessGetMovieSearch(_ viewModel: MovieListViewModel)
    func onErrorGetMovieSearch(_ viewModel: MovieListViewModel, error: APIError)
    
    func onSuccessSaveMovieToDb(_ viewModel: Bool)
    func onErrorSaveMovieToDb(_ viewModel: MovieListViewModel, error: DBError)
    
    func onSuccessDeleteMoviesFavorite(_ viewModel: Bool)
    func onErrorDeleteMoviesFavorite(_ viewModel: MovieListViewModel, error: DBError)
}

class MovieListViewModel {
    
    let movieInteractor = MovieInteractor()
    let databaseManager = DatabaseManager()
    
    weak var delegate: MovieListViewModelDelegate?
    
    private var language: String = "en-US"
    private var includeAdult: Bool = false
    var query: String = ""
    var page: Int = 1
    
    var movies: [Movie] = [Movie]()
    var moviesFavorite: [Movie] = [Movie]()
    
    func saveMovieToDb(_ movie: Movie) {
        databaseManager.saveMovieToDb(movie: movie, completion: { result in
            switch result {
                case .success(let isSuccess):
                    self.delegate?.onSuccessSaveMovieToDb(isSuccess)
                case .failure(let error):
                    self.delegate?.onErrorSaveMovieToDb(self, error: error)
            }
        })
    }
    
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
        moviesFavorite = []
        
        databaseManager.fetchMovieFromDb(completion: { result in
            switch result {
                case .success(let data):
                    let movies = data
                    movies.forEach { movie in
                        self.moviesFavorite.append(movie)
                    }
                    
                    /// MARK: Mapping Data to Get IsFavorite
                    for (index, movieFavorite) in self.moviesFavorite.enumerated() {
                        if self.movies[index].id == movieFavorite.id {
                            self.movies[index].isFavorite = movieFavorite.isFavorite ?? false
                        }
                    }
                    
                    self.delegate?.onSuccessGetMovieList(self)
                case .failure(_): break
            }
        })
    }
    
    func fetchMovieList() {
        removeAllMovies()
        
        movieInteractor.fetchMovieList(page: page, language: language, completion: { result in
            switch result {
                case .success(let response):
                    let movies = response.results
                    movies.forEach { movie in
                        self.movies.append(movie)
                    }
                    
                    self.fetchMoviesFavorite()
                case .failure(let error):
                    self.delegate?.onErrorGetMovieList(self, error: error)
            }
        })
    }
    
    func fetchSearchMovie(query: String) {
        removeAllMovies()
        
        movieInteractor.fetchSearchMovie(query: query, includeAdult: includeAdult, language: language, page: page, completion: { result in
            switch result {
                case .success(let response):
                    let movies = response.results
                    movies.forEach { movie in
                        self.movies.append(movie)
                    }
                    
                    self.delegate?.onSuccessGetMovieSearch(self)
                case .failure(let error):
                    self.delegate?.onErrorGetMovieSearch(self, error: error)
            }
        })
    }
}

extension MovieListViewModel {
    func removeAllMovies() {
        movies = []
    }
    
    func resetMoviePage() {
        page = 1
    }
}
