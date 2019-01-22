//
//  PhotosParser.swift
//  Virtual Tourist
//
//  Created by Bashayer AlGhamdi on 22/01/2019.
//  Copyright © 2019 Bashayer. All rights reserved.
//

import Foundation

struct Parser: Codable {
    let photos: Photos
}

struct Photos: Codable {
    let pages: Int
    let photo: [PhotoParser]
}

struct PhotoParser: Codable {
    
    let url: String?
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case url = "url_n"
        case title
    }
}
