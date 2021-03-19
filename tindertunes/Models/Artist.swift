//
//  Artist.swift
//  tindertunes
//
//  Created by Sydney Chiang on 3/18/21.
//

import Foundation

struct Artist: Codable{
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
}
