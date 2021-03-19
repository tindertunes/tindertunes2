//
//  UserTopTracksCollection.swift
//  tindertunes
//
//  Created by Sydney Chiang on 3/19/21.
//

import UIKit


class UserTopTracksCollectionViewCell: UICollectionViewCell{
    static let identifier = "UserTopTracksCollection"
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()

    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()

    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 0
        return label
    }()


    override init(frame: CGRect){
        super.init(frame:frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(durationLabel)
    }

    required init?(coder: NSCoder){
        fatalError()
    }

    override func layoutSubviews(){
        super.layoutSubviews()
        let trackLabelSize = trackNameLabel.sizeThatFits(
            CGSize(
                width: contentView.width-10,
                height: contentView.height-10
            )
        )

        artistNameLabel.sizeToFit()
        durationLabel.sizeToFit()

        let trackLabelHeight = min(60, trackLabelSize.height)
        trackNameLabel.frame = CGRect(x: 10,
                                        y: 5,
                                        width: trackLabelSize.width,
                                        height: trackLabelHeight
                                        )
        artistNameLabel.frame = CGRect(x: 10,
                                       y: trackNameLabel.bottom+5,
                                        width: contentView.width-5,
                                        height: 30
                                        )
        durationLabel.frame = CGRect(x: 10,
                                           y: contentView.bottom-44,
                                           width: contentView.width-5,
                                           height: 50
                                           )
    }

    override func prepareForReuse(){
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        durationLabel.text = nil
//        albumCoverImageView.image = nil
    }

    func configure(with viewModel: UserTopTracksCellViewModel){
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        durationLabel.text = "Duration: \(viewModel.duration_ms)"
//        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
    
        

}




