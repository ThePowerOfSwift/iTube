//
//  SearchModel.swift
//  iTube
//
//  Created by Frezy Stone Mboumba on 6/25/16.
//  Copyright © 2016 Frezy Stone Mboumba. All rights reserved.
//

import UIKit
import Alamofire

protocol SearchModelDelegate {
    func dataAreReady()
}



class SearchModel: NSObject {

    private var API_KEY: String = "AIzaSyBarZbC-7Ho50utA5zRP2_n7WJCwF6njh4"
    private let urlString: String = "https://www.googleapis.com/youtube/v3/search"
    var channelArray = [Channel]()
    var videosArray = [LastVideos]()
    var type = ["channel","videos"]
    var delegate: SearchModelDelegate!
    
    
    func getVideos(index: Int, searchText: String){
        Alamofire.request(.GET, urlString, parameters: ["key":API_KEY, "q":searchText, "type": type[index], "part":"snippet","maxResults": "50"] ,encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response) in
            
            
            if let jsonResult = response.result.value{
                var videosResult = [LastVideos]()
                
                for video in jsonResult["items"] as! NSArray{
                    
                    let videoObj = LastVideos()
                    
                    videoObj.title = video.valueForKeyPath("snippet.title") as! String
                    videoObj._description = video.valueForKeyPath("snippet.description") as! String
                    if video.valueForKeyPath("id.videoId") != nil {
                        videoObj.id = video.valueForKeyPath("id.videoId") as! String
                    }
                    
                    if video.valueForKeyPath("snippet.thumbnails.high.url") != nil {
                        videoObj.thumbnailUrl = video.valueForKeyPath("snippet.thumbnails.high.url") as! String
                    }else if video.valueForKeyPath("snippet.thumbnails.medium.url") != nil {
                        videoObj.thumbnailUrl = video.valueForKeyPath("snippet.thumbnails.medium.url") as! String
                    }else{
                        videoObj.thumbnailUrl = video.valueForKeyPath("snippet.thumbnails.default.url") as! String
                    }
                videosResult.append(videoObj)
                
                
                }
                self.videosArray = videosResult
                
                if self.delegate != nil {
                    self.delegate.dataAreReady()
                }
                
                
            }
        }
  
    }
    
    func getChannels(index: Int, searchText: String){
        
        Alamofire.request(.GET, urlString, parameters: ["key":API_KEY, "q":searchText, "type": type[index], "part":"snippet","maxResults": "50"] ,encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response) in
        
            if let jsonResult = response.result.value{
            var channelResult = [Channel]()
                
                for channel in jsonResult["items"] as! NSArray{

                    let channelObj = Channel()
                    
                    channelObj.channelTitle = channel.valueForKeyPath("snippet.title") as! String
                    channelObj.channelDescription = channel.valueForKeyPath("snippet.description") as! String
                    channelObj.channelId = channel.valueForKeyPath("id.channelId") as! String

                    if channel.valueForKeyPath("snippet.thumbnails.high.url") != nil {
                        channelObj.channelImageUrl = channel.valueForKeyPath("snippet.thumbnails.high.url") as! String
                    } else if channel.valueForKeyPath("snippet.thumbnails.medium.url") != nil {
                        channelObj.channelImageUrl = channel.valueForKeyPath("snippet.thumbnails.medium.url") as! String
                        
                    }else{
                        channelObj.channelImageUrl = channel.valueForKeyPath("snippet.thumbnails.default.url") as! String
                    }
                    channelResult.append(channelObj)

                
                }
            
            self.channelArray = channelResult
                if self.delegate != nil {
                    self.delegate.dataAreReady()
                }
            

            
            }
            
   
        
        }
        
        
        
        
    }
    
    
    
    
}
