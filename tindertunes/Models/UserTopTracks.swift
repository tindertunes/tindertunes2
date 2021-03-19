//
//  UserTopTracks.swift
//  tindertunes
//
//  Created by Sydney Chiang on 3/19/21.
//

import Foundation


//{
//  "items": [
//    {
//      "album": {
//        "album_type": "ALBUM",
//        "artists": [
//          {
//            "external_urls": {
//              "spotify": "https://open.spotify.com/artist/66CXWjxzNUsdJxJ2JdwvnR"
//            },
//            "href": "https://api.spotify.com/v1/artists/66CXWjxzNUsdJxJ2JdwvnR",
//            "id": "66CXWjxzNUsdJxJ2JdwvnR",
//            "name": "Ariana Grande",
//            "type": "artist",
//            "uri": "spotify:artist:66CXWjxzNUsdJxJ2JdwvnR"
//          }
//        ],
//        "available_markets": [
//          "SG",
//          "ZA"
//        ],
//        "external_urls": {
//          "spotify": "https://open.spotify.com/album/3euz4vS7ezKGnNSwgyvKcd"
//        },
//        "href": "https://api.spotify.com/v1/albums/3euz4vS7ezKGnNSwgyvKcd",
//        "id": "3euz4vS7ezKGnNSwgyvKcd",
//        "images": [
//          {
//            "height": 640,
//            "url": "https://i.scdn.co/image/ab67616d0000b2735ef878a782c987d38d82b605",
//            "width": 640
//          },
//          {
//            "height": 300,
//            "url": "https://i.scdn.co/image/ab67616d00001e025ef878a782c987d38d82b605",
//            "width": 300
//          },
//          {
//            "height": 64,
//            "url": "https://i.scdn.co/image/ab67616d000048515ef878a782c987d38d82b605",
//            "width": 64
//          }
//        ],
//        "name": "Positions",
//        "release_date": "2020-10-30",
//        "release_date_precision": "day",
//        "total_tracks": 14,
//        "type": "album",
//        "uri": "spotify:album:3euz4vS7ezKGnNSwgyvKcd"
//      },
//      "artists": [
//        {
//          "external_urls": {
//            "spotify": "https://open.spotify.com/artist/66CXWjxzNUsdJxJ2JdwvnR"
//          },
//          "href": "https://api.spotify.com/v1/artists/66CXWjxzNUsdJxJ2JdwvnR",
//          "id": "66CXWjxzNUsdJxJ2JdwvnR",
//          "name": "Ariana Grande",
//          "type": "artist",
//          "uri": "spotify:artist:66CXWjxzNUsdJxJ2JdwvnR"
//        }
//      ],
//      "available_markets": [
//        "UY",
//        "VN",
//        "ZA"
//      ],
//      "disc_number": 1,
//      "duration_ms": 172324,
//      "explicit": true,
//      "external_ids": {
//        "isrc": "USUM72019412"
//      },
//      "external_urls": {
//        "spotify": "https://open.spotify.com/track/35mvY5S1H3J2QZyna3TFe0"
//      },
//      "href": "https://api.spotify.com/v1/tracks/35mvY5S1H3J2QZyna3TFe0",
//      "id": "35mvY5S1H3J2QZyna3TFe0",
//      "is_local": false,
//      "name": "positions",
//      "popularity": 93,
//      "preview_url": "https://p.scdn.co/mp3-preview/b43e087b54b33e2208712371f85f84e4e4a7052b?cid=774b29d4f13844c495f206cafdad9c86",
//      "track_number": 12,
//      "type": "track",
//      "uri": "spotify:track:35mvY5S1H3J2QZyna3TFe0"
//    },
//    {
//      "album": {
//        "album_type": "ALBUM",
//        "artists": [
//          {
//            "external_urls": {
//              "spotify": "https://open.spotify.com/artist/66CXWjxzNUsdJxJ2JdwvnR"
//            },
//            "href": "https://api.spotify.com/v1/artists/66CXWjxzNUsdJxJ2JdwvnR",
//            "id": "66CXWjxzNUsdJxJ2JdwvnR",
//            "name": "Ariana Grande",
//            "type": "artist",
//            "uri": "spotify:artist:66CXWjxzNUsdJxJ2JdwvnR"
//          }
//        ],
//        "available_markets": [
//          "AD",
//          "AE",
//          "AR",
//          "AT",
//          "AU",
//          "BE",
//          "BG",
//          "BH",
//          "BO",
//          "BR",
//          "CA",
//          "CH",
//          "CL",
//          "CO",
//          "CR",
//          "CY",
//          "CZ",
//          "DE",
//          "DK",
//          "DO",
//          "DZ",
//          "EC",
//          "EE",
//          "EG",
//          "ES",
//          "FI",
//          "FR",
//          "GB",
//          "GR",
//          "GT",
//          "HK",
//          "HN",
//          "HU",
//          "ID",
//          "IE",
//          "IL",
//          "IN",
//          "IS",
//          "IT",
//          "JO",
//          "JP",
//          "KW",
//          "LB",
//          "LI",
//          "LT",
//          "LU",
//          "LV",
//          "MA",
//          "MC",
//          "MT",
//          "MX",
//          "MY",
//          "NI",
//          "NL",
//          "NO",
//          "NZ",
//          "OM",
//          "PA",
//          "PE",
//          "PH",
//          "PL",
//          "PS",
//          "PT",
//          "PY",
//          "QA",
//          "RO",
//          "SA",
//          "SE",
//          "SG",
//          "SK",
//          "SV",
//          "TH",
//          "TN",
//          "TR",
//          "TW",
//          "US",
//          "UY",
//          "VN",
//          "ZA"
//        ],
//        "external_urls": {
//          "spotify": "https://open.spotify.com/album/3euz4vS7ezKGnNSwgyvKcd"
//        },
//        "href": "https://api.spotify.com/v1/albums/3euz4vS7ezKGnNSwgyvKcd",
//        "id": "3euz4vS7ezKGnNSwgyvKcd",
//        "images": [
//          {
//            "height": 640,
//            "url": "https://i.scdn.co/image/ab67616d0000b2735ef878a782c987d38d82b605",
//            "width": 640
//          },
//          {
//            "height": 300,
//            "url": "https://i.scdn.co/image/ab67616d00001e025ef878a782c987d38d82b605",
//            "width": 300
//          },
//          {
//            "height": 64,
//            "url": "https://i.scdn.co/image/ab67616d000048515ef878a782c987d38d82b605",
//            "width": 64
//          }
//        ],
//        "name": "Positions",
//        "release_date": "2020-10-30",
//        "release_date_precision": "day",
//        "total_tracks": 14,
//        "type": "album",
//        "uri": "spotify:album:3euz4vS7ezKGnNSwgyvKcd"
//      },
//      "artists": [
//        {
//          "external_urls": {
//            "spotify": "https://open.spotify.com/artist/66CXWjxzNUsdJxJ2JdwvnR"
//          },
//          "href": "https://api.spotify.com/v1/artists/66CXWjxzNUsdJxJ2JdwvnR",
//          "id": "66CXWjxzNUsdJxJ2JdwvnR",
//          "name": "Ariana Grande",
//          "type": "artist",
//          "uri": "spotify:artist:66CXWjxzNUsdJxJ2JdwvnR"
//        }
//      ],
//      "available_markets": [
//        "AD",
//        "AE",
//        "AR",
//        "AT",
//        "AU",
//        "BE",
//        "BG",
//        "BH",
//        "BO",
//        "BR",
//        "CA",
//        "CH",
//        "CL",
//        "CO",
//        "CR",
//        "CY",
//        "CZ",
//        "DE",
//        "DK",
//        "DO",
//        "DZ",
//        "EC",
//        "EE",
//        "EG",
//        "ES",
//        "FI",
//        "FR",
//        "GB",
//        "GR",
//        "GT",
//        "HK",
//        "HN",
//        "HU",
//        "ID",
//        "IE",
//        "IL",
//        "IN",
//        "IS",
//        "IT",
//        "JO",
//        "JP",
//        "KW",
//        "LB",
//        "LI",
//        "LT",
//        "LU",
//        "LV",
//        "MA",
//        "MC",
//        "MT",
//        "MX",
//        "MY",
//        "NI",
//        "NL",
//        "NO",
//        "NZ",
//        "OM",
//        "PA",
//        "PE",
//        "PH",
//        "PL",
//        "PS",
//        "PT",
//        "PY",
//        "QA",
//        "RO",
//        "SA",
//        "SE",
//        "SG",
//        "SK",
//        "SV",
//        "TH",
//        "TN",
//        "TR",
//        "TW",
//        "US",
//        "UY",
//        "VN",
//        "ZA"
//      ],
//      "disc_number": 1,
//      "duration_ms": 201882,
//      "explicit": false,
//      "external_ids": {
//        "isrc": "USUM72020441"
//      },
//      "external_urls": {
//        "spotify": "https://open.spotify.com/track/3UoULw70kMsiVXxW0L3A33"
//      },
//      "href": "https://api.spotify.com/v1/tracks/3UoULw70kMsiVXxW0L3A33",
//      "id": "3UoULw70kMsiVXxW0L3A33",
//      "is_local": false,
//      "name": "pov",
//      "popularity": 83,
//      "preview_url": "https://p.scdn.co/mp3-preview/95212c775366a26475c9c94b41bb247795740435?cid=774b29d4f13844c495f206cafdad9c86",
//      "track_number": 14,
//      "type": "track",
//      "uri": "spotify:track:3UoULw70kMsiVXxW0L3A33"
//    }
//  ],
//  "total": 50,
//  "limit": 2,
//  "offset": 0,
//  "href": "https://api.spotify.com/v1/me/top/tracks?limit=2&offset=0",
//  "previous": null,
//  "next": "https://api.spotify.com/v1/me/top/tracks?limit=2&offset=2"
//}
