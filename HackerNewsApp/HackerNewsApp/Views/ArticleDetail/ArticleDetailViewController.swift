//
//  ArticleDetailViewController.swift
//  HackerNewsApp
//
//  Created by Nishu Priya on 9/30/18.
//  Copyright © 2018 Nishu Priya. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ArticleDetailViewModelDelegate, ArticleTableHeaderViewDelagate {

    var articleId: Int = 0
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customNavigationBarHeight: NSLayoutConstraint!
    
    var viewmodel: ArticleDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.delegate = self
        tableView.dataSource = self
        print("article id = \(articleId)")
        setCustomNavigationBarHeight()
        viewmodel.delegate = self
        
    }

    func setCustomNavigationBarHeight() {
        let desiredHeight = AppDelegate.kStatusBarHeight +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        customNavigationBarHeight.constant = desiredHeight
    }
    
    // MARK: table delegates and datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewmodel.commentSelected {
            return viewmodel.commentIds.count
        } else {
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewmodel.commentSelected {
            let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCommentCell.kReuseId, for: indexPath) as? ArticleCommentCell
            cell?.configure(commentId: viewmodel.commentIds[indexPath.row])
            cell?.layoutIfNeeded()
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ArticleContentCell.kReuseId, for: indexPath) as? ArticleContentCell
            cell?.url = self.viewmodel.getUrl()
            cell?.loadUrl()
            cell?.layoutIfNeeded()
            return cell ?? UITableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ArticleTableHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: ArticleTableHeaderView.kHeaderHeight))
        header.configureFromStoryId(id: articleId)
        header.delegate = self
        if self.viewmodel.commentSelected {
            header.selectCommentsView()
        } else {
            header.selectArticleView()
        }
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ArticleTableHeaderView.kHeaderHeight
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewmodel.commentSelected  {
            if viewmodel.comment(row: indexPath.row) == nil {
                viewmodel.fetchComment(row: indexPath.row)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewmodel.commentSelected  {
            return UITableView.automaticDimension
        } else {
            return self.view.frame.height
        }
    }

    // MARK: ArticleDetailViewModelDelegate
    func commentFetchCompleted(row: Int) {
        if self.viewmodel.commentSelected {
            let indexpath = IndexPath(row: row, section: 0)
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexpath], with: .fade)
            }
        }
    }
    func fetchCompletedWithError(error: Error) {
        
        //error
    }
    // MARK: ArticleTableHeaderViewDelagate
    func commentsViewTapped() {
        viewmodel.commentSelected = true
        
        var indexPathsToInsert = [IndexPath]()
        for i in 0..<viewmodel.commentIds.count {
            indexPathsToInsert.append(IndexPath(row: i, section: 0))
        }
        
        var indexPathsToDelete = [IndexPath]()
        indexPathsToDelete.append(IndexPath(row: 0, section: 0))
        
        self.tableView.performBatchUpdates({
            self.tableView.deleteRows(at: indexPathsToDelete, with: .none)
            self.tableView.insertRows(at: indexPathsToInsert, with: .none)
        }, completion: nil)
    }
    func articleViewTapped() {
        viewmodel.commentSelected = false
        
        var indexPathsToDelete = [IndexPath]()
        for i in 0..<viewmodel.commentIds.count {
            indexPathsToDelete.append(IndexPath(row: i, section: 0))
        }
        
        var indexPathsToInsert = [IndexPath]()
        indexPathsToInsert.append(IndexPath(row: 0, section: 0))
        
        self.tableView.performBatchUpdates({
            self.tableView.deleteRows(at: indexPathsToDelete, with: .none)
            self.tableView.insertRows(at: indexPathsToInsert, with: .none)
        }, completion: nil)
    }
    
    // MARK: IBAction
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
