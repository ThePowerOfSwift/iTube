//
//  CellConfigurer.swift
//  iTube
//
//  Created by Frezy Stone Mboumba on 6/24/16.
//  Copyright © 2016 Frezy Stone Mboumba. All rights reserved.
//

import Foundation
import UIKit


struct ThumbnailDownloader{
    
    func downloader(urlString: String) -> NSData?{
     
        var thumbnailData = NSData()
        
        let videoThumbnailUrl = NSURL(string: urlString)
        
        if videoThumbnailUrl != nil {
            
            let request = NSURLRequest(URL: videoThumbnailUrl!)
            
            let session = NSURLSession.sharedSession()
            
            let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if error == nil {
                        if data != nil {
                          thumbnailData = data!
                        }}
                })
            })
                
            dataTask.resume()
            
            
        }

     return thumbnailData
    }
    
    
}