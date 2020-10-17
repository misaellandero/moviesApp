//
//  StateController.swift
//  moviesApp
//
//  Created by Francisco Misael Landero Ychante on 07/10/20.
//

import Foundation
import Combine
class StateController: ObservableObject, RandomAccessCollection {
    
    typealias Element = Movie
    
    @Published var movies = [Movie]()
    
    @Published var movie : MovieDetail?
    
    private let api = API()// MoviesService()
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var error: API.Error? = nil
    
    
    func shouldLoadMoreData(item : Movie? = nil) -> Bool {
        
        if item == movies.last {
           return true
        }
        return false
    }
    
    func fetchNowPlaying() {
        print(API.EndPoint.nowplaying.url)
        api
        .fetchNowPlaying()
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                self.error = error
            }
        }, receiveValue: { movies in
            //self.movies = []
            print(movies)
            //self.movies = movies
            //self.selectedMovie = movie
            self.error = nil
        }).store(in: &subscriptions)
    }
    
    /*
    func reloadMovies(item : Movie? = nil){
        self.movies =  moviesService.fetchNowPlaying()
        
        /*DispatchQueue.main.async {
            if self.shouldLoadMoreData(item: item) {
                self.moviesService.loadNowPlaying()
            }
            self.movies = self.moviesService.nowPlayingMovies
        }*/
    }*/
    
    
    /*func loadMovieDetails(id: Int) {
            self.moviesService.loadDetailMovie(id: id) { result in
                switch result {
                case let .success(movie):
                    DispatchQueue.main.async {
                        self.movie = movie
                    }
                
                case .failure: break // Here you can manage a error if any
                }
        }
    }*/
    
    var startIndex: Int { movies.startIndex }
    var endIndex: Int { movies.endIndex }
    
    
    subscript(position: Int ) -> Movie {
        return movies[position]
    }
    
}
