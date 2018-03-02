//
//  ImageTableViewCell.swift
//  YKPhotoMediaBroswer
//
//  Created by kang lin on 2018/3/1.
//  Copyright © 2018年 康林. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    let button1:YKGifButton = YKGifButton()
    let button2 = YKGifButton()
    let button3 = YKGifButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(button1)
        self.contentView.addSubview(button2)
        self.contentView.addSubview(button3)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button1.frame = CGRect(x: 20, y: (self.bounds.size.height-80)/2, width: 80, height: 80)
        button2.frame = CGRect(x: button1.frame.maxX + 20, y: (self.bounds.size.height-80)/2, width: 80, height: 80)
        button3.frame = CGRect(x: button2.frame.maxX + 20, y: (self.bounds.size.height-80)/2, width: 80, height: 80)

    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
