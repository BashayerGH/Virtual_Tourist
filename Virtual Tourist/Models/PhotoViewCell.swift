//
//  PhotoViewCell.swift
//  Virtual Tourist
//
//  Created by Bashayer AlGhamdi on 22/01/2019.
//  Copyright © 2019 Bashayer. All rights reserved.
//

import UIKit

class PhotoViewCell: UICollectionViewCell {
    static let identifier = "PhotoViewCell"
    
    var imageUrl: String = ""
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
}
