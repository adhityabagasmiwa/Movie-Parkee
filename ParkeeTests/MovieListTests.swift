//
//  MovieListTests.swift
//  ParkeeTests
//
//  Created by Adhitya Bagas on 01/09/23.
//

import XCTest
@testable import Parkee

class MoviesListTests: XCTestCase {
    
    var sut: MovieListViewModel?
    var mockAPIServiceMovieList: MockAPIServiceMovieList!
    
    override func setUp() {
        super.setUp()
        sut = MovieListViewModel()
        
        mockAPIServiceMovieList = MockAPIServiceMovieList()
        sut?.movies = mockAPIServiceMovieList.movies?.results ?? []
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testFetchMovies() {
        
        // Given A API Model
        let sut = self.sut!
        
        let expect = XCTestExpectation(description: "callback")
        // When
        sut.fetchSearchMovie(query: "")
        expect.fulfill()
        XCTAssertNotEqual(sut.movies.count, 0)
        for movieObject in sut.movies {
            XCTAssertNotNil(movieObject.id)
        }
        
        wait(for: [expect], timeout: 1)
    }
    
}
