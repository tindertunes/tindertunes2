//
//  FeaturedPlaylistCollectionViewCell.swift
//  tindertunes
//
//  Created by Sydney Chiang on 3/19/21.
//

import Foundation
import UIKit
//import SDWebImage


class FeaturedPlaylistCollectionViewCell: UICollectionViewCell{
    static let identifier = "FeaturedPlaylistCollectionViewCell"
    
    private let playlistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 0
        return label
    }()

    
    override init(frame: CGRect){
        super.init(frame:frame)

        contentView.backgroundColor = .systemGreen
//        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        let imageSize = contentView.height-105
//        playlistCoverImageView.frame = CGRect(
//            x: (contentView.width-imageSize)/2,
//            y: contentView.height-44,
//            width: imageSize,
//            height: imageSize
//        )
        
        creatorNameLabel.frame = CGRect(
            x: 3,
            y: contentView.height-44,
            width: contentView.width-6,
            height: 44
        )

        playlistNameLabel.frame = CGRect(
            x: 3,
            y: contentView.height-90,
            width: contentView.width-6,
            height: 44
        )
        
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        playlistNameLabel.text = nil
        creatorNameLabel.text = nil
//        playlistCoverImageView.image = nil
        //        albumCoverImageView.image = nil
    }
    
    func configure(with viewModel: FeaturedPlaylistCellViewModel){
        playlistNameLabel.text = viewModel.name
        creatorNameLabel.text = "\(viewModel.creatorName)"
//        playlistCoverImageView.image = sd_setImage(with: viewModel.artworkURL, completed: nil)

//        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }

}
