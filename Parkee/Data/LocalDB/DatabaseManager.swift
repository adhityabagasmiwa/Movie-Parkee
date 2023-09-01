//
//  DatabaseManager.swift
//  Parkee
//
//  Created by Adhitya Bagas on 01/09/23.
//

import Foundation
import UIKit
import CoreData

class DatabaseManager: NSObject {
    
    func saveMovieToDb(movie: Movie, completion: @escaping ((Result<Bool, DBError>) -> Void)) {
        let context = CoreDataStack.persistentContainer.viewContext
        let newMovie = MovieDB(context: context)
        
        newMovie.id = Int64(movie.id)
        newMovie.name = movie.title
        newMovie.voteAverage = movie.voteAverage
        newMovie.posterPath = movie.posterPath
        newMovie.isFavorite = true
        
        CoreDataStack.saveContext(completion: { result in
            switch result {
                case .success(let isSuccess):
                    completion(.success(isSuccess))
                case .failure(let error):
                    completion(.failure(error))
            }
        })
    }
    
    func fetchMovieFromDb(completion: @escaping ((Result<[Movie], DBError>) -> Void)) {
        let context = CoreDataStack.persistentContainer.viewContext
        var movies = [Movie]()
        
        do {
            let moviesDb: [MovieDB] = try context.fetch(MovieDB.fetchRequest())
            if moviesDb.count > 0 {
                for movie in moviesDb {
                    let data = Movie(
                        adult: false,
                        backdropPath: "",
                        genreIds: [],
                        id: Int(movie.id),
                        originalLanguage: "",
                        originalTitle: "",
                        overview: "",
                        popularity: 0.0,
                        posterPath: movie.posterPath,
                        releaseDate: "",
                        title: movie.name ?? "",
                        video: false,
                        voteAverage: movie.voteAverage,
                        voteCount: 0,
                        isFavorite: movie.isFavorite
                    )
                    movies.append(data)
                }
            }
            completion(.success(movies))
        } catch let error {
            debugPrint("[LOG - ERROR GET COREDATA]: ", error)
            completion(.failure(.invalidData))
        }
    }
    
    func deleteMovieFromDb(movieId: Int, completion: @escaping ((Result<Bool, DBError>) -> Void)) {
        let context = CoreDataStack.persistentContainer.viewContext
        
        do {
            let moviesDb: [MovieDB] = try context.fetch(MovieDB.fetchRequest())
            
            if moviesDb.count > 0 && moviesDb.contains(where: { $0.id == movieId }) {
                if let movie = moviesDb.first(where: { $0.id == movieId }) {
                    context.delete(movie)
                    completion(.success(true))
                }
            }
        } catch let error {
            debugPrint("[LOG - ERROR DELETE COREDATA]: ", error)
            completion(.failure(.invalidData))
        }
    }
}
