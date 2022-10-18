//
//  SimilarMovies.swift
//  Movies App
//
//  Created by Ivan Ivanušić on 17.10.2022..
//

import Foundation

// MARK: - SimilarMoviesResponse
struct SimilarMoviesResponse: Codable {
    let page: Int
    let results: [SimilarMovie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - SimilarMovie
struct SimilarMovie: Codable {
    let posterPath, backdropPath: String?
    let id: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id
        case posterPath = "poster_path"
        case title
    }
}

