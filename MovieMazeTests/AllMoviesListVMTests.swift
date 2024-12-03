//
//  AllMoviesListVMTests.swift
//  MovieMazeTests
//
//  Created by manjeet kumar on 02/12/24.
//

import Foundation

import XCTest
@testable import MovieMaze

final class AllMoviesListVMTests: XCTestCase {
    
    var viewModel: AllMoviesListVM!
    var mockApiManager: ApiManager!
    
    override func setUp() {
        super.setUp()
        viewModel = AllMoviesListVM()
        mockApiManager = ApiManager()
        ApiManager.shared = mockApiManager // Inject mock API manager
    }
    
    override func tearDown() {
        viewModel = nil
        mockApiManager = nil
        super.tearDown()
    }
    
    func testGetMoviesListSuccess() {
        // Arrange
        let expectedMovieList = AllMovieList(page: 1, totalPages: 1, totalResults: 1, results: [Result(id: 1, title: "Test Movie", releaseDate: "2024-12-01")])
        mockApiManager.mockResponse = (200, try! JSONEncoder().encode(expectedMovieList), nil)
        
        let expectation = XCTestExpectation(description: "Success callback is invoked")
        
        // Act
        viewModel.getMoviesList(searchText: "Test")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Assert
            XCTAssertEqual(self.viewModel.allMovieList?.results?.count, 1)
            XCTAssertEqual(self.viewModel.allMovieList?.results?.first?.title, "Test Movie")
            XCTAssertNil(self.viewModel.error)
            XCTAssertEqual(self.viewModel.statusCode, 200)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testGetMoviesListFailure() {
        // Arrange
        mockApiManager.mockResponse = (nil, nil, "Network Error")
        
        let expectation = XCTestExpectation(description: "Failure callback is invoked")
        
        // Act
        viewModel.getMoviesList(searchText: "Test")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Assert
            XCTAssertNil(self.viewModel.allMovieList)
            XCTAssertEqual(self.viewModel.error, "Network Error")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testRemoveAllMovieData() {
        // Arrange
        viewModel.allMovieList = AllMovieList(page: 1, totalPages: 1, totalResults: 1, results: [])
        
        let expectation = XCTestExpectation(description: "Movie data is cleared")
        
        // Act
        viewModel.removeAllMovieData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Assert
            XCTAssertNil(self.viewModel.allMovieList)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}
