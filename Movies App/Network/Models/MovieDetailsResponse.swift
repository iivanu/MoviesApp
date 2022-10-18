//
//  MovieDetails.swift
//  Movies App
//
//  Created by Ivan Ivanušić on 17.10.2022..
//

import Foundation

// MARK: - MovieDetailsResponse
struct MovieDetailsResponse: Codable {
    let backdropPath: String?
    let genres: [Genre]
    let id: Int
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let title: String

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genres, id
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String
}
