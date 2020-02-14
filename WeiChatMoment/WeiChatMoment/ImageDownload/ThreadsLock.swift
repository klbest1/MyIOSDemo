//
//  ThreadsLock.swift
//  WeiChatMoment
//
//  Created by lin kang on 2019/11/8.
//  Copyright © 2019 TW. All rights reserved.
//

import UIKit

class ThreadsLock {

    class func LOCK(_ semaphor:DispatchSemaphore) {
        semaphor.wait()
    }
    
    class func UNLOCK(_ semaphor:DispatchSemaphore) {
        semaphor.signal()
    }
}
