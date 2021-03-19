//
//  UserTopResponse.swift
//  tindertunes
//
//  Created by Tin Luu on 3/18/21.
//

import Foundation

struct UserTopResponse: Codable {
    let items: [AudioTrack]
}

struct Album: Codable {
    let album_type: String
    let available_markets: [String]
    let id: String
    let images: [APIImage]
    let name: String
    let release_date: String
    let total_tracks: Int
    let artists: [Artist]
}
