//
//  ImageView.swift
//  MovieMaze
//
//  Created by manjeet kumar on 02/12/24.
//

import Foundation
import SwiftUI

struct ImageFromURLView: View {
    
    let imageURL: URL?
    var size: (width:CGFloat, height: CGFloat)
    
    var body: some View {
        AsyncImage(url: imageURL) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            case .success(let image):
                image.resizable()
                    .frame(width: .infinity, height: size.height, alignment: .top)
                    .scaledToFill()
                    .clipped()
            case .failure:
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, maxHeight: size.height)
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: .infinity, height: size.height, alignment: .center)
    }
}

class PaginationHandaler {
    static var pageNumber = 1
    static var isDataLoaded = true
    static var isDataLoading = false
}
