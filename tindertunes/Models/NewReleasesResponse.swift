//
//  NewReleasesResponse.swift
//  tindertunes
//
//  Created by Sydney Chiang on 3/18/21.
//

import Foundation

struct NewReleasesResponse: Codable{
    let albums: AlbumsResponse
}

struct AlbumsResponse: Codable{
    let items: [Album]
}





