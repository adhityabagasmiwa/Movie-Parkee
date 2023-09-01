//
//  MovieListInteractor.swift
//  Parkee
//
//  Created by Adhitya Bagas on 31/08/23.
//

import Foundation

class MovieInteractor {
    let networkManager = NetworkManager()
}

extension MovieInteractor: MovieListInteractorContract {
    
    func fetchMovieList(page: Int, language: String, completion: @escaping ((Result<MovieListResponse, APIError>) -> Void)) {
        let urlString = ApiURL.baseURL.rawValue + Endpoint.movieList.rawValue
        let parameters = [
            "page": page,
            "language": language
        ] as [String: Any]
        
        networkManager.fetchAPI(fromUrl: urlString, forType: MovieListResponse.self, method: .get, parameters: parameters, completion: { result in
            switch result {
                case .success(let response):
                    debugPrint("[LOG - RESPONSE][\(Endpoint.movieList.rawValue)]: ", response)
                    completion(.success(response))
                case .failure(let error):
                    debugPrint("[LOG - ERROR][\(Endpoint.movieList.rawValue)]: ", error)
                    completion(.failure(error))
            }
        })
    }
    
    func fetchMovieDetail(movieId: Int, completion: @escaping ((Result<MovieDetail, APIError>) -> Void)) {
        let urlString = ApiURL.baseURL.rawValue + Endpoint.movie.rawValue + "\(movieId)"
        
        networkManager.fetchAPI(fromUrl: urlString, forType: MovieDetail.self, method: .get, parameters: nil, completion: { result in
            switch result {
                case .success(let response):
                    debugPrint("[LOG - RESPONSE][\(Endpoint.movie.rawValue)]: ", response)
                    completion(.success(response))
                case .failure(let error):
                    debugPrint("[LOG - ERROR][\(Endpoint.movie.rawValue)]: ", error)
                    completion(.failure(error))
            }
        })
    }
    
    func fetchSearchMovie(query: String, includeAdult: Bool, language: String, page: Int, completion: @escaping ((Result<MovieListResponse, APIError>) -> Void)) {
        let urlString = ApiURL.baseURL.rawValue + Endpoint.movieSearch.rawValue
        let parameters = [
            "query": query,
            "page": page,
            "language": language,
            "include_adult": includeAdult
        ] as [String: Any]
        
        networkManager.fetchAPI(fromUrl: urlString, forType: MovieListResponse.self, method: .get, parameters: parameters, completion: { result in
            switch result {
                case .success(let response):
                    debugPrint("[LOG - RESPONSE][\(Endpoint.movieSearch.rawValue)]: ", response)
                    completion(.success(response))
                case .failure(let error):
                    debugPrint("[LOG - ERROR][\(Endpoint.movieSearch.rawValue)]: ", error)
                    completion(.failure(error))
            }
        })
    }
}
