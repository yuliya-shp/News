//
//  NewsModel.swift
//  daily-news
//
//
//

import Foundation

struct Article: Decodable {
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var content: String?
}

struct NewsEnvelope: Decodable {
    var articles: [Article]
}
