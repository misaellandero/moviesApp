//
//  MovieService.swift
//  moviesApp
//
//  Created by Francisco Misael Landero Ychante on 07/10/20.
//

import Foundation

struct API {
    
    //Mark:- Handle Errors
    enum Error: LocalizedError, Identifiable {
        var id: String { localizedDescription }

        case addressUnreachable(URL)
        case invalidResponse

        var errorDescription: String? {
            switch self {
                case .invalidResponse: return "The server responded with garbage."
                case .addressUnreachable(let url): return "\(url.debugDescription)"
            }
        }
    }

    enum EndPoint {
        static let baseURL = URL(string: "https://api.themoviedb.org/")!
        static let apiKey = "?api_key=" + "634b49e294bd1ff87914e7b9d014daed"
        //    private let baseAPIURL = "https://api.themoviedb.org/3/movie/"
        static let language = "&language=" + "es-MX"
        static let nextPageToLoad =  1
        
        case nowplaying
        case movie(id:Int)

        var url: URL {
            switch self {
            
            case .nowplaying:
                return EndPoint.baseURL.appendingPathComponent("/3/movie/now_playing\(API.EndPoint.apiKey)\(API.EndPoint.language)&page=\(API.EndPoint.nextPageToLoad)")
                
            case .movie(let id):
                return EndPoint.baseURL.appendingPathComponent("/3/movie/now_playing\(API.EndPoint.apiKey)\(API.EndPoint.language)&movieID=\(id)")
            }
        }
        static func request(with url: URL) -> URLRequest {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            return request
        }
    }

    private let decoder = JSONDecoder()
    private let apiQueue = DispatchQueue(label: "API", qos: .default, attributes: .concurrent)
    
    func fetchNowPlaying() -> AnyPublisher<[Movie], Error> {
        URLSession.shared.dataTaskPublisher(for: EndPoint.request(with: EndPoint.nowplaying.url))
            .map { return $0.data }
            .decode(type: [Movie].self, decoder: decoder)
            .print()
            .mapError { error in
                switch error {
                case is URLError:
                    return Error.addressUnreachable(EndPoint.nowplaying.url)
                default: return Error.invalidResponse
                }
            }
            .print()
            .map { $0 }
            .eraseToAnyPublisher()
    }
    
    func fetchMovie(with id: Int) -> AnyPublisher<[Movie], Error> {
        URLSession.shared.dataTaskPublisher(for: EndPoint.request(with: EndPoint.nowplaying.url))
            .map { return $0.data }
            .decode(type: [Movie].self, decoder: decoder)
            .print()
            .mapError { error in
                switch error {
                case is URLError:
                    return Error.addressUnreachable(EndPoint.nowplaying.url)
                default: return Error.invalidResponse
                }
            }
            .print()
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

struct Movie: Decodable, Identifiable {
    var id: ObjectIdentifier
    
    
}

private let api = API()
@Published var movies: [Movie] = []
@Published var selectedMovie: Movie?
private var subscriptions = Set<AnyCancellable>()

@Published var error: API.Error? = nil

func fetchNowPlaying() {
    api
    .fetchNowPlaying()
    .receive(on: DispatchQueue.main)
    .sink(receiveCompletion: { completion in
        if case .failure(let error) = completion {
            self.error = error
        }
    }, receiveValue: { movies in
        self.movies = []
        self.movies = movies
        //self.selectedMovie = movie
        self.error = nil
    }).store(in: &subscriptions)
}

/*
public class MoviesService {
    
    private let apiKey = "?api_key=" + "634b49e294bd1ff87914e7b9d014daed"
    private let baseAPIURL = "https://api.themoviedb.org/3/movie/"
    private let language = "&language=" + "es-MX"
    
    var nextPageToLoad =  1
    
    var nowPlayingMovies = [Movie]()
    var movieDetail : MovieDetail?
    
    
    init() {
        loadNowPlaying()
    }
 
    func loadNowPlaying(){
  
        let urlString = "\(baseAPIURL)now_playing\(apiKey)\(language)&page=\(nextPageToLoad)"
        print(urlString)
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler:parseMovies(data:response:error:))
        task.resume()
    }
    
    func parseMovies(data: Data?, response: URLResponse?, error: Error?){
            var NowPlayingMoviesResult = [Movie]()
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(NowPlaying.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async { [self] in
                        // update our UI
                      
                        NowPlayingMoviesResult = decodedResponse.results!
                        self.nextPageToLoad += 1
                        
                        for movie in NowPlayingMoviesResult {
                            nowPlayingMovies.append(movie)
                        }
                    }
                    // everything is good, so we can exit
                    return
                }
            }
            
            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        
    }
    
    func loadDetailMovie(id : Int) {
        
        let urlString = String("\(baseAPIURL)\(id)\(apiKey)\(language)")
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler:parseDetailMovie(data:response:error:))
        task.resume()
         
    }
    
    func parseDetailMovie(data: Data?, response: URLResponse?, error: Error?){
            
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(moviesApp.MovieDetail.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        self.movieDetail  = decodedResponse
                    }
                    // everything is good, so we can exit
                    return
                }
            }
            
            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        
    }
    
}

*/
