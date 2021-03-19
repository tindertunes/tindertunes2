//
//  NewReleaseCollectionViewCell.swift
//  tindertunes
//
//  Created by Sydney Chiang on 3/19/21.
//

import UIKit


class NewReleaseCollectionViewCell: UICollectionViewCell{
    static let identifier = "NewReleaseCollectionViewCell"
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect){
        super.init(frame:frame)
        contentView.backgroundColor = .secondarySystemBackground
//        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(numberOfTracksLabel)
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
//        let imageSize: CGFloat = contentView.height-10
        let albumLabelSize = albumNameLabel.sizeThatFits(
            CGSize(
                width: contentView.width-10,
                height: contentView.height-10
            )
        )
        
//        albumNameLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
        
        let albumLabelHeight = min(60, albumLabelSize.height)

//        albumCoverImageView.fram = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        albumNameLabel.frame = CGRect(x: 10,
                                        y: 5,
                                        width: albumLabelSize.width,
                                        height: albumLabelHeight
                                        )
        artistNameLabel.frame = CGRect(x: 10,
                                       y: albumNameLabel.bottom+5,
                                        width: contentView.width-5,
                                        height: 30
                                        )
        numberOfTracksLabel.frame = CGRect(x: 10,
                                           y: contentView.bottom-44,
                                           width: contentView.width-5,
                                           height: 50
                                           )
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
//        albumCoverImageView.image = nil
    }
    
    func configure(with viewModel: NewReleasesCellViewModel){
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)" //DURATION - IF DON't WANT, GET RID OF
//        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}


