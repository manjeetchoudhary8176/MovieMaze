//
//  EmptyView.swift
//  MovieMaze
//
//  Created by manjeet kumar on 02/12/24.
//

import SwiftUI

struct ResultNotFoundView: View {
    
    var width: CGFloat = 50
    var height: CGFloat = 50
    var showForSearch: Bool
    
    var body: some View {
       
        Text(showForSearch ?  "Search for Movie" : "Result not found")
            .frame(maxWidth: .infinity, maxHeight: height)
    }
}
