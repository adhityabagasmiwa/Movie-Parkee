//
//  APIService.swift
//  Parkee
//
//  Created by Adhitya Bagas on 31/08/23.
//

import Foundation

enum Endpoint: String {
    case movieList = "movie/now_playing/"
    case movie = "movie/"
    case movieSearch = "search/movie"
}

enum ApiURL: String {
    case baseURL = "https://api.themoviedb.org/3/"
    case imageBaseURL = "https://image.tmdb.org/t/p/w500"
}
