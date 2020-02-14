//
//  String_Extends.swift
//  WeiChatMoment
//
//  Created by lin kang on 2019/11/8.
//  Copyright © 2019 TW. All rights reserved.
//

import Foundation

extension  String {
    //image Path
    func appendImageCachePath()->URL{
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let pathComponents = (self as NSString).pathComponents
        if (pathComponents.count < 2){
            return URL(fileURLWithPath: "")
        }
        let lastPathComponent = pathComponents[pathComponents.count - 1]
        let imageComponents = pathComponents[2..<(pathComponents.count - 1)]
        var folderPath = documentDirectory;
        for path in imageComponents{
            folderPath = folderPath.appendingPathComponent(path)
        }
        createIfNotExist(path: folderPath)

        let imagePath = folderPath.appendingPathComponent(lastPathComponent)
        return imagePath
    }
           
    //create file
    private func createIfNotExist(path : URL){
        if !FileManager.default.fileExists(atPath: path.absoluteString) {
            try! FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
        }
    }

}
