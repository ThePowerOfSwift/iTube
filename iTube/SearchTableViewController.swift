//
//  SearchTableViewController.swift
//  iTube
//
//  Created by Frezy Stone Mboumba on 6/25/16.
//  Copyright © 2016 Frezy Stone Mboumba. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, SearchModelDelegate, UISearchBarDelegate {

   
    var model = SearchModel()
    var videosArray = [LastVideos]()
    var channelArray = [Channel]()
    var searchController: UISearchController!
    var searchText: String = "Bentley"
    var segmentedControl: HMSegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        model.delegate = self
        model.getChannels(0, searchText: searchText)
        
        segmentedControl = HMSegmentedControl(sectionTitles: ["Channels","Videos"])
        segmentedControl.frame = CGRectMake(10, 10, 300, 60)
        segmentedControl.backgroundColor = UIColor.groupTableViewBackgroundColor()
        segmentedControl.tintColor = UIColor.darkGrayColor()
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(SearchTableViewController.segmentedAction), forControlEvents: UIControlEvents.ValueChanged)
        tableView.tableHeaderView = segmentedControl
        
            }


    // MARK: - Table view data source

    func segmentedAction(){
        
        if (segmentedControl.selectedSegmentIndex == 0){
         model.getChannels(0, searchText:searchText)
            self.tableView.reloadData()
        } else if (segmentedControl.selectedSegmentIndex == 1){
         model.getVideos(1, searchText:searchText)
            self.tableView.reloadData()
        }
        
        
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if  (segmentedControl.selectedSegmentIndex == 0){
            return 131}
        return 204.5
        }
    

    @IBAction func searchAction(sender: AnyObject) {
   
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.text = searchText
        searchController.searchBar.translucent = false
        searchController.searchBar.barTintColor = UIColor(red: 50/255.5, green: 60/255.5, blue: 72/255.5, alpha: 1.0)
    
        self.presentViewController(searchController, animated: true, completion: nil)
    
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchController.resignFirstResponder()
        searchController.dismissViewControllerAnimated(true, completion: nil)
        
        
        searchText = searchBar.text!
           if (segmentedControl.selectedSegmentIndex == 0){
            model.getChannels(0, searchText:searchText)
            self.tableView.reloadData()
        } else if (segmentedControl.selectedSegmentIndex == 1){
            model.getVideos(1, searchText:searchText)
            self.tableView.reloadData()
        }
        
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var numberOfRows = 0
        
        switch (segmentedControl.selectedSegmentIndex){
        case 0: numberOfRows = channelArray.count
           
        case 1: numberOfRows = videosArray.count
            
        default: break
            
        }
        
        return numberOfRows
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (segmentedControl.selectedSegmentIndex == 0){

        let cell = tableView.dequeueReusableCellWithIdentifier("channelCell", forIndexPath: indexPath) as! ChannelTableViewCell
            
            cell.channelTitleLabel.text = channelArray[indexPath.row].channelTitle
            let urlString = channelArray[indexPath.row].channelImageUrl
            let url = NSURL(string: urlString)
            if let url = url {
                let request = NSURLRequest(URL: url)
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                    dispatch_async(dispatch_get_main_queue(), {
                        if error == nil {
                            if let data = data{
                                cell.channeImageView.image = UIImage(data: data)
                            }
                            
                            
                        }else {
                            print(error!.localizedDescription)
                        }
                    })
                    
                })
                task.resume()
            }

            return cell

        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("videoCell", forIndexPath: indexPath) as! VideoTableViewCell
            cell.videoTitleLabel.text = videosArray[indexPath.row].title
            
            let urlString = videosArray[indexPath.row].thumbnailUrl
            let url = NSURL(string: urlString)
            if let url = url {
                let request = NSURLRequest(URL: url)
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                    dispatch_async(dispatch_get_main_queue(), {
                        if error == nil {
                            if let data = data{
                                cell.videoImageView.image = UIImage(data: data)
                            }
                            
                            
                        }else {
                            print(error!.localizedDescription)
                        }
                    })
                    
                })
                task.resume()
            }

            return cell
        }
        // Configure the cell...

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if segmentedControl.selectedSegmentIndex == 1 {
            performSegueWithIdentifier("showVideo2", sender: self)
        }else if segmentedControl.selectedSegmentIndex == 0 {
            performSegueWithIdentifier("showPlaylistForChannel", sender: self)

        }
    }
    func dataAreReady() {
        if (segmentedControl.selectedSegmentIndex == 0){
            self.channelArray = model.channelArray
            self.tableView.reloadData()
        } else if (segmentedControl.selectedSegmentIndex == 1){
            self.videosArray = model.videosArray
            self.tableView.reloadData()
        }
        
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segmentedControl.selectedSegmentIndex == 1{
            if segue.identifier == "showVideo2"{
                let vc = segue.destinationViewController as! VideoDetailsTableViewController
                let indexPath = tableView.indexPathForSelectedRow!
                vc.vidId = videosArray[indexPath.row].id
                vc.vidTitle = videosArray[indexPath.row].title
                vc.vidDescription = videosArray[indexPath.row]._description
            }
        } else if segmentedControl.selectedSegmentIndex == 0 {
            if segue.identifier == "showPlaylistForChannel"{
                let vc = segue.destinationViewController as! PlaylistVideosTableViewController
                let indexPath = tableView.indexPathForSelectedRow!
                vc.playlistId = channelArray[indexPath.row].channelId
                
            }
        }
    }
}
