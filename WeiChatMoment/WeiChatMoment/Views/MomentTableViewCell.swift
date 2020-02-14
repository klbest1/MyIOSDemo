//
//  MomentTableViewCell.swift
//  WeiChatMoment
//
//  Created by lin kang on 2019/11/8.
//  Copyright © 2019 TW. All rights reserved.
//

import UIKit

class MomentTableViewCell: YKBaseTableViewCell {

    weak var superTableView:UITableView?;
    @IBOutlet weak var headerImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var showAllButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var commentTableView: UITableView!
    
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var showAllButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewHight: NSLayoutConstraint!
    
    @IBOutlet weak var commentHeight: NSLayoutConstraint!
    weak var  momentInfo:MomentInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(UINib.init(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        commentTableView.register(UINib.init(nibName: "CommentTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "commentCell")

        collectionView.delegate = self;
        collectionView.dataSource = self;
        commentTableView.delegate = self;
        commentTableView.isScrollEnabled = false;
        commentTableView.dataSource = self;
        commentTableView.estimatedRowHeight = 30
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
     

    class func calculateHeight(_ property: Any)->CGFloat{
        if let momentInfo = property as? MomentInfo{
            
            if momentInfo.cellHeight > 0 {
                if(momentInfo.isExpand){
                    return momentInfo.cellHeight - UIFont.systemFont(ofSize: 17).lineHeight * 6 + momentInfo.contentHeight
                }
                return momentInfo.cellHeight
            }
            
            var cellHeight:CGFloat = 71;
            let safeFrame = UIApplication.shared.windows[0].safeAreaLayoutGuide.layoutFrame
            let width = (safeFrame.width  - 20 - 121 - 5 * 2);
            
            // contentHeight
            var contentHeight = momentInfo.content?.height(withConstrainedWidth: width, font: UIFont.systemFont(ofSize: 17)) ?? 0
            momentInfo.contentHeight = contentHeight - 20
            if(contentHeight > UIFont.systemFont(ofSize: 17).lineHeight * 6){
                contentHeight = UIFont.systemFont(ofSize: 17).lineHeight * 6
                // show all button
                cellHeight += 34
                cellHeight += 20
                
                momentInfo.isExpand = false;
                momentInfo.isShowAll = true
                momentInfo.showAllButtonHeight = 34
            }else{
                momentInfo.isShowAll = false
                momentInfo.showAllButtonHeight = 0
            }
            
            cellHeight += contentHeight
            cellHeight += 10
            
            //image height
            var imageHeight = width/1.5
            if let images = momentInfo.images
            {
                if images.count > 1 {
                    let rowCount:CGFloat = CGFloat((images.count-1)/3 + 1)
                    imageHeight = (width/3) * rowCount
                    let spaceHeight = (images.count-1)/3 * 5
                    imageHeight += CGFloat(spaceHeight);
                }
            }else{
                imageHeight = 0;
            }
            
            momentInfo.imageHeight = imageHeight
            cellHeight += imageHeight
            cellHeight += 20
            
            //comment height
            var commentHeight:CGFloat = 0
            momentInfo.comments?.forEach({ ( comment) in
                let height = CommentTableViewCell.getAttributeText(comment).height(withConstrainedWidth: width)
                commentHeight += height;
                commentHeight += 16
            })
            momentInfo.commentHeight = commentHeight
            cellHeight += commentHeight
            cellHeight += 30

            momentInfo.cellHeight = cellHeight
            return cellHeight
        }
        return 0
    }
    
    override func setCell(_ property: Any) {
           if let momentInfo = property as? MomentInfo{
            self.momentInfo = momentInfo;
       
            contentLabel.numberOfLines = momentInfo.isExpand ? 0 : 6
            contentHeight.constant = momentInfo.isExpand ?   momentInfo.contentHeight : self.contentLabel.font.lineHeight * 6
            collectionViewHight.constant = momentInfo.imageHeight;
            commentHeight.constant = momentInfo.commentHeight
            showAllButtonHeight.constant = momentInfo.showAllButtonHeight
            showAllButton.isHidden = !momentInfo.isShowAll
            
            collectionView.reloadData()
            commentTableView.reloadData()
            self.headerImageView.setWImage(urlStr: momentInfo.sender?.avatar);
            self.nameLabel.text = momentInfo.sender?.nick
            self.contentLabel.text = momentInfo.content
            
//            UIApplication.shared.statusBarFrame
           }
       }
    
    @IBAction func showAll(_ sender: UIButton) {
        self.momentInfo?.isExpand = !(self.momentInfo?.isExpand ?? false)
        let title = (self.momentInfo?.isExpand ?? false) ? "全文" : "收起"
        sender.setTitle(title, for: .normal)
        self.superTableView?.reloadRows(at: [IndexPath(item: sender.tag, section: 0)], with: .fade)
    }
    
}

extension  MomentTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.momentInfo?.images?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell:ImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        if let imageUrl = self.momentInfo?.images?[indexPath.row]{
            collectionCell.imageView.setWImage(urlStr: imageUrl.url)
        }
        return collectionCell;
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let safeFrame = UIApplication.shared.windows[0].safeAreaLayoutGuide.layoutFrame
        let width = (safeFrame.width - 20 - 121 - 5 * 2);
        if self.momentInfo?.images?.count == 1 {
            return CGSize(width:width/1.5 , height: width/1.5)

        }else{
            return CGSize(width:width/3 , height: width/3)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let images = self.momentInfo?.images{
            var imageDataSource = [YKMediaObject]()
            for i in 0..<images.count{
                let cell:ImageCollectionViewCell =  collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as! ImageCollectionViewCell
                let imageURLOb = images[i]
                let imageOb = YKMediaObject()
                imageOb.path = imageURLOb.url
                imageOb.fromView = cell
                imageDataSource.append(imageOb)
            }
            YKMediaScrollerView.showBroswer(dataSource: imageDataSource, atIndex: indexPath.row + 1)
        }
    }
}


extension  MomentTableViewCell:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.momentInfo?.comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableView.automaticDimension
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        if let commentInfo = self.momentInfo?.comments?[indexPath.row]{
            cell.setCell(commentInfo)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
    
}
