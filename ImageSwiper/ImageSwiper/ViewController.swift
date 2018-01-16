//
//  ViewController.swift
//  ImageSwiper
//
//  Created by kang lin on 2018/1/3.
//  Copyright © 2018年 Jack. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    let imageContentView :YKIMageContentView = YKIMageContentView()
    var dataSrouce:[YKCellObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imageContentView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 400)
        imageContentView.delegate = self;
        self.view.addSubview(imageContentView);
        
        dataSrouce = createDataSource()
        imageContentView.reloadView();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createDataSource() -> [YKCellObject] {
        let urls = ["http://wmimg.sc115.com/wm/pic/1604/1604yrzhgpb3j4f.jpg",
                    "http://wmimg.sc115.com/wm/pic/1604/1604ig4im5f3njj.jpg",
                    "http://wmimg.sc115.com/wm/pic/1604/16045kx4uwfxord.jpg",
                    "http://wmimg.sc115.com/wm/pic/1604/1604dkvchqstttf.jpg",
                    "http://wmimg.sc115.com/wm/pic/1604/1604des0fx3wmix.jpg",
                    "http://wmimg.sc115.com/wm/pic/1604/160445kyw2rolb1.jpg"]
        
        var tDataSrouce = [YKCellObject]()
        for url in urls{
            let cellOb = YKCellObject()
            cellOb.url = url
            cellOb.title = "图片标题"
            tDataSrouce.append(cellOb);
        }
        
        return tDataSrouce;
    }
}

extension ViewController:ImageScrollerDelegate{
    func numerOfCells() -> Int {
        return dataSrouce.count
    }
    
    func cellForRowAtIndex(index: NSInteger,imageContentView:YKIMageContentView) -> YKImageViewCell {
        var cell = imageContentView.dqueueReuseCell()
        if cell == nil {
            cell = YKImageViewCell(frame: CGRect(x: 0, y: 0, width: 260, height: 300))
        }
        
        let proerpty = dataSrouce[index];
        cell?.titleLabel.text = "\(index)号女生😘";
        cell?.imageView.sd_setImage(with: URL(string: proerpty.url!)
            , completed: { (image, error, type, url) in
                if error != nil{
                    print("error:\(String(describing: error?.localizedDescription))")
                }
        })
        
        return cell!
    }
    
    func didSelectedCellAtIndex(index: NSInteger, cell: YKImageViewCell) {
        
    }
    
    func didSwipToLeft(index: NSInteger) {
        
    }
    
    func didSwipToRight(index: NSInteger) {
        
    }
    
    
}

