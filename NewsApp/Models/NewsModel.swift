//
//  NewsModel.swift
//  NewsApp
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
    var status: String?
    var totalResult: Int?
    var articles: [Article]
}
