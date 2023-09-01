//
//  MockAPIServiceMovieList.swift
//  ParkeeTests
//
//  Created by Adhitya Bagas on 01/09/23.
//

import XCTest
import Alamofire
@testable import Parkee

class MockAPIServiceMovieList: MovieListInteractorContract {
    let networkManager = NetworkManager()
    var movies: MovieListResponse?
    
    func fetchMovieList(page: Int, language: String, completion: @escaping ((Result<Parkee.MovieListResponse, Parkee.APIError>) -> Void)) {
        
        networkManager.fetchAPI(fromUrl: "", forType: Parkee.MovieListResponse.self, method: .get, parameters: nil, completion: { result in
            switch result {
                case .success(_):
                    let jsonData = SwiftUtility.loadJSON(filename: "MovieListJSON")
                    let decoderObject = JSONDecoder()
                    do {
                        self.movies = try decoderObject.decode(Parkee.MovieListResponse.self, from: jsonData)
                        completion(.success(self.movies!))
                    } catch {
                        
                    }
                case .failure(let error):
                    completion(.failure(error))
            }
        })
        
    }
    
    func fetchMovieDetail(movieId: Int, completion: @escaping ((Result<Parkee.MovieDetail, Parkee.APIError>) -> Void)) {
        
    }
    
    func fetchSearchMovie(query: String, includeAdult: Bool, language: String, page: Int, completion: @escaping ((Result<Parkee.MovieListResponse, Parkee.APIError>) -> Void)) {
        
    }
    
}
