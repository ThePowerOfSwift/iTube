//
//  LastVideosModel.swift
//  iTube
//
//  Created by Frezy Stone Mboumba on 6/23/16.
//  Copyright © 2016 Frezy Stone Mboumba. All rights reserved.
//

import UIKit
import Alamofire


protocol LastVideosModelDelegate {
    func lastVideosAreReady()
}


class LastVideosModel: NSObject {

    private var API_KEY = "AIzaSyBarZbC-7Ho50utA5zRP2_n7WJCwF6njh4"
    private var urlString = "https://www.googleapis.com/youtube/v3/playlistItems"
    private var playlist_Id = "UUBJycsmduvYEL83R_U4JriQ"
    var delegate: LastVideosModelDelegate!
 
    var lastVideos = [LastVideos]()
    
    
    
    func getLastVideos(){
        
        Alamofire.request(.GET, urlString, parameters: ["part":"snippet","maxResults":"30","key":API_KEY, "playlistId": playlist_Id], encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response) in
            
            if let jsonResult = response.result.value{
                
                var videosArray = [LastVideos]()

                for video in jsonResult["items"] as! NSArray{
                    
                    let lastVideo = LastVideos()
                    
                    lastVideo.title = video.valueForKeyPath("snippet.title") as! String
                    lastVideo._description = video.valueForKeyPath("snippet.description") as! String
                    lastVideo.id = video.valueForKeyPath("snippet.resourceId.videoId") as! String
                    
                    if video.valueForKeyPath("snippet.thumbnails.maxres.url") != nil {
                        lastVideo.thumbnailUrl = video.valueForKeyPath("snippet.thumbnails.maxres.url") as! String
                    }else if video.valueForKeyPath("snippet.thumbnails.standard.url") != nil {
                        lastVideo.thumbnailUrl = video.valueForKeyPath("snippet.thumbnails.standard.url") as! String
                    }else if video.valueForKeyPath("snippet.thumbnails.high.url") != nil {
                        lastVideo.thumbnailUrl = video.valueForKeyPath("snippet.thumbnails.high.url") as! String
                    }else if video.valueForKeyPath("snippet.thumbnails.medium.url") != nil {
                        lastVideo.thumbnailUrl = video.valueForKeyPath("snippet.thumbnails.medium.url") as! String
                    }else{
                        lastVideo.thumbnailUrl = video.valueForKeyPath("snippet.thumbnails.default.url") as! String
                    }
                    
                    videosArray.append(lastVideo)
                    
                }
                
                self.lastVideos = videosArray
                
                
                if self.delegate != nil {
                    self.delegate.lastVideosAreReady()
                    
                }
                

                
                
                
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
}