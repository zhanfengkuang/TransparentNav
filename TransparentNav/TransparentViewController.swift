//
//  TransparentViewController.swift
//  TransparentNav
//
//  Created by Maple on 2018/12/7.
//  Copyright © 2018 Jarmon. All rights reserved.
//

import UIKit

class TransparentViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        translucentBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        translucentBarDefault()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        
        adjustsInsets(tableView)
        
        dynamicTransparent(tableView, color: .green, offset: 400) { [weak self] scale in
            
            let backName: String
            let shareName: String
            let editName: String
            let alpha: CGFloat
            if scale < 0.5 {
                backName = "record_notes_article_back"
                shareName = "record_notes_article_share"
                editName = "record_notes_article_edit"
                alpha = 1 - scale * 2
            } else {
                backName = "record_notes_article_back_black"
                shareName = "record_notes_article_share_black"
                editName = "record_notes_article_edit_black"
                alpha = scale * 2 - 1
            }
            
            func image(name: String, alpha: CGFloat) -> UIImage? {
                return UIImage(named: name)?.setAlpha(alpha).withRenderingMode(.alwaysOriginal)
            }
            
            // 返回
            let backItem = UIBarButtonItem(image: image(name: backName, alpha: alpha),
                                           style: .plain,
                                           target: nil,
                                           action: nil)
            
            // 分享
            let shareItem = UIBarButtonItem(image: image(name: shareName, alpha: alpha),
                                            style: .plain,
                                            target: nil, action: nil)
            
            // 编辑
            let editedItem = UIBarButtonItem(image: image(name: editName, alpha: alpha),
                                             style: .plain,
                                             target: nil, action: nil)
            
            self?.setItems(.left, items: [backItem])
            self?.setItems(.right, items: [shareItem, editedItem])
        }
    }
    
    
}

extension TransparentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
//        cell?.contentView.backgroundColor = .red
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
