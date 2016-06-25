//
//  ChannelModel.swift
//  iTube
//
//  Created by Frezy Stone Mboumba on 6/25/16.
//  Copyright © 2016 Frezy Stone Mboumba. All rights reserved.
//

import UIKit
import Alamofire


protocol ChannelModelDelegate {
    func channelIsReady()
}



class ChannelModel: NSObject {
    
    private var API_KEY: String = "AIzaSyBarZbC-7Ho50utA5zRP2_n7WJCwF6njh4"
    private let urlString: String = "https://www.googleapis.com/youtube/v3/channels"
    private let channelId: String = "UCBJycsmduvYEL83R_U4JriQ"
    
    var ChannelArray = [Channel]()
    
    var delegate: ChannelModelDelegate!
    
    func getChannel() {
        
        Alamofire.request(.GET, urlString, parameters: ["key":API_KEY, "part": "snippet,brandingSettings,statistics","id":channelId], encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response) in
            
            if let JSON = response.result.value{
                var channelResult = [Channel]()
                for channelObj in JSON["items"] as! NSArray{
                    
                    let channel = Channel()
                    channel.channelTitle = channelObj.valueForKeyPath("snippet.title") as! String
                    channel.channelDescription = channelObj.valueForKeyPath("snippet.description") as! String
                    channel.channelNumberOfViews = channelObj.valueForKeyPath("statistics.viewCount") as! String
                    channel.channelNumberOFVideos = channelObj.valueForKeyPath("statistics.videoCount") as! String
                    channel.channelNumberOfSuscribers = channelObj.valueForKeyPath("statistics.subscriberCount") as! String
                    
                    if channelObj.valueForKeyPath("snippet.thumbnails.high.url") != nil {
                        channel.channelImageUrl = channelObj.valueForKeyPath("snippet.thumbnails.high.url") as! String
                    } else if channel.valueForKeyPath("snippet.thumbnails.medium.url") != nil {
                        channel.channelImageUrl = channelObj.valueForKeyPath("snippet.thumbnails.medium.url") as! String
                        
                    }else{
                        channel.channelImageUrl = channelObj.valueForKeyPath("snippet.thumbnails.default.url") as! String
                    }
                    
                    if channelObj.valueForKeyPath("brandingSettings.image.bannerMobileHdImageUrl") != nil {
                        channel.channelBannerImageUrl = channelObj.valueForKeyPath("brandingSettings.image.bannerMobileHdImageUrl") as! String
                    } else if channelObj.valueForKeyPath("brandingSettings.image.bannerMobileImageUrl") != nil {
                        channel.channelBannerImageUrl = channelObj.valueForKeyPath("brandingSettings.image.bannerMobileImageUrl") as! String
                        
                    }else{
                        channel.channelBannerImageUrl = channelObj.valueForKeyPath("brandingSettings.image.bannerImageUrl") as! String
                    }
                    channelResult.append(channel)
                    
                }
                
                self.ChannelArray = channelResult
                if self.delegate != nil {
                    self.delegate.channelIsReady()
                }
            }
        }
        
    }
    
    
}
