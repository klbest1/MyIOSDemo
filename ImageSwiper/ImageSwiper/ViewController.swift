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
        let urls = ["https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2933647892,978329588&fm=26&gp=0.jpg",
                    "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=869142834,1817338985&fm=26&gp=0.jpg",
                    "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=597770600,712290306&fm=26&gp=0.jpg",
                    "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3293946031,1019132218&fm=26&gp=0.jpg",
                    "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1193644796,3942273060&fm=26&gp=0.jpg",
                    "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=730806580,2728988557&fm=26&gp=0.jpg"]
        
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

