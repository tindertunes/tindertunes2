//
//  SearchViewController.swift
//  tindertunes
//
//  Created by Sydney Chiang on 3/18/21.
//

import UIKit


enum TrendingSectionType{
    case newReleases(viewModels: [NewReleasesCellViewModel])
    case featuredPlaylists(viewModels: [FeaturedPlaylistCellViewModel])
    
}

class SearchViewController: UIViewController {

    private var newTracks: [Album] = []
    private var featuredTracks: [Playlist] = []
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout{ sectionIndex, _ -> NSCollectionLayoutSection? in
            return SearchViewController.createSectionLayout(section: sectionIndex)
    })
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private var sections = [TrendingSectionType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Trending"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings)
        )

        configureCollectionView()
        view.addSubview(spinner)
        fetchData()
        addLongTapGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func addLongTapGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        collectionView.isUserInteractionEnabled = true
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }
        
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint), indexPath.section >= -10000 else {
            return
        }
        if indexPath.section == 0 {
            let model = newTracks[indexPath.row]
            let actionSheet = UIAlertController(title: model.name, message: "Would you like to add this album to your playlist", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.addAction(UIAlertAction(title: "Add to Playlist", style: .default, handler: {_ in
                APICaller.shared.getAlbumTracks(playlist: model.id){ result in
                    switch result {
                    case .success(let model):
                        let tracks = model.items
                        for track in tracks {
                            print(track.name)
                            APICaller.shared.addSmallTrackToPlaylist(track: track, playlist: PlaylistName.playlist_name) { (result3) in
                                    if result3 {
                                        print("Added Tracks")
                                    } else {
                                        print("Failed to add Tracks")
                                    }
                                    
                                }
                            }
                    case .failure(let error): break
                    }
                }
            }))
            present(actionSheet, animated: true)
        }
        if indexPath.section == 1 {
            let model = featuredTracks[indexPath.row]
            let actionSheet = UIAlertController(title: model.name, message: "Would you like to add playlist this to your playlist", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.addAction(UIAlertAction(title: "Add to Playlist", style: .default, handler: {_ in
                APICaller.shared.getPlaylistTracks(playlist: model.id){ result in
                    switch result {
                    case .success(let model):
                        let tracks = model.items
                        for track in tracks {
                            print(track)
                            APICaller.shared.addSmallTrackToPlaylist(track: track.track, playlist: PlaylistName.playlist_name) { (result3) in
                                    if result3 {
                                        print("Added Tracks")
                                    } else {
                                        print("Failed to add Tracks")
                                    }
                                    
                                }
                            }
                    case .failure(let error): break
                    }
                }
            }))
            present(actionSheet, animated: true)
        }
        
    }
    
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    

    

    
    private func fetchData(){
        let group = DispatchGroup()
        group.enter()
        group.enter()

        
        var newReleases: NewReleasesResponse?
        var featuredPlaylist: FeaturedPlaylistsResponse?
        var userTopTracks: UserTopResponse?
        
        //new releases
        APICaller.shared.getNewReleases{ result in
            defer{
                group.leave()
            }
            switch result{
            case .success(let model):
                
                newReleases = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        //featured playlists
        APICaller.shared.getFeaturedPlaylists{ result in
            defer{
                group.leave()
            }
            switch result{
            case .success(let model):
                featuredPlaylist = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        

        
        group.notify(queue: .main){
            guard let newAlbums = newReleases?.albums.items,
                  let playlists = featuredPlaylist?.playlists.items else{
                fatalError("Models are nil")
                return
            }
//            ,
//            let topTracks = userTopTracks?.items
            
            self.configureModels(newAlbums: newAlbums, playlists: playlists) //, userTopTracks: topTracks
            
        }
        

    }
    
    private func configureModels(
        newAlbums: [Album],
        playlists: [Playlist]
    ){
        //configure stuff - APPENDS SONGS AND WHATEVER TO THE SECTIONS LIST (of enums)
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
            newTracks.append($0)
            return NewReleasesCellViewModel(name: $0.name, artworkURL: URL(string: $0.images.first?.url ?? ""), numberOfTracks: $0.total_tracks, artistName: $0.artists.first?.name ?? "-")
        })))
        sections.append(.featuredPlaylists(viewModels: playlists.compactMap({
            featuredTracks.append($0)
            return FeaturedPlaylistCellViewModel(name: $0.name, artworkURL: URL(string: $0.images.first?.url ?? ""), creatorName: $0.owner.display_name)
        })))
        collectionView.reloadData()
    }

    @objc func didTapSettings(){
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

}


extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .newReleases(let viewModels):
            return viewModels.count
        case .featuredPlaylists(let viewModels):
            return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type {
        case .newReleases(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleaseCollectionViewCell.identifier, for: indexPath) as? NewReleaseCollectionViewCell else{
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            cell.backgroundColor = .red
            
            return cell
        case .featuredPlaylists(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath) as? FeaturedPlaylistCollectionViewCell else{
                return UICollectionViewCell()
            }
            cell.configure(with: viewModels[indexPath.row])
            cell.backgroundColor = .blue
            return cell

        }
        

    }
    
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection{
        switch section{
        case 0:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.7)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //vertical group in horizontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)),
                subitem: item,
                count: 3)
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(390)),
                subitem: verticalGroup,
                count: 1)
            
            //Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        case 1:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(200)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(400)),
                subitem: item,
                count: 2)
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(400)),
                subitem: verticalGroup,
                count: 1)
            
            //Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        default:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.7)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)),
                subitem: item,
                count: 3)
            
            //Section
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
}

