//
//  MovieDetail.swift
//  MovieMaze
//
//  Created by manjeet kumar on 01/12/24.
//

import SwiftUI

struct MovieDetail: View {
    
    var movieDetails: Result?
    var isFavorite: Bool
    
    var body: some View {
        VStack{
            GeometryReader{ geo in
                VStack{
                    HeaderView(title: movieDetails?.title ?? "")
                    ScrollView(showsIndicators: false){
                        VStack{
                            ZStack(alignment: .topTrailing) {
                                ImageFromURLView(imageURL: movieDetails?.imageURL, size: (geo.size.width, 300))
                                
                                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                                        .resizable()
                                        .frame(width: 30, height: 30, alignment: .center)
                                        .foregroundColor(isFavorite ? .red : .gray)
                                        .padding(.top, 10)
                                        .padding(.trailing, 10)
                            }
                            .frame(maxWidth: .infinity, maxHeight: 300, alignment: .topTrailing)
                            
                            VStack(alignment: .leading, spacing: 10){
                                let movie = "Movie Name: \(movieDetails?.title ?? "")"
                               
                                    Text(movie)
                                        .font(.headline)
                                        .fixedSize(horizontal: false, vertical: false)
                                    Text("Language: \(movieDetails?.originalLanguage ?? "")")
                                        .font(.headline)
                                        .fixedSize(horizontal: false, vertical: false)
                                
                                Text("Released: \(movieDetails?.releaseDate ?? "")")
                                    .font(.subheadline)
                                Text("Detail: \(movieDetails?.overview ?? "")")
                                    .font(.subheadline)
                                
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .padding([.vertical, .horizontal], 20)
                        }
                    }
                    .frame(width: geo.size.width, alignment: .top)
                   
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden()
    }
}
