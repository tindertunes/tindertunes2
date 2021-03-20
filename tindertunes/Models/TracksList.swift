//
//  TracksList.swift
//  tindertunes
//
//  Created by Tin Luu on 3/19/21.
//

import Foundation

struct TracksList: Codable {
    let items: [SmallerTrack]
}

struct PlaylistTracksList: Codable {
    let items: [BigTrack]
}

struct BigTrack: Codable {
    let track: SmallerTrack
}

