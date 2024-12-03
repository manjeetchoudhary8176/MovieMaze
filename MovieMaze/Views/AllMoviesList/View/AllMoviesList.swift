//
//  ContentView.swift
//  MovieMaze
//
//  Created by manjeet kumar on 01/12/24.
//

import SwiftUI
import CoreData

struct AllMoviesList: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavoritesMovies.movieId, ascending: true)], animation: .default)
    
    private var favoriteMovies: FetchedResults<FavoritesMovies>
    
    @StateObject var allMoviesListVM = AllMoviesListVM()
    @State var showPaginationLoader = false
    @State private var searchText: String = ""
    @State var showAlert: Bool = false
    @State var error: String = "An unknown error occurred."
    @State var moveToDetailsPage = false
    @State var seletedMovieData: Result?
    @State var showLoaderForSearching = false
    
    var body: some View {
        
        GeometryReader { geo in
            VStack(spacing: 8) {
                self.searchView()
                
                self.movieListView()
            }
            .padding(.horizontal, 20)
        }
        .onChange(of: searchText) { newValue in
            self.searchMovies(query: newValue)
        }
        .onReceive(allMoviesListVM.$error) { error in
            if let errorFound =  error {
                PaginationHandaler.isDataLoaded = true
                PaginationHandaler.isDataLoading = false
                self.error = errorFound
                showAlert = true
            }
        }
        .onReceive(allMoviesListVM.$allMovieList, perform: { allMovieList in
            if allMovieList != nil {
                setDataAfterResponse(page: allMovieList?.page)
            }
        })
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(self.error),
                dismissButton: .default(Text("OK")) {
                    self.showAlert = false
                    
                    self.showPaginationLoader = false
                }
            )
        }
        .onChange(of: showAlert) {  newValue in
            if newValue {
                self.showPaginationLoader = false
            }
        }
        .navigationDestination(isPresented: $moveToDetailsPage) {
            MovieDetail(movieDetails: seletedMovieData, isFavorite: isFavorite(movieId: seletedMovieData?.id))
        }
    }
}

// MARK: All ViewBuilder Function
extension AllMoviesList {
    
    @ViewBuilder
    func searchView() -> some View {
        TextField("Search for movies...", text: $searchText)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )
    }
    
    @ViewBuilder
    func movieListView() -> some View {
        
        if let allMovieData = allMoviesListVM.allMovieList?.results, allMovieData.count > 0, !self.showLoaderForSearching  {
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading,spacing: 8) {
                    ForEach(0..<allMovieData.count, id: \.self) { cellIndex in
                        let movieData = allMovieData[cellIndex]
                        LazyVStack(alignment: .leading) {
                          
                            self.movieCardView(movieData: movieData, cellIndex: cellIndex, totalMovie: allMovieData.count)
                        }
                        .onTapGesture {
                            DispatchQueue.main.async {
                                self.seletedMovieData = movieData
                                moveToDetailsPage = true
                            }
                        }
                    }
                    if showPaginationLoader {
                        LoaderView()
                    }
                }
            }
            .padding(.top, 20)
        } else {
            self.emptyView()
        }
    }
    
    @ViewBuilder
    func emptyView() -> some View {
        VStack {
            if showLoaderForSearching {
                LoaderView()
            } else {
                ResultNotFoundView(showForSearch: searchText.isEmpty)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    func movieCardView(movieData: Result, cellIndex: Int, totalMovie: Int) -> some View {
        VStack(spacing: 0){
            ZStack(alignment: .topTrailing) {
                ImageFromURLView(imageURL: movieData.imageURL, size: (30,200))
                
                Button(action: {
                    self.toggleFavorite(result: movieData)
                }) {
                    Image(systemName: isFavorite(movieId: movieData.id) ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 30, height: 30, alignment: .center)
                        .foregroundColor(isFavorite(movieId: movieData.id) ? .red : .gray)
                        .animation(.easeInOut, value: isFavorite(movieId: movieData.id))
                }
                .padding(.top, 20)
                .padding(.trailing, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: 200, alignment: .topTrailing)
            
            Text(movieData.title ?? "")
                .frame(maxWidth: .infinity)
                .frame(height: 30)
                
            Text("Released: \(movieData.releaseDate ?? "")")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .border(Color.green, width: 1)
        .onAppear {
            self.loadMoreData(loadMoreContent: cellIndex == totalMovie - 1)
        }
    }

}

// MARK: AllMoviesList Logical Function
extension AllMoviesList {
    
    func setDataAfterResponse(page: Int?){
        PaginationHandaler.isDataLoaded = true
        PaginationHandaler.isDataLoading = false
        PaginationHandaler.pageNumber = page ?? 1
        self.showPaginationLoader = false
        self.showLoaderForSearching = false
    }
    
    func loadMoreData(loadMoreContent: Bool) {
        if !(PaginationHandaler.isDataLoading) && loadMoreContent{
            PaginationHandaler.isDataLoading = true
            self.showPaginationLoader = true
            self.allMoviesListVM.getMoviesList(searchText: self.searchText, pageNo: PaginationHandaler.pageNumber + 1)
        }
    }
    
    private func searchMovies(query: String) {
        if !query.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showLoaderForSearching = true
                self.allMoviesListVM.getMoviesList(searchText: query)
            }
        }else {
            self.allMoviesListVM.removeAllMovieData()
        }
    }
    
    private func isFavorite(movieId: Int?) -> Bool {
        if let mId = movieId {
            return favoriteMovies.contains { $0.movieId ==  Int64(mId) }
        }
        return false
    }
    
    private func toggleFavorite(result: Result) {
        if let id = result.id {
            if isFavorite(movieId: id) {
                removeFavorite(movieId: id)
            } else {
                addFavorite(result: result)
            }
        }
    }
    
    private func addFavorite(result: Result) {
        if let movieId = result.id, let title = result.title {
            PersistenceController.shared.addFavoriteMovie(title: title, movieId: Int64(movieId))
        }
    }
    
    private func removeFavorite(movieId: Int) {
        PersistenceController.shared.deleteFavoriteMovie(movieId: Int64(movieId))
    }
}

#Preview {
    AllMoviesList()
}

