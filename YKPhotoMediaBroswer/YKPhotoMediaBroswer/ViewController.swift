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
        imageOb.path = "https://f11.baidu.com/it/u=1579226703,4165018773&fm=207"
        dataSource.append( imageOb )
        
        imageOb = YKMediaObject()
        imageOb.path = "http://pic2.cxtuku.com/00/01/91/b837b88378fc.jpg"
        dataSource.append( imageOb )

        imageOb = YKMediaObject()
        imageOb.path = "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1422793712,2842733263&fm=26&gp=0.jpg"
        dataSource.append( imageOb )

        //Section 2  gif图片
        imageOb = YKMediaObject()
        imageOb.path = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1547017676111&di=2a91d3779e2a87cfd84250c7414c44c9&imgtype=0&src=http%3A%2F%2Fmmbiz.qpic.cn%2Fmmbiz_gif%2Fttebm7ceEvgsZPqAVAOqLYv6AgfPDXS3Yq6iauuTkibZgWNw5Rey6h9exk95TyldmWaDG0JAeCGLxqMtV6htQMFA%2F640%3Fwx_fmt%3Dgif"
        dataSource.append( imageOb )

        imageOb = YKMediaObject()
        imageOb.path = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1547017906227&di=8248bb5f36dcb62dc466f450958eeac8&imgtype=0&src=http%3A%2F%2Fn.sinaimg.cn%2Fgames%2Ftransform%2F20160819%2FYmeB-fxvecqa7250759.gif"
        dataSource.append( imageOb )

        imageOb = YKMediaObject()
        imageOb.path = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1547017724621&di=82de933efd94e93a37dea8e2fc298c32&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01ce0c597efd4f000000212931fcd4.gif"
        dataSource.append( imageOb )
        
        //Section 3 长图片
        var path = Bundle.main.path(forResource: "local", ofType: "jpg");
        imageOb = YKMediaObject()
        imageOb.path = path
        dataSource.append( imageOb )
        
        path = Bundle.main.path(forResource: "local1", ofType: "jpg");
        imageOb = YKMediaObject()
        imageOb.path = path
        dataSource.append( imageOb )
        
        imageOb = YKMediaObject()
        imageOb.path = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1547018076626&di=b638cc2641155c66da0f21357cca70f1&imgtype=0&src=http%3A%2F%2Fpic46.nipic.com%2F20140816%2F13702399_105028303000_2.jpg"
        dataSource.append( imageOb )
        
        //Section 4 视频
        path = Bundle.main.path(forResource: "vbg1", ofType: "png");
        imageOb = YKMediaObject()
        imageOb.path = path
        imageOb.vedioPath = "http://mobaliyun.res.mgtv.com/new_video/2018/02/28/1012/036FD5450AB291864AF0ADB5E5C3D0BA_20180228_1_1_643.mp4"
        dataSource.append( imageOb )
        
        path = Bundle.main.path(forResource: "vbg2", ofType: "png");
        imageOb = YKMediaObject()
        imageOb.path = path
        imageOb.vedioPath = "http://mobaliyun.res.mgtv.com/new_video/2018/02/27/1012/BC614A149EFD1E2F5F9127B7A45232EA_20180227_1_1_666.mp4"
        dataSource.append( imageOb )
        
        //本地视频
        path = Bundle.main.path(forResource: "movie", ofType: "mp4");
        imageOb = YKMediaObject()
        imageOb.vedioPath = path
        //全屏展示
        imageOb.isFullScreen = true;
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
            return "长图、本地图片"
        }else if section == 3{
            return "网络、本地视频"
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
        if var url1 = URL(string: ob1.path ?? ""){
            if (ob1.path?.hasPrefix("/var/"))! ||  (ob1.path?.hasPrefix("/Users/"))!{
                url1 = URL(fileURLWithPath: ob1.path!)
            }
            cell!.button1.setImage(url: url1)
        }

        cell?.button1.tag = i
        if ob1.vedioPath != nil {
            cell?.button1.playImageView.isHidden = false
        }
        
        //记录点击位置 重要！！！
        ob1.fromView = cell?.button1
        cell?.button1.addTarget(self, action: #selector(imageCliking(_:)), for: .touchUpInside)
        
        if dataSource.count > i + 1 {
            let ob2 = dataSource[i+1]
            if var url2 = URL(string: ob2.path ?? ""){
                if (ob2.path?.hasPrefix("/var/"))! || (ob2.path?.hasPrefix("/Users/"))! {
                    url2 = URL(fileURLWithPath: ob2.path!)
                }
                cell?.button2.setImage(url: url2)
            }
            cell?.button2.tag = i+1
            
            //记录点击位置 重要！！！
            ob2.fromView = cell?.button2
            cell?.button2.addTarget(self, action: #selector(imageCliking(_:)), for: .touchUpInside)
            
            if ob2.vedioPath != nil {
                cell?.button2.playImageView.isHidden = false
            }
        }
        
        if dataSource.count > i + 2 {
            let ob3 = dataSource[i+2]
            if var  url3 = URL(string: ob3.path ?? ""){
                if (ob3.path?.hasPrefix("/var/"))! || (ob3.path?.hasPrefix("/Users/"))!{
                    url3 = URL(fileURLWithPath: ob3.path!)
                }
                cell?.button3.setImage(url: url3)
            }
       
            cell?.button3.tag = i+2
            //记录点击位置 重要！！！
            ob3.fromView = cell?.button3
            cell?.button3.addTarget(self, action: #selector(imageCliking(_:)), for: .touchUpInside)
            
            if ob3.vedioPath != nil {
                cell?.button3.playImageView.isHidden = false
            }
        }

        return cell!
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 150;
    }
    
    @objc func imageCliking(_ sender:YKGifButton)  {
//        let ob = dataSource[sender.tag]
//        if ob.path == nil && ob.vedioPath != nil{
//            let welcomePage = YKWelcomePageViewController()
//            welcomePage.setVedio(ob: ob)
//            self.navigationController?.pushViewController(welcomePage, animated: true)
//        }else{
//            var tempDataSource = dataSource
//            tempDataSource.removeLast()
        let ob = dataSource[sender.tag]
        ob.thumbImage = sender.gifImageView.image
        YKMediaScrollerView.showBroswer(dataSource: dataSource, atIndex: sender.tag + 1)
//        }
    }
    
}
