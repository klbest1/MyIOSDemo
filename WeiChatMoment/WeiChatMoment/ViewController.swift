//
//  ViewController.swift
//  WeiChatMoment
//
//  Created by lin kang on 2019/11/7.
//  Copyright © 2019 TW. All rights reserved.
//


import UIKit
import Alamofire
import HandyJSON

/*
 * 
*/

class ViewController: UIViewController {

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    private let parallexHeaderView: HeaderView = Bundle.main.loadNibNamed("HeaderView", owner: nil, options: nil)?.first as! HeaderView

     var contentView: YKRefreshLoadMoreTableView = YKRefreshLoadMoreTableView()
    var  finaList:[Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white;
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        self.indicatorView.startAnimating()
        
        // set tableview
        contentView.cTableView.register(UINib.init(nibName: "MomentTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "momentCell")
        contentView.delegateRL = self ;
        contentView.cTableView.tableHeaderView = parallexHeaderView;
        self.view.addSubview(contentView)
    
        
        //get web data
    Alamofire.request("https://thoughtworks-mobile-2018.herokuapp.com/user/jsmith").validate()
        . responseString { (response) in
            guard response.result.isSuccess else { return }
            guard let value = response.result.value else { return }
            
            if let userInfo = UserInfo.deserialize(from: value) {
                print("get userInfo: \(userInfo)")
                self.parallexHeaderView.setHeader(userInfo)
            }
        }

    Alamofire.request("https://thoughtworks-mobile-2018.herokuapp.com/user/jsmith/tweets").validate()
        . responseString { [weak self] (response) in
            guard response.result.isSuccess else { return }
            guard let value = response.result.value else { return }
            if let list = [MomentInfo].deserialize(from: value) {
                self?.finaList = list.filter { (momentInfo) -> Bool in
                    return (momentInfo?.content?.count ?? 0) > 0 || (momentInfo?.images?.count ?? 0) > 0
                    } as [Any]
                self?.indicatorView.stopAnimating()
                self?.refresh()
            }
           
        }
         
    }
    
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.contentView.frame = self.view.bounds
    }

    // device rotate
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            
        } else {
            
        }
        let list = finaList as? [MomentInfo]
        finaList = list?.map({ (momentInfo) -> MomentInfo in
            momentInfo.cellHeight = 0
           return momentInfo
        })
    }
}

extension ViewController:YKRefreshLoadMoreTableViewDelegate{
    func refresh() {
        if (finaList?.count ?? 0) > 5 {
            self.contentView.tableDataSource = Array(self.finaList![0...4])
            self.contentView.endRefreshAndReload()
        }
    }
    
    func loadingData() {
        if (finaList?.count ?? 0) > 5 {
            var dataSourceCount = (self.contentView.tableDataSource?.count ?? 0) + 4
            if(finaList?.count ?? 0 < dataSourceCount){
                dataSourceCount = (finaList?.count ?? 0) - 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.contentView.tableDataSource = Array(self.finaList![0...dataSourceCount])
                self.contentView.endRefreshAndReload()
            }
        }
    }
    
    func isNodata() -> Bool {
        return (self.contentView.tableDataSource?.count ?? 0) == (finaList?.count ?? 0)
    }
    
    func tableView(tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let momentInfo = self.contentView.tableDataSource?[indexPath.row]{
            let height = MomentTableViewCell.calculateHeight(momentInfo)
            return height
        }
        return UITableView.automaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "momentCell", for: indexPath) as! MomentTableViewCell
        cell.showAllButton.tag = indexPath.row;
        cell.superTableView = tableView
        return cell  ;
        
    }
    
    func tableView(selectedProperty: Any, tableView: UITableView, cellForRowAt indexPath: IndexPath) {
        
    }
    
    
}

