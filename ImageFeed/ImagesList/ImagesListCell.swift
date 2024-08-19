//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Pavel on 01.02.2024.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    weak var delegate: ImagesListCellDelegate?
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    static let reuseIdentifier = "ImagesListCell"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    func configCell(photoUrl url: URL, isLiked: Bool, date: Date?) {
        self.dateLabel.text = date != nil ? dateFormatter.string(from: date!) : ""
        
        let likedImage = isLiked ? UIImage(named: "like_button_active") : UIImage(named: "like_button_disabled")
        self.likeButton.setImage(likedImage, for: .normal)
        
        let placeholder = UIImage(named: "placeholder_image")
        cellImage.kf.setImage(with: url, placeholder: placeholder)
        cellImage.kf.indicatorType = .activity
    }
    
    func setIsLiked(_ flag: Bool){        
        let likedImage = flag ? UIImage(named: "like_button_active") : UIImage(named: "like_button_disabled")
        self.likeButton.setImage(likedImage, for: .normal)
    }
}
