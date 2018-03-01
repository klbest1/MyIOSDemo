//
//  ViewController.swift
//  YKPhotoMediaBroswer
//
//  Created by kang lin on 2018/2/26.
//  Copyright © 2018年 康林. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let tableView:UITableView = UITableView()
    var dataSource = [YKMediaObject]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "图片浏览"
        
        var imageOb = YKMediaObject()
        imageOb.path = "http://wmimg.sc115.com/wm/pic/1604/1604yrzhgpb3j4f.jpg"
        dataSource.append( imageOb )
        
        imageOb = YKMediaObject()
        imageOb.path = "http://wmimg.sc115.com/wm/pic/1604/1604ig4im5f3njj.jpg"
        dataSource.append( imageOb )

        imageOb = YKMediaObject()
        imageOb.path = "http://wmimg.sc115.com/wm/pic/1604/16045kx4uwfxord.jpg"
        dataSource.append( imageOb )

        imageOb = YKMediaObject()
        imageOb.path = "http://wmimg.sc115.com/wm/pic/1604/1604dkvchqstttf.jpg"
        dataSource.append( imageOb )

        imageOb = YKMediaObject()
        imageOb.path = "http://wmimg.sc115.com/wm/pic/1604/1604des0fx3wmix.jpg"
        dataSource.append( imageOb )

        imageOb = YKMediaObject()
        imageOb.path = "http://wmimg.sc115.com/wm/pic/1604/160445kyw2rolb1.jpg"
        dataSource.append( imageOb )
        
        tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellId = "cid"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? ImageTableViewCell
        if cell == nil {
            cell = ImageTableViewCell(style: .default, reuseIdentifier: cellId)
        }
        let i = indexPath.row * 3
        let ob1 = dataSource[i];
        let ob2 = dataSource[i+1]
        let ob3 = dataSource[i+2]
        let url1 = URL(string: ob1.path!)
        let url2 = URL(string: ob2.path!)
        let url3 = URL(string: ob3.path!)
        cell!.button1.sd_setImage(with: url1, for: .normal, completed: nil)
        cell?.button1.tag = i
        //记录点击位置
        ob1.fromView = cell?.button1
        cell?.button1.addTarget(self, action: #selector(imageCliking(_:)), for: .touchUpInside)
        
        cell!.button2.sd_setImage(with: url2, for: .normal, completed: nil)
        cell?.button2.tag = i+1
        //记录点击位置
        ob2.fromView = cell?.button2
        cell?.button2.addTarget(self, action: #selector(imageCliking(_:)), for: .touchUpInside)
        
        cell!.button3.sd_setImage(with: url3, for: .normal, completed: nil)
        cell?.button3.tag = i+2
        //记录点击位置
        ob3.fromView = cell?.button3
        cell?.button3.addTarget(self, action: #selector(imageCliking(_:)), for: .touchUpInside)

        return cell!
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 200;
    }
    
    @objc func imageCliking(_ sender:UIButton)  {
        YKMediaScrollerView.showBroswer(dataSource: dataSource, atIndex: sender.tag + 1)
    }
    
}
