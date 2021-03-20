//
//  ViewController.swift
//  tindertunes
//
//  Created by Sydney Chiang on 3/18/21.
//

import UIKit

enum BrowseSectionType{
    case userTopTracks(viewModels:[UserTopTracksCellViewModel])
    
}

struct PlaylistName {
    static var playlist_name: String = ""
}

class HomeViewController: UIViewController {

    private var tracks: [AudioTrack] = []
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout{ sectionIndex, _ -> NSCollectionLayoutSection? in
            return HomeViewController.createSectionLayout(section: sectionIndex)
    })
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private var sections = [BrowseSectionType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Top Tracks"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings)
        )
        

        configureCollectionView()
        view.addSubview(spinner)
        let alertController = UIAlertController(title: "Playlist Name", message: "", preferredStyle: .alert)

        // Add a textField to your controller, with a placeholder value & secure entry enabled
        alertController.addTextField { textField in
            textField.placeholder = "Enter playlist name"
            textField.textAlignment = .center
        }

        // A cancel action

        // This action handles your confirmation action
        let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
            if alertController.textFields?.first?.text == "" {
                alertController.textFields?.first?.text = "TinderTunes"
            }
            
            APICaller.shared.createPlaylist(with: alertController.textFields?.first?.text ?? "TinderTunes") { (result2) in
                switch result2 {
                case .success(let model2):
                    print("Yes")
                    PlaylistName.playlist_name = model2
                case .failure(let error): print("No")
                }

            }
        }

        // Add the actions, the order here does not matter
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
//        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .alert)
//        actionSheet.addTextField(configurationHandler: { textField in
//            textField.placeholder = "Add playlist name"
//        })
//
//        actionSheet.addAction(UIAlertAction(title: "Add to Playlist", style: .cancel, handler: {_ in
//            APICaller.shared.createPlaylist(with: actionSheet.textFields?.first) { (result2) in
//                switch result2 {
//                case .success(let model2):
//                    print("Yes")
//                    self.playlist = model2
//                case .failure(let error): print("No")
//                }
//
//            }
//        }))
//
//
//
//        present(actionSheet, animated: true)
        
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
        print("Felt")
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint), indexPath.section >= -10000 else {
            return
        }
        print(indexPath.row)
        
        
        let model = tracks[indexPath.row]
        print(model)
        let actionSheet = UIAlertController(title: model.name, message: "Would you like to add this song to your playlist", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Add to Playlist", style: .default, handler: {_ in
            APICaller.shared.addTrackToPlaylist(track: model, playlist: PlaylistName.playlist_name) { (bool ) in
                if bool {
                    print("Successfully addded to playlist")
                }
            }
        }))
        present(actionSheet, animated: true)
        
    }
    
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(UserTopTracksCollectionViewCell.self, forCellWithReuseIdentifier: UserTopTracksCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    

    
    private func fetchData(){
        let group = DispatchGroup()
        group.enter()
        
        var userTopTracks: UserTopResponse?

        
        
        
//        APICaller.shared.addTrackToPlaylist(track: track, playlist: model2) { (result3) in
//            if result3 {
//                print("Added Tracks")
//            } else {
//                print("Failed to add Tracks")
//            }
//
//        }
        
        
        //user top trakcs
        APICaller.shared.getUserTopTracks{ result in
            defer{
                group.leave()
            }
            switch result{
            case .success(let model):
                userTopTracks = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        group.notify(queue: .main){
            guard let topTracks = userTopTracks?.items else{
                fatalError("Models are nil")
                return
            }
//            ,
//            let topTracks = userTopTracks?.items
            
            self.configureModels(userTopTracks: topTracks) //, userTopTracks: topTracks
            
        }
        

    }
    
    private func configureModels(
        userTopTracks: [AudioTrack]
    ){
        tracks = userTopTracks
        //configure stuff - APPENDS SONGS AND WHATEVER TO THE SECTIONS LIST (of enums)
        sections.append(.userTopTracks(viewModels: userTopTracks.compactMap({
            return UserTopTracksCellViewModel(trackName: $0.name, artistName: $0.artists.first?.name ?? "-", duration_ms: $0.duration_ms)
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


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .userTopTracks(let viewModels):
            return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type {
        case .userTopTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserTopTracksCollectionViewCell.identifier, for: indexPath) as? UserTopTracksCollectionViewCell else{
                return UICollectionViewCell()
            }
            cell.configure(with: viewModels[indexPath.row])
            cell.backgroundColor = .yellow
            return cell
        }
        

    }
    
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection{
        switch section{
        case 0:
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

