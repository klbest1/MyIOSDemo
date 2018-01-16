//
//  ViewController.swift
//  Animations
//
//  Created by kang lin on 2018/1/16.
//  Copyright © 2018年 康林. All rights reserved.
//

import UIKit
struct  AnimationType: OptionSet {
    var rawValue: Int
    
    init(rawValue:Int) {
        self.rawValue = rawValue;
    }
    
    static let  PalseAnimation = AnimationType(rawValue: 1)
    
    func getDesc() -> String {
        switch self {
        case AnimationType.PalseAnimation:
            return "脉冲动画"
        default:
            return ""
        }
    }
}

class ViewController: UIViewController {

    let tableView:UITableView = UITableView()
    let animationTypes = [AnimationType.PalseAnimation];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.frame = self.view.bounds
        self.view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
     {
        return animationTypes.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
     {
        let cellID = "haha"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
            cell?.accessoryType = .disclosureIndicator
        }
        cell?.textLabel?.text = animationTypes[indexPath.row].getDesc()
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type =  animationTypes[indexPath.row]
        switch type {
        case AnimationType.PalseAnimation:
            let vc = YKPulseViewController()
            self.navigationController?.pushViewController(vc, animated: true);
            break
        default: break
            
        }
    }
}
