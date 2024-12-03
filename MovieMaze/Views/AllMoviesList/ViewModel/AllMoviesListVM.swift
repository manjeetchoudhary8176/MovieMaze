//
//  AllMoviesListVM.swift
//  MovieMaze
//
//  Created by manjeet kumar on 01/12/24.
//

import Foundation

class AllMoviesListVM: ObservableObject {
    
    @Published var error: String?
    @Published var statusCode: Int?
    @Published var allMovieList: AllMovieList?
    
    func getMoviesList(searchText: String, pageNo: Int = 1) {
        guard let searchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        let url = ApiEndpoints.searchMovies(query: searchText, pageNo: pageNo).url
        
        ApiManager.shared.requestGET(url: url) { statusCode, result, error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.statusCode = statusCode
                guard let data = result else {
                    self.error = error
                    return
                }
                
                do {
                    let movieData = try JSONDecoder().decode(AllMovieList.self, from: data)
                    if pageNo == 1 {
                        self.allMovieList = movieData
                    }else{
                        self.allMovieList?.page = movieData.page
                        self.allMovieList?.totalPages = movieData.totalPages
                        self.allMovieList?.totalResults = movieData.totalResults
                        self.allMovieList?.results?.append(contentsOf: movieData.results ?? [])
                    }
                } catch let error {
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    func removeAllMovieData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.allMovieList = nil
        }
    }
    
}
