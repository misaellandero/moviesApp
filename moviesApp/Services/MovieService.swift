//
//  MovieService.swift
//  moviesApp
//
//  Created by Francisco Misael Landero Ychante on 07/10/20.
//

import Foundation
import Combine
/*
public class MoviesService {
    
    private let apiKey = "?api_key=" + "634b49e294bd1ff87914e7b9d014daed"
    private let baseAPIURL = "https://api.themoviedb.org/3/movie/"
    private let language = "&language=" + "es-MX"
    
    var nextPageToLoad =  1
    
    var nowPlayingMovies = [Movie]()
    
    
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
    
    func loadDetailMovie(id : Int, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        
        let urlString = String("\(baseAPIURL)\(id)\(apiKey)\(language)")
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, response , error in
            guard let self = self else { return }
            
            if let error = error {
                return completion(.failure(error))
            }
            
            if let data = data {
                do {
                    let movieDetail = try self.decodeMovieDetail(from: data)
                    completion(.success(movieDetail))
                } catch {
                    completion(.failure(error))
                }
            }
            
        })
        task.resume()
         
    }
    
    private func decodeMovieDetail(from data: Data) throws -> MovieDetail {
        return try JSONDecoder().decode(MovieDetail.self, from: data)
    }
    
}
*/
 
struct API {
    
    // MARK: - Error Handle
    enum Error: LocalizedError, Identifiable {
        var id: String { localizedDescription }

        case addressUnreachable(URL)
        case invalidResponse

        var errorDescription: String? {
            switch self {
                case .invalidResponse: return "Bad server response."
                case .addressUnreachable(let url): return "\(url.debugDescription)"
            }
        }
        
    }
    
    // MARK: - Api End Points
    enum EndPoint {
        static let baseURL = URL(string: "https://api.themoviedb.org")!
        static let apiKey =  "634b49e294bd1ff87914e7b9d014daed"
        static let language = "es-MX"
        static let nextPageToLoad =  1
        
        case nowplaying
        case movie(id:Int)

        var url: URL {
            switch self {
            
            case .nowplaying:
               
                return EndPoint.baseURL.appendingPathComponent("/3/movie/now_playing")
                    //EndPoint.baseURL.appendingPathComponent("/3/movie/now_playing")
                
            case .movie(let id):
                return EndPoint.baseURL.appendingPathComponent("/3/movie/now_playing\(API.EndPoint.apiKey)\(API.EndPoint.language)&movieID=\(id)")
            }
        }
        static func request(with url: URL) -> URLRequest {
            var newUrl = url
            newUrl.appendQueryItem(name: "api_key", value: "634b49e294bd1ff87914e7b9d014daed")
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            //request.setValue("634b49e294bd1ff87914e7b9d014daed", forHTTPHeaderField: "api_key")
            return request
        }
        
    }

    
    private let decoder = JSONDecoder()
    private let apiQueue = DispatchQueue(label: "API", qos: .default, attributes: .concurrent)
    
    func fetchNowPlaying() -> AnyPublisher<NowPlaying, Error> {
       
        URLSession.shared.dataTaskPublisher(for: EndPoint.request(with: EndPoint.nowplaying.url))
            .map {
                do {
                    let response = try JSONSerialization.data(withJSONObject: $0, options: [])
                    print(response)
                } catch {
                    
                }
                
              
                return $0.data }
            .decode(type: NowPlaying.self, decoder: decoder)
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

/*
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
*/

extension URL {

    mutating func appendQueryItem(name: String, value: String?) {

        guard var urlComponents = URLComponents(string: absoluteString) else { return }

        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        // Create query item
        let queryItem = URLQueryItem(name: name, value: value)

        // Append the new query item in the existing query items array
        queryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems

        // Returns the url from new url components
        self = urlComponents.url!
    }
}
