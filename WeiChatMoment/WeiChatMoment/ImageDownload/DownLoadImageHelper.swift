//
//  DownLoadImageHelper.swift
//  WeiChatMoment
//
//  Created by lin kang on 2019/11/8.
//  Copyright © 2019 TW. All rights reserved.
//

import UIKit

class DownLoadImageHelper {

    
    fileprivate var semaphore:DispatchSemaphore = DispatchSemaphore(value: 1)

    class var sharedInstance : DownLoadImageHelper {
      struct Loader {
        static let instance = DownLoadImageHelper()
      }
      return Loader.instance
    }
    
    //Task Cache
    private lazy var operationCache : [String:URLSessionDataTask] = {
        let operation = [String:URLSessionDataTask]()
        return operation
    }()
    
    //Memory Cache
    private lazy var imageCache : [String : Data] = {
        let images = [String : Data]()
        return images
    }()
    
    //DownLoad Image
    func loadImage(urlString: String, completionHandler:@escaping (_ image: UIImage?, _ url: String) -> ()){

          //Task exit
           if operationCache[urlString] != nil {
               return
           }
    
          //from memeory
           let data = imageCache[urlString]
           if data != nil {
               let image = UIImage(data: data!)
               if image != nil {
                completionHandler(image, urlString)
                   return
               }
           }
           
           //from file
           let imageCachePath = urlString.appendImageCachePath()
           let cacheData = try? Data(contentsOf: imageCachePath)
           if cacheData != nil {
              let cacheImage = UIImage(data: cacheData!)
              if cacheImage != nil {
                ThreadsLock.LOCK(self.semaphore)
                 //save image to memeory
                self.imageCache[urlString] = cacheData;
                ThreadsLock.UNLOCK(self.semaphore)
                completionHandler(cacheImage, urlString)
                  return
              }
           }
    
          //download image
           DispatchQueue.global().async{
                [weak self] in
               let downloadTask: URLSessionDataTask = URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: { (imageData, response, error) in
                  if (error != nil) {
                     completionHandler(nil, urlString)
                     return
              }
               //get the image
               if let data = imageData {
                   let image = UIImage(data: data)
                                          DispatchQueue.main.async {
                                              completionHandler(image, urlString)
                                          }
                    //remove task cache
                    if let strongSelf = self {
                       ThreadsLock.LOCK(strongSelf.semaphore)
                       strongSelf.operationCache.removeValue(forKey: urlString);
                        //save image to memeory
                       strongSelf.imageCache[urlString] = data;
                       ThreadsLock.UNLOCK(strongSelf.semaphore)
                }
                  
                //save to file
                do {
                    try? data.write(to:
                        imageCachePath, options: Data.WritingOptions.completeFileProtectionUntilFirstUserAuthentication)
                }
                return
               }
           })
        
           if let strongSelf = self {
              ThreadsLock.LOCK(strongSelf.semaphore)
              strongSelf.operationCache[urlString] = downloadTask;
              ThreadsLock.UNLOCK(strongSelf.semaphore)
           }
           downloadTask.resume()
         }
    }

}
