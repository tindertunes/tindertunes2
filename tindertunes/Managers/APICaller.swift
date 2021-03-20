//
//  APICaller.swift
//  tindertunes
//
//  Created by Sydney Chiang on 3/18/21.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    private init() {}
    
    struct Constants{
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error{
        case failedToGetData
    }
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void){
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/me"),
            type: .GET
        ){ baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest){ data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                }
                catch{
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    public func getNewReleases(completion: @escaping ((Result<NewReleasesResponse, Error>)) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=50"), type: .GET){ request in
            let task = URLSession.shared.dataTask(with: request){ data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completion(.success(result))
                }
                catch{
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
        
    }
    
    
    public func getFeaturedPlaylists(completion: @escaping ((Result<FeaturedPlaylistsResponse, Error>) -> Void)){
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=20"), type: HTTPMethod.GET){ request in
            let task = URLSession.shared.dataTask(with: request){ data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    completion(.success(result))
                }
                catch{
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    public func getUserTopTracks(completion: @escaping ((Result<UserTopResponse, Error>)) -> Void){
                createRequest(with: URL(string: Constants.baseAPIURL + "/me/top/tracks?limit=20"), type: .GET){ request in
                    print(Constants.baseAPIURL + "/me/top/tracks")
                    let task = URLSession.shared.dataTask(with: request){ data, _, error in
                        guard let data = data, error == nil else {
                            print("nada")
                            completion(.failure(APIError.failedToGetData))
                            return
                        }
                        
                        do {
//                            let json =  try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                            
                            let result = try JSONDecoder().decode(UserTopResponse.self, from: data)
                            completion(.success(result))
                        }
                        catch{
                            print("failed")
                            completion(.failure(error))
                        }
                        
                    }
                    task.resume()
                }
                
    }
    
    public func createPlaylist(with name: String, completion: @escaping ((Result<String, Error>)) -> Void) {
        getCurrentUserProfile { [weak self](result) in
            switch result {
            case.success(let profile):
                let urlString = Constants.baseAPIURL + "/users/\(profile.id)/playlists"
                self?.createRequest(with: URL(string: urlString), type: .POST) { (baseRequest) in
                    var request = baseRequest
                    let json = [
                        "name": name
                    ]
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                    print("request")
                    let task = URLSession.shared.dataTask(with: request) {data, _, error in
                        guard let data = data, error == nil else {
                            
                            completion(.failure(APIError.failedToGetData))
                            return
                        }
                        
                        do {
                            let result =  try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                            if let response = result as? [String: Any], response["id"] as? String != nil {
                                print("Created")
                                completion(.success((response["id"] as? String)!))
                            }
                        }
                        catch {
                            print(data)
                            print(error.localizedDescription)
                            completion(.failure(error))
                        }
                    }
                    task.resume()
                }
            case.failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
    
    public func getAlbumTracks (playlist: String, completion: @escaping ((Result<TracksList, Error>)) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/albums/\(playlist)/tracks"), type: .GET){ request in
            print(Constants.baseAPIURL + "/albums/\(playlist)/tracks")
            let task = URLSession.shared.dataTask(with: request){ data, _, error in
                guard let data = data, error == nil else {
                    print("nada")
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
    //                            let json =  try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    
                    let result = try JSONDecoder().decode(TracksList.self, from: data)
                    completion(.success(result))
                }
                catch{
                    print(error)
                    print("failed")
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    public func getPlaylistTracks (playlist: String, completion: @escaping ((Result<PlaylistTracksList, Error>)) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/playlists/\(playlist)/tracks?market=US"), type: .GET){ request in
            print(Constants.baseAPIURL + "/playlists/\(playlist)/tracks?market=US")
            print("HI")
            let task = URLSession.shared.dataTask(with: request){ data, _, error in
                guard let data = data, error == nil else {
                    print("nada")
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let json =  try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(json)
                    let result = try JSONDecoder().decode(PlaylistTracksList.self, from: data)
                    completion(.success(result))
                }
                catch{
                    print(error)
                    print("failed")
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    public func addSmallTrackToPlaylist (
        track: SmallerTrack,
        playlist: String,
        completion: @escaping (Bool) -> Void
    ) { createRequest(
            with: URL(string: Constants.baseAPIURL + "/playlists/\(playlist)/tracks"),
            type: .POST
        ) { (baseRequest) in
        var request = baseRequest
        let json = [
            "uris": [
                "spotify:track:\(track.id)"
            ]
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let str = String(decoding: request.httpBody!, as: UTF8.self)
        
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(track.name)
                print(track.id)
                print(result)
                if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
                    completion(true)
                }
            }
            catch {
                
                print(error.localizedDescription)
                completion(false)
            }
            
        }
        task.resume()
    }
        
    }
    
    public func addTrackToPlaylist (
        track: AudioTrack,
        playlist: String,
        completion: @escaping (Bool) -> Void
    ) { createRequest(
            with: URL(string: Constants.baseAPIURL + "/playlists/\(playlist)/tracks"),
            type: .POST
        ) { (baseRequest) in
        var request = baseRequest
        let json = [
            "uris": [
                "spotify:track:\(track.id)"
            ]
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let str = String(decoding: request.httpBody!, as: UTF8.self)
        
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(track.name)
                print(track.id)
                print(result)
                if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
                    completion(true)
                }
            }
            catch {
                
                print(error.localizedDescription)
                completion(false)
            }
            
        }
        task.resume()
    }
        
    }
    
//    public func getRecommendations(completion: @escaping ((Result<String, Error>) -> Void)){
//        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations"), type: .GET){ request in
//            let task = URLSession.shared.dataTask(with: request){ data, _, error in
//                guard let data = data, error == nil else {
//                    completion(.failure(APIError.failedToGetData))
//                    return
//                }
//                
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
////                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
//                    print(json)
////                    completion(.success(result))
//                }
//                catch{
//                    completion(.failure(error))
//                }
//                
//            }
//            task.resume()
//        }
//    }
    
    //MARK: - Private
    enum HTTPMethod: String{
        case GET
        case POST
    }
    
    private func createRequest(
        with url: URL?,
        type: HTTPMethod,
        completion: @escaping (URLRequest) -> Void
    ){
        AuthManager.shared.withValidToken{ token in
            guard let apiURL = url else{
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)",
                             forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
}


