//
//  ViewController.swift
//  YKPhotoMediaBroswer
//
//  Created by kang lin on 2018/2/26.
//  Copyright © 2018年 康林. All rights reserved.
//

import UIKit
import Photos
//长图，gif图，相册图，本地图，视频播放

class ViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    let tableView:UITableView = UITableView()
    var dataSource = [YKMediaObject]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "图片浏览"
        
        //Section 1
        var imageOb = YKMediaObject()
        imageOb.path = "http://wmimg.sc115.com/wm/pic/1604/1604yrzhgpb3j4f.jpg"
        dataSource.append( imageOb )
        
        imageOb = YKMediaObject()
        imageOb.path = "http://wmimg.sc115.com/wm/pic/1604/1604ig4im5f3njj.jpg"
        dataSource.append( imageOb )

        imageOb = YKMediaObject()
        imageOb.path = "http://wmimg.sc115.com/wm/pic/1604/16045kx4uwfxord.jpg"
        dataSource.append( imageOb )

        //Section 2
        imageOb = YKMediaObject()
        imageOb.path = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1519980888651&di=1747dc8d4dae72176057984c8030f831&imgtype=0&src=http%3A%2F%2Fimg1.utuku.china.com%2Fuploadimg%2Fgame%2F20160302%2F59662447-fe04-44d5-b590-dcc2665416e5.gif"
        dataSource.append( imageOb )

        imageOb = YKMediaObject()
        imageOb.path = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1519980888652&di=b342a30434af6b87bb595e11ad27ec08&imgtype=0&src=http%3A%2F%2Fww1.sinaimg.cn%2Fmw690%2Fc2adb464tw1ethcbfolxlg208w06oqv6.gif"
        dataSource.append( imageOb )

        imageOb = YKMediaObject()
        imageOb.path = "http://wmimg.sc115.com/wm/pic/1604/160445kyw2rolb1.jpg"
        dataSource.append( imageOb )
        
        //Section 3
        var path = Bundle.main.path(forResource: "local", ofType: "jpg");
        imageOb = YKMediaObject()
        imageOb.path = path
        dataSource.append( imageOb )
        
        path = Bundle.main.path(forResource: "local1", ofType: "jpg");
        imageOb = YKMediaObject()
        imageOb.path = path
        dataSource.append( imageOb )
        
        imageOb = YKMediaObject()
        imageOb.path = "http://wmimg.sc115.com/wm/pic/1604/160445kyw2rolb1.jpg"
        dataSource.append( imageOb )
        
        tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        let rightBar = UIBarButtonItem(title: "从相册", style: .plain, target: self, action: #selector(selectFromAlum));
        self.navigationItem.rightBarButtonItem = rightBar
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @objc func selectFromAlum()  {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true) {
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imageURL = info[UIImagePickerControllerReferenceURL]
        let asset = PHAsset.fetchAssets(withALAssetURLs: [imageURL as! URL], options: nil).firstObject
        picker.dismiss(animated: false, completion: nil)
        let imageOb = YKMediaObject()
        imageOb.imageAsset = asset
        YKMediaScrollerView.showBroswer(dataSource:[imageOb] , atIndex: 1)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool){
        
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count/3 + (dataSource.count%3>0 ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "一般图"
        }else if section == 1{
            return "Gif图"
        }else if section == 2{
            return "长图本地图片"
        }else if section == 3{
            return "视频"
        }
        return ""
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellId = "cid"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? ImageTableViewCell
        if cell == nil {
            cell = ImageTableViewCell(style: .default, reuseIdentifier: cellId)
            cell?.selectionStyle = .none
        }
        let i = indexPath.section * 3
        let ob1 = dataSource[i];
        var url1 = URL(string: ob1.path!)!
        if (ob1.path?.hasPrefix("/var/"))! {
            url1 = URL(fileURLWithPath: ob1.path!)
        }
        cell!.button1.setImage(url: url1)
        cell?.button1.tag = i
        
        //记录点击位置
        ob1.fromView = cell?.button1
        cell?.button1.addTarget(self, action: #selector(imageCliking(_:)), for: .touchUpInside)
        
        if dataSource.count > i + 1 {
            let ob2 = dataSource[i+1]
            var url2 = URL(string: ob2.path!)!
            if (ob2.path?.hasPrefix("/var/"))! {
                url2 = URL(fileURLWithPath: ob2.path!)
            }
            cell?.button2.setImage(url: url2)
            cell?.button2.tag = i+1
            
            //记录点击位置
            ob2.fromView = cell?.button2
            cell?.button2.addTarget(self, action: #selector(imageCliking(_:)), for: .touchUpInside)
            
        }
        
        if dataSource.count > i + 2 {
            let ob3 = dataSource[i+2]
            var url3 = URL(string: ob3.path!)!
            if (ob3.path?.hasPrefix("/var/"))! {
                url3 = URL(fileURLWithPath: ob3.path!)
            }
            cell?.button3.setImage(url: url3)
            cell?.button3.tag = i+2
            //记录点击位置
            ob3.fromView = cell?.button3
            cell?.button3.addTarget(self, action: #selector(imageCliking(_:)), for: .touchUpInside)
        }

        return cell!
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 150;
    }
    
    @objc func imageCliking(_ sender:UIButton)  {
        YKMediaScrollerView.showBroswer(dataSource: dataSource, atIndex: sender.tag + 1)
    }
    
}
