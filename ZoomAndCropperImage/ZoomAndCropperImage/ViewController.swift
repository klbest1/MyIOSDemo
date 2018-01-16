//
//  ViewController.swift
//  ZoomAndCropperImage
//
//  Created by kang lin on 2017/12/5.
//  Copyright © 2017年 超凡股份. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var scrollView = UIScrollView()
    var imageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        scrollView.addSubview(imageView)
        scrollView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        scrollView.center = self.view.center
        scrollView.delegate = self;
        self.view.addSubview(scrollView)
        
        imageView.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
        imageView.image = #imageLiteral(resourceName: "bg")
        imageView.isUserInteractionEnabled = true;
        scrollView.addSubview(imageView)
    
        let bt = UIButton()
        bt.frame = CGRect(x: 100, y: 130, width: 60, height: 44)
        bt.setTitle("点我啊", for: .normal)
        bt.backgroundColor = UIColor.red
        bt.addTarget(self, action: #selector(taping(sender:)), for: .touchUpInside)

        let cropButton = UIButton()
        cropButton.frame = CGRect(x: 100, y: self.view.bounds.size.height - 100, width: 60, height: 44)
        cropButton.setTitle("裁剪", for: .normal)
        cropButton.backgroundColor = UIColor.red
        cropButton.addTarget(self, action: #selector(crop(_:)), for: .touchUpInside)
        self.view.addSubview(cropButton)
        self.view.addSubview(bt)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func taping( sender:UITapGestureRecognizer)  {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true) {
            
        }
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView;
    }
    
    func scrollViewContentSize()->CGSize  {
        var size = scrollView.contentSize
        if size.width > scrollView.frame.size.width{
            size.width = scrollView.frame.size.width
        }
        
        if size.height > scrollView.frame.size.height {
            size.height = scrollView.frame.size.height
        }
        
        if size.width < 0 {
            size.width = 0
        }
        if size.height < 0 {
            size.height = 0
        }
        return size;
    }
    
    var vivibleRect:CGRect{
        return CGRect(x: scrollView.contentInset.left, y: scrollView.contentInset.top, width: scrollView.bounds.size.width-scrollView.contentInset.left-scrollView.contentInset.right, height: scrollView.bounds.size.height-scrollView.contentInset.top-scrollView.contentInset.bottom)
    }
    
    var scaledRect:CGRect{
        return CGRect(x: (scrollView.contentInset.left + scrollView.contentOffset.x)/scrollView.zoomScale, y: (scrollView.contentOffset.y + scrollView.contentOffset.y)/scrollView.zoomScale, width: vivibleRect.size.width/scrollView.zoomScale, height: vivibleRect.size.height/scrollView.zoomScale)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let size = scrollViewContentSize()
        let centerPoint:CGPoint = CGPoint(x:(scrollView.frame.width/2 - size.width/2 ),y:(scrollView.frame.height/2 - size.height/2));
        scrollView.contentInset = UIEdgeInsetsMake(centerPoint.y, centerPoint.x, centerPoint.y, centerPoint.x)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
//        imageView.contentMode = .center
        imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height);
        
        scrollView.contentSize = image.size
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 1
        scrollView.zoomScale = 1
        
        //计算最大最小缩放量
        let scrollViewFrame = scrollView.frame
        let scalWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scalHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let miniScal = min(scalWidth, scalHeight)
        
        scrollView.minimumZoomScale = miniScal
        scrollView.maximumZoomScale = 1
        scrollView.zoomScale = miniScal
        
        let size = scrollViewContentSize()
        let centerPoint:CGPoint = CGPoint(x:(scrollView.frame.width/2 - size.width/2 ),y:(scrollView.frame.height/2 - size.height/2));
        scrollView.contentInset = UIEdgeInsetsMake(centerPoint.y, centerPoint.x, centerPoint.y, centerPoint.x)
        
        picker.dismiss(animated: false, completion: nil)
    }
    
    func centerImgeView()  {
        let imageSize = imageView.image!.size
        var imageFrame = imageView.frame
        if imageSize.width < scrollView.bounds.size.width {
            imageFrame.origin.x = (scrollView.bounds.size.width - imageSize.width)/2
        }else{
            imageFrame.origin.x = 0
        }
        
        if imageSize.height < scrollView.bounds.size.height{
            imageFrame.origin.y = (scrollView.bounds.size.height - imageSize.height)/2
        }else{
            imageFrame.origin.y = 0
        }
        imageView.frame = imageFrame;
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool){
        
    }
    
    @objc func crop(_ sender:UIButton)  {
        let detailConrol =  YKDetailViewController()
        detailConrol.imageView.image = self.imageView.image!.ic_imageInRect(scaledRect)!;
        self.navigationController?.pushViewController(detailConrol, animated: true)
    }
    

}

