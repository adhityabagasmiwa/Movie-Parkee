//
//  MovieListInteractorContract.swift
//  Parkee
//
//  Created by Adhitya Bagas on 31/08/23.
//

import Foundation

protocol MovieListInteractorContract {
    func fetchMovieList(page: Int, language: String, completion : @escaping ((Result<MovieListResponse, APIError>)->Void))
    func fetchMovieDetail(movieId: Int, completion : @escaping ((Result<MovieDetail, APIError>)->Void))
    func fetchSearchMovie(query: String, includeAdult: Bool, language: String, page: Int, completion : @escaping ((Result<MovieListResponse, APIError>)->Void))
}
