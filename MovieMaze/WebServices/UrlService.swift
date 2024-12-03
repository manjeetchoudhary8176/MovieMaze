//
//  WebServices.swift
//  MovieMaze
//
//  Created by manjeet kumar on 01/12/24.
//

import Foundation
import SwiftUI

// /search/movie?api_key=88d56baf37dfec870ae40a0ed9fc701c&query=a&page=1
//enum ApiEndpoints: String {
//    case searchMovies = "/search/movie"
//    case movieDetail = "/api/login2"
//    }

enum ApiEndpoints {
    case searchMovies(query: String, pageNo: Int)
    case movieDetail(movieId: Int)
    
    
    var baseurl: String {
       return Bundle.main.infoDictionary?["BaseUrl"] as? String ?? ""
    }
    private var apiKey: String {
        return Bundle.main.infoDictionary?["ApiKey"] as? String ?? ""
     }
    
    static var imageBaseUrl: String {
        return Bundle.main.infoDictionary?["ImageBaseUrl"] as? String ?? ""
     }
    
    var path: String {
        switch self {
        case .searchMovies(let query, let pageNo):
            return "/search/movie?api_key=\(apiKey)&query=\(query)&page=\(pageNo)"
        case .movieDetail(let movieId):
            return "/movie/\(movieId)"
        }
    }
    
    var url: String {
        return baseurl + path
    }
}

