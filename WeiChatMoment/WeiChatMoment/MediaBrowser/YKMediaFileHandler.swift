//
//  YKMediaFileHandler.swift
//  WeiChatMoment
//
//  Created by lin kang on 2019/11/7.
//  Copyright © 2019 TW. All rights reserved.
//

import Foundation

let MediaPathSuffix = "Media"

class YKMediaFileHandler: NSObject {

    class func getMediaVedioSavePath()->String{
        do{
          let documentPath =  try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
          let mediaPath = documentPath.appendingPathComponent(MediaPathSuffix)
            if !FileManager.default.fileExists(atPath: mediaPath.absoluteString) {
                do{
                    try  FileManager.default.createDirectory(at: mediaPath, withIntermediateDirectories: true, attributes: nil)
                    
                }catch {
                    
                }
            }
            
            return mediaPath.absoluteString
        }catch {
            print(error)
        }
        
        return ""
    }
    
    class func removeCache(){
        let path = getMediaVedioSavePath()
        do {
            try   FileManager.default.removeItem(atPath: path)
        }catch {
            
        }
    }
    
    class func cacheURLPath(path:String,vedioName:String) {
        UserDefaults.standard.setValue(vedioName, forKey: path)
    }
    
    class func getCacheURLPath(path:String)->URL? {
        guard let vedioName = UserDefaults.standard.value(forKey: path) else {
            return nil
        }
        
        let vedioPath = URL(fileURLWithPath: getMediaVedioSavePath()).appendingPathComponent(vedioName as! String)
        
        return vedioPath
    }
}
