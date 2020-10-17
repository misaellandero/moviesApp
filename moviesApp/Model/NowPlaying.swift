//
//  NowPlaying.swift
//  moviesApp
//
//  Created by Francisco Misael Landero Ychante on 07/10/20.
//

import Foundation

struct NowPlaying: Codable {
    let results: [Movie]
    enum CodingKeys: String, CodingKey {
        case results
    }
}
/*
struct NowPlaying: Decodable, Identifiable {
    var id = UUID()
    let results: [Movie]?
    //let page : Int? //, totalResults: Int?
    //let dates: Dates?
    //let totalPages: Int?

    enum CodingKeys: String, CodingKey {
        //case page
        case results //,page
        //case totalResults = "total_results"
        //case dates
        //case totalPages = "total_pages"
    }
}*/

// MARK: - Dates
struct Dates: Codable {
    let maximum, minimum: String?
}
