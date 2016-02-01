//
//  MoviesViewController.swift
//  MoviewViewer
//
//  Created by Héctor Rábago on 1/21/16.
//  Copyright © 2016 Héctor Rábago. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func resfreshButton(sender: UIButton) {
       
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        refreshControl.endRefreshing()
        self.networkErrorView.hidden = true
        
        print("Refreshing")
}
    var movies: [NSDictionary]?
    var genres: [NSDictionary]?
    var filteredData: [NSDictionary]?
    
    //var refreshControl: UIRefreshControl!
    var endpoint: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        filteredData = movies
        
        
        
        
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let genreUrl = NSURL(string: "http://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)")
        
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in

                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            
                            MBProgressHUD.hideHUDForView(self.view, animated: true)

                            
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            self.filteredData = responseDictionary["results"] as! [NSDictionary]
                            self.tableView.reloadData()
                            
                    }
                }
                if error != nil{
                    
                    self.networkErrorView.hidden = false
                    //self.networkErrorView.frame.size.height = 50
                }
                else {
                    self.networkErrorView.hidden = true
                }

        })
        task.resume()
        
        let request1 = NSURLRequest(URL: genreUrl!)
        let session1 = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task1: NSURLSessionDataTask = session1.dataTaskWithRequest(request1,
            completionHandler: { (dataOrNil, response, error) in
                
                if let data = dataOrNil {
                    if let responseDictionary1 = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary1)")

                            self.genres = responseDictionary1["genres"] as! [NSDictionary]

                            
                    }
                }
                
        })
        task1.resume()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if let movies = movies {
            
            return filteredData!.count
            
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = filteredData![indexPath.row]
        let title = movie["title"] as! String 
        let overview = movie["overview"] as! String
        
        let baseUrl = "http://image.tmdb.org/t/p/w500/"
        
        if let poster_path = movie["poster_path"] as? String {
        
        let imageUrl = NSURL(string: baseUrl + poster_path)
        cell.posterView.setImageWithURL(imageUrl!)
            
        }
        
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.selectionStyle = .None
        
        print("row \(indexPath.row)")
        return cell
        
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                
                if let data = dataOrNil {
                    
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                            
                            
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            self.tableView.reloadData()
                            
                    }
                   
                }
                if error != nil{
                    
                    self.networkErrorView.hidden = false
                    self.networkErrorView.frame.size.height = 50
                }
        })
        task.resume()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            filteredData = movies
        } else {
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            
            filteredData = movies!.filter({(movies: NSDictionary) -> Bool in
                // If dataItem matches the searchText, return true to include it
                if (movies["title"] as! String).rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        tableView.reloadData()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        
        let genre_ids = movie["genre_ids"] as? NSArray
        let mainGenreId = genre_ids?[0] as? Int
        let strGenreId = NSString(format: "%d",mainGenreId!)
        
        var count = 0
        var moviegenre = 6
        
        for genreNames in genres! {
            for (id, _ ) in genreNames{
                let idNum = id as! String
                
                if (strGenreId == idNum) {
                    print("\(idNum) and \(strGenreId) ")
                    
                    moviegenre = count
                }
                count = count + 1
            }
        }
        let genre = genres![moviegenre]
        
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
        detailViewController.genre = genre
        
        
        print("prepare for segue called")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
