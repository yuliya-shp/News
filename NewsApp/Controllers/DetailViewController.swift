//
//  DetailViewController.swift
//  NewsApp
//
//
//

import UIKit

class DetailViewController: UIViewController {

    var article: Article?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = article?.title
        contentLabel.text = article?.content
        
        if article?.urlToImage != nil {
            let image = UIImage(named: "thumbnail")
            let url = URL(string: (article?.urlToImage)!)
            let data = try? Data(contentsOf: url!)
            imageView.image = UIImage(data: (data ?? image?.pngData())!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let desination = segue.destination as? WebPageViewController {
            desination.articleUrl = article?.url
        }
    }

}
