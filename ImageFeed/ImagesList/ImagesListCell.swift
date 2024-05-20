//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Pavel on 01.02.2024.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    static let reuseIdentifier = "ImagesListCell"
}
