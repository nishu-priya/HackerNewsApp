//
//  ArticleListViewController.swift
//  HackerNewsApp
//
//  Created by Nishu Priya on 9/29/18.
//  Copyright © 2018 Nishu Priya. All rights reserved.
//

import UIKit

class ArticleListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ArticleListViewModelDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customNavigationBarHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationSubtitle: UILabel!
    
    let viewModel = ArticleListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
        
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.delegate = self
        
        setCustomNavigationBarHeight()
        viewModel.fetchTopArticles()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCustomNavigationBarHeight()
    }
    func setCustomNavigationBarHeight() {
        let desiredHeight = AppDelegate.kStatusBarHeight +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        customNavigationBarHeight.constant = desiredHeight
    }
    // MARK: UItableViewDelegates amd Datatsource
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleListTVC.reuseID, for: indexPath) as? ArticleListTVC
        cell?.configure(articleId: viewModel.articleIds[indexPath.row])
        cell?.layoutIfNeeded()
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.story(row: indexPath.row) == nil {
            viewModel.fetchArticle(row: indexPath.row)
        }
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.cancelTaskIfAnyForRow(row: indexPath.row)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.story(row: indexPath.row) == nil {
            return UITableView.automaticDimension
        } else {
            return UITableView.automaticDimension
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ArticleDetailViewControllerSegue", sender: self)
    }
    
    // MARK: ArticleListViewModelDelegate
    func articleListFetched() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func fetchCompletedWithError(error: Error) {
        print("error")
    }
    func articleFetchCompleted(row: Int) {
        let indexpath = IndexPath(row: row, section: 0)
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [indexpath], with: .fade)
        }
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ArticleDetailViewController, let row = tableView.indexPathForSelectedRow?.row{
            let vm = ArticleDetailViewModel(id: self.viewModel.articleIds[row])
            vm.commentIds = self.viewModel.commentIds(row: row)
            vc.viewmodel = vm
            vc.articleId = self.viewModel.articleIds[row]
        }
    }
    
    deinit {
        print("deinit from ArticleListViewController got called")
    }
}
