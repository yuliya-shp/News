//
//  TableViewController.swift
//  daily-news
//
//
//

import UIKit

class TableViewController: UITableViewController, UISearchResultsUpdating {
    
    var today: String!
    var isLoading = false
    
    private var articles: [Article]? = []
    private var filteredArticles: [Article] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    var resultSearchController = UISearchController()

    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        today = getDate()
        self.navigationItem.title = "Daily News \(today!)"
        self.tableView.rowHeight = 138
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        fetchData(refresh: false)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
             return filteredArticles.count
        } else {
            return self.articles?.count ?? 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        if isFiltering {
            cell.titleLabel.text = filteredArticles[indexPath.row].title
            cell.descLabel.text = filteredArticles[indexPath.row].description
                
            if filteredArticles[indexPath.item].urlToImage != nil {
                let image = UIImage(named: "thumbnail")
                let url = URL(string: (filteredArticles[indexPath.item].urlToImage)!)
                let data = try? Data(contentsOf: url!)

                cell.imageLabel.image = UIImage(data: (data ?? image?.pngData())!)?.squared
            }
                return cell
        } else {
            cell.titleLabel.text = self.articles?[indexPath.item].title
            cell.descLabel.text = self.articles?[indexPath.item].description
            
            if articles?[indexPath.item].urlToImage != nil {
                let image = UIImage(named: "thumbnail")
                let url = URL(string: (articles?[indexPath.item].urlToImage)!)
                let data = try? Data(contentsOf: url!)
                cell.imageLabel.image = UIImage(data: (data ?? image?.pngData())!)?.squared
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let desination = segue.destination as? DetailViewController {
            desination.article = articles![(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    // MARK: - Refresh table
    
    @objc func refreshData() {
        fetchData(refresh: true)
    }
 
    // MARK: - Fetch API
    
    func fetchData(refresh: Bool = false) {
        
        if refresh {
            refreshControl?.beginRefreshing()
        }

        let apiKey = "3fb18c84dc494acf8881f24bc00e400d"
        let api = URL(string: "https://newsapi.org/v2/everything?q=apple&from=\(self.today!)/&to=\(self.today!)/&apiKey=\(apiKey)")
        
        URLSession.shared.dataTask(with: api!) { (data, response, error) in
            guard let data = data else {return}
            guard error == nil else {return}
            
            do {
                let article = try JSONDecoder().decode(NewsEnvelope.self, from: data)
                self.articles = article.articles
            } catch let error {
                print(error)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.resume()
    }
    
    // MARK: - Get date
    
    func getDate () -> String {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = formatter.string(from: today)
        
        return currentDate
    }
    
    //MARK: - Searching
    
    func filterContentForSearchText(_ searchText: String) {
        filteredArticles = articles!.filter { (article: Article) -> Bool in
        return article.title!.lowercased().contains(searchText.lowercased())
      }
      tableView.reloadData()
    }
}

extension TableViewController {
    public func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

extension UIImage {
    var squared: UIImage? {
        let originalWidth  = size.width
        let originalHeight = size.height
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        var edge: CGFloat = 0.0
        
        if (originalWidth > originalHeight) {
            // landscape
            edge = originalHeight
            x = (originalWidth - edge) / 2.0
            y = 0.0
            
        } else if (originalHeight > originalWidth) {
            // portrait
            edge = originalWidth
            x = 0.0
            y = (originalHeight - originalWidth) / 2.0
        } else {
            // square
            edge = originalWidth
        }
        
        let cropSquare = CGRect(x: x, y: y, width: edge, height: edge)
        guard let imageRef = cgImage?.cropping(to: cropSquare) else { return nil }
        
        return UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
    }
}
