//
//  NewsViewController.swift
//  Isuru_Patabendi_FE_8922125
//
//  Created by user235715 on 12/9/23.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableViewNews: UITableView!
    
    @IBOutlet var NewsErrorLable: UILabel!
    
    var newsArticles = [Article]()
    
    var destination: String?

    // MARK: - Welcome
    struct Welcome: Codable {
        let status: String
        let totalResults: Int
        let articles: [Article]
    }
    
    // MARK: - Article
    struct Article: Codable {
        let source: Source
        let author: String?
        let title: String
        let description: String?
        let url: String
        let urlToImage: String?
        let publishedAt: String?
        let content: String?
    }
    
    // MARK: - Source
    struct Source: Codable {
        let id: String?
        let name: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up table view delegate and data source
        tableViewNews.delegate = self
        tableViewNews.dataSource = self
        
        // Register custom table view cell to the table
        tableViewNews.register(NewsTableViewCell.nib(), forCellReuseIdentifier: NewsTableViewCell.identifier)

        // Download JSON data and reload the table view on success
        downloadJSON {
            print("Success")
            self.tableViewNews.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //display error message when no news data available
        if(newsArticles.count == 0){
            NewsErrorLable.text = "Oops! We couldn't locate any news for the specified destination. Please try again."
        }else{
            NewsErrorLable.text = ""
        }
            
        return newsArticles.count
    }
    
    var myData: [CustomData]?
    
    let content = (UIApplication.shared.delegate as!
                   AppDelegate).persistentContainer.viewContext

    //set table view cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        
        let article = newsArticles[indexPath.row]
        
        if(indexPath.row == 0){
            //SAVE CORE DATA
            //Create a CustomData object
            let newCustomData = CustomData(context: self.content)
                                        
            if(self.destination != ""){
                newCustomData.weatherTransaction = "Home"
            }
            
            newCustomData.newsCityName = self.destination
            newCustomData.newsTitle = article.title
            newCustomData.newsAuthor = article.author
            newCustomData.newsSource = article.source.name
            newCustomData.newsDescription = article.description
            newCustomData.screenName = "News"
            
                                        
            //Save the data
            do{
                print("Success saving data!")
                try self.content.save()
            }catch{
                print("Error saving data")
            }
        }
        
        // Populate cell with article data
        cell.titleCellLable.text = article.title
        
        //if description is nil
        if(article.description != nil){
            cell.descriptionCellLable.text = article.description
        }else{
            cell.descriptionCellLable.text = "Article Description: not found!"
        }
        
        cell.sourceCellLable.text = "Source: \(article.source.name)"
        
        //if author is nil
        let author = (article.author)
        if(author != nil){
            cell.authorCellLable.text = "Author: \(author!)"
        }else{
            cell.authorCellLable.text = "Author: not found!"
        }
        
        return cell
    }

    // Download JSON data from the specified URL and parse it into the newsArticles array
    func downloadJSON(completed: @escaping () -> ()) {
        
        //format destination to append to api
//        let formattedDestination = destination?.prefix(2)
        var urlString = ""
        
        print("Destination: \(destination!)")
                
        //change api according to the destination
        if((destination!) != ""){
            urlString = "https://newsapi.org/v2/top-headlines?q=\(destination!)&apiKey=b4cdbdf44f614f548e0b12530432aa61"
        }else{
            urlString = "https://newsapi.org/v2/top-headlines?q=canada&apiKey=b4cdbdf44f614f548e0b12530432aa61"
        }
        
        let url = URL(string: urlString)

        if let url = url {
            let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(Welcome.self, from: data)
                        
                        // Update the newsArticles array with the decoded data
                        self.newsArticles = decodedData.articles

                        // Reload the table view on the main thread
                        DispatchQueue.main.async {
                            completed()
                        }
                    } catch {
                        print("Can't Decode")
                        print(error)
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    //    Navigate home
    @IBAction func homeButton(_ sender: Any) {
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    //add destination button
    @IBAction func addDestinationButton(_ sender: Any) {
        var textField = UITextField()
        
        //dismiss keyboard
        textField.resignFirstResponder()
        
        let alert = UIAlertController(title: "Where would you like to go? Enter your new destination to search news", message: "", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .default){
            (cancel) in
            
        }
        
        let go = UIAlertAction(title: "Go", style: .default){
            (ok) in
            self.destination = textField.text
            
            //reload table with new destination news
            self.downloadJSON {
                print("Success")
                self.tableViewNews.reloadData()
            }
        }
        
        alert.addTextField {(text) in
            textField = text
            textField.placeholder = "Enter Destination"
        }
        
        alert.addAction(cancel)
        alert.addAction(go)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //tab bar news button
    @IBAction func newsTabBar(_ sender: Any) {

    }
    
    //tab bar direction button
    @IBAction func directionTabBar(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "MapVC") as! MapViewController
        controller.destination = ""
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    //tab bar weather button
    @IBAction func weatherTabBar(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "WeatherVC") as! WeatherViewController
        controller.destination = ""
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
}

