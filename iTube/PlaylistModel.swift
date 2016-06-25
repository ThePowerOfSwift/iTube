//
//  PlaylistModel.swift
//  iTube
//
//  Created by Frezy Stone Mboumba on 6/25/16.
//  Copyright © 2016 Frezy Stone Mboumba. All rights reserved.
//

import UIKit
import Alamofire



protocol PlaylistModelDelegate {
    func playlistsAreReady()
}




class PlaylistModel: NSObject {

    private var channelId: String = "UCBJycsmduvYEL83R_U4JriQ"
    private var API_KEY = "AIzaSyBarZbC-7Ho50utA5zRP2_n7WJCwF6njh4"
    private var url = "https://www.googleapis.com/youtube/v3/playlists"
    var playlistArray = [Playlist]()
    var delegate: PlaylistModelDelegate!
    
    func getPlaylists(){
        
        Alamofire.request(.GET, url, parameters: ["part":"snippet,contentDetails", "key": API_KEY,"maxResults":50, "channelId":channelId], encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response) in
            
            if let jsonResult = response.result.value {
                var arrayResult = [Playlist]()
                for playlist in jsonResult["items"] as! NSArray{
                    
                    let playlistObj = Playlist()
                    playlistObj.title = playlist.valueForKeyPath("snippet.title") as! String
                    playlistObj.id = playlist.valueForKeyPath("id") as! String
                    playlistObj.numberOfVideos = playlist.valueForKeyPath("contentDetails.itemCount") as! Int
                    
                    if playlist.valueForKeyPath("snippet.thumbnails.maxres.url") != nil {
                        playlistObj.thumbnailUrl = playlist.valueForKeyPath("snippet.thumbnails.maxres.url") as! String
                    }else if playlist.valueForKeyPath("snippet.thumbnails.standard.url") != nil {
                        playlistObj.thumbnailUrl = playlist.valueForKeyPath("snippet.thumbnails.standard.url") as! String
                    }else if playlist.valueForKeyPath("snippet.thumbnails.high.url") != nil {
                        playlistObj.thumbnailUrl = playlist.valueForKeyPath("snippet.thumbnails.high.url") as! String
                    }else if playlist.valueForKeyPath("snippet.thumbnails.medium.url") != nil {
                        playlistObj.thumbnailUrl = playlist.valueForKeyPath("snippet.thumbnails.medium.url") as! String
                    }else if  playlist.valueForKeyPath("snippet.thumbnails.default.url") != nil {
                        playlistObj.thumbnailUrl = playlist.valueForKeyPath("snippet.thumbnails.default.url") as! String
                    }
                    arrayResult.append(playlistObj)
                    
                }
                
                self.playlistArray = arrayResult
                if self.delegate != nil {
                    self.delegate.playlistsAreReady()
                }
                
            }
        }
        
        
        
        
    }
    
}
