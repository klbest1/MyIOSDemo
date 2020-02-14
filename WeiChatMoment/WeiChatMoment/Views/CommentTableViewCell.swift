//
//  CommentTableViewCell.swift
//  WeiChatMoment
//
//  Created by lin kang on 2019/11/9.
//  Copyright © 2019 TW. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func getAttributeText(_ comment:CommentInfo) -> NSAttributedString{
        let firstAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor:UIColor(displayP3Red: 99/255.0, green: 153/255.0, blue: 206/255.0, alpha: 1)]
               let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]

               let userName = comment.sender?.nick ?? ""
               
               let firstString = NSMutableAttributedString(string: userName + "：", attributes: firstAttributes)
               let secondString = NSAttributedString(string: comment.content ?? "", attributes: secondAttributes)
               firstString.append(secondString)
        return firstString
    }
    
    func setCell(_ comment:CommentInfo)  {
        commentLabel.attributedText = CommentTableViewCell .getAttributeText(comment)

    }
    
}
