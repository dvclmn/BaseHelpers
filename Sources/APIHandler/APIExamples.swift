//
//  File.swift
//  
//
//  Created by Dave Coleman on 29/6/2024.
//

import Foundation

/// For testing
struct TechCrunchPost: Codable {
    let id: Int
    let date: String
    let slug: String
    let type: String
    let link: String
    let title: Title
    let excerpt: Excerpt
    let author: Int
    let featuredMedia: Int
    let appleNewsNotices: [String]
    let yoastHead: String
    
    enum CodingKeys: String, CodingKey {
        case id, date, slug, type, link, title, excerpt, author
        case featuredMedia = "featured_media"
        case appleNewsNotices = "apple_news_notices"
        case yoastHead = "yoast_head"
    }
}

struct Title: Codable {
    let rendered: String
}

struct Excerpt: Codable {
    let rendered: String
    let protected: Bool
}
