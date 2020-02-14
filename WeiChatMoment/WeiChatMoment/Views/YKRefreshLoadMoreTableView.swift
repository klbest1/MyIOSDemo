//
//  YKRefreshLoadMoreTableView.swift
//  MyProject
//
//  Created by kang lin on 2017/8/9.
//  Copyright © 2017年 lin. All rights reserved.
//

import UIKit

@objc protocol YKRefreshLoadMoreTableViewDelegate:class{
    
   func refresh();
   func loadingData();
   func isNodata() -> Bool ;
   func tableView(tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat;
   func tableView(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell;
   func tableView(selectedProperty:Any,tableView: UITableView, cellForRowAt indexPath: IndexPath);

   @objc optional func tableView( tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
   @objc optional  func scrollViewDidScroll(scrollView: UIScrollView)
   @objc optional func scrollViewDidEndDecelerating( scrollView: UIScrollView)
   @objc optional func tableView( tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int)

}


@objcMembers class YKRefreshLoadMoreTableView: UIView {
    var  refreshCtrl:UIRefreshControl = UIRefreshControl()
    var cTableView:UITableView = UITableView(frame: CGRect.zero, style: .plain)

    
    var tableDataSource:[Any]? {
        didSet{
            if self.tableDataSource != nil && self.tableDataSource!.count > 0
            {
                cTableView.isHidden = false
            }
        }
    }
    var isNoData:Bool = false;
    weak var delegateRL:YKRefreshLoadMoreTableViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        refreshCtrl = UIRefreshControl()
        refreshCtrl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        cTableView.addSubview(refreshCtrl);
        cTableView.backgroundColor = UIColor.clear
        cTableView.isHidden = true;
        cTableView.delegate = self;
        cTableView.dataSource = self;
        cTableView.estimatedRowHeight = 0;//预估高度
        cTableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
//        cTableView.rowHeight = UITableView.automaticDimension;
        cTableView.estimatedSectionHeaderHeight = 0;
        cTableView.estimatedSectionFooterHeight = 0;
        cTableView.contentInsetAdjustmentBehavior = .never
        self.addSubview(cTableView);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var frame: CGRect{
        didSet{
            cTableView.frame = self.bounds;
        }
    }
    
    @objc func refresh()  {
        delegateRL?.refresh();
    }
    
    func endRefreshAndReload()  {
        if self.refreshCtrl.isRefreshing{
            self.refreshCtrl.endRefreshing();
        }
        cTableView.reloadData()
    }
}

extension YKRefreshLoadMoreTableView:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableDataSource!.count == indexPath.row  {
            return 60
        }
        return (delegateRL?.tableView(tableView:tableView, heightForRowAt:indexPath)) ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let count = tableDataSource?.count{
            return count + 1
        }else{
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footerView = view as! UITableViewHeaderFooterView
        footerView.backgroundView?.backgroundColor = kRGBColorFromHex(rgbValue: 0xe8e8e8)
        self.delegateRL?.tableView?(tableView: tableView, willDisplayFooterView: view, forSection: section)
        //IphoneX 取消 Footer显示
        if UIScreen.main.bounds.size.height == 812 {
            footerView.backgroundView?.backgroundColor = UIColor.clear
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if tableDataSource!.count == indexPath.row  {

            let cellId = "loadCell";
            var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? YKBaseTableViewCell;
            if cell == nil {
                cell = YKBaseTableViewCell (style: .default, reuseIdentifier: cellId);
            }
            cell?.textLabel?.textAlignment = .center

            if (delegateRL?.isNodata())! {
                cell!.textLabel?.text = "没有数据了";
            }else{
                cell!.textLabel?.text = "加载中..."
            }
            cell?.selectionStyle = .none;

            return cell!;
        }else if(indexPath.row < tableDataSource!.count){
            let cell = delegateRL!.tableView(tableView: tableView, cellForRowAt: indexPath) as? YKBaseTableViewCell
            let property = tableDataSource?[indexPath.row];
            if property != nil{
                cell?.setCell(property!);
            }else{
                print("数组\(indexPath.row)为空。。。");
            }
            cell?.selectionStyle = .none;
            return cell!;
        }
        
        return UITableViewCell();
    }
    
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        delegateRL?.tableView?(tableView: tableView, willDisplay: cell, forRowAt: indexPath)
        let lastSeveralRow = tableDataSource!.count - 1;
        if indexPath.row == lastSeveralRow{
            // Your code with delay
            if !(delegateRL?.isNodata())! {

                delegateRL?.loadingData();
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if(indexPath.row < tableDataSource!.count){
            let property = tableDataSource![indexPath.row];
            delegateRL?.tableView(selectedProperty: property, tableView: tableView, cellForRowAt: indexPath);
        }
        
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegateRL?.scrollViewDidScroll?(scrollView: scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegateRL?.scrollViewDidEndDecelerating?(scrollView: scrollView)
    }
}


