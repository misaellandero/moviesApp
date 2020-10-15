//
//  StateController.swift
//  moviesApp
//
//  Created by Francisco Misael Landero Ychante on 07/10/20.
//

import Foundation

class StateController: ObservableObject, RandomAccessCollection {
    
    typealias Element = Movie
    
    @Published var movies = [Movie]()
    
    //@Published var movie : MovieDetail?
    
    private let moviesService = MoviesService()
    
  
    func shouldLoadMoreData(item : Movie? = nil) -> Bool {
        
        if item == movies.last {
           return true
        }
        
        return false
        
    }
    
    func reloadMovies(item : Movie? = nil){
        
        DispatchQueue.main.async {
            if self.shouldLoadMoreData(item: item) {
                self.moviesService.loadNowPlaying()
            }
             
            self.movies = self.moviesService.nowPlayingMovies
     
        }
    }
    
    
    /*func loadMovieDetails(id: Int){
        print("cargar pelicula")
        DispatchQueue.main.async {
            print("cargar detalles pelicula")
            self.moviesService.loadDetailMovie(id: id)
            self.movie = self.moviesService.movieDetail
        }
    }*/
    
    var startIndex: Int { movies.startIndex }
    var endIndex: Int { movies.endIndex }
    
    
    subscript(position: Int ) -> Movie {
        return movies[position]
    }
    
}
