//
//  DetailViewController.swift
//  MoviewViewer
//
//  Created by Héctor Rábago on 1/29/16.
//  Copyright © 2016 Héctor Rábago. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var posterimageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    var movie: NSDictionary!
    var genre: NSDictionary!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let title = movie["title"] as? String
        titleLabel.text = title
        
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
        let release_date = movie["release_date"] as? String
        dateLabel.text = release_date
        
        let vote_average = movie["vote_average"] as? Float
        
        let str = NSString(format: "%.2f", vote_average!)
        let str2 = (str as! String) + " %"
        ratingLabel.text = str2
        
        let mainGenre = genre["name"] as? String
       genreLabel.text = mainGenre
        
        infoView.frame.origin.y = 575
        infoView.frame.size.height = overviewLabel.frame.size.height + titleLabel.frame.size.height + 50
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height + 50)



        
        let baseUrl = "http://image.tmdb.org/t/p/w500/"
        
        if let poster_path = movie["poster_path"] as? String {
            
            let imageUrl = NSURL(string: baseUrl + poster_path)
            posterimageView.setImageWithURL(imageUrl!)
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
