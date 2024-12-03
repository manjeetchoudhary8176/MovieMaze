//
//  LoaderView.swift
//  MovieMaze
//
//  Created by manjeet kumar on 01/12/24.
//

import SwiftUI

struct LoaderView: View {
    var body: some View {
        HStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
                .padding()
            Text("Loading...")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: 30)
    }
}
