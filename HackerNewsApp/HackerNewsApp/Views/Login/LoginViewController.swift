//
//  ViewController.swift
//  HackerNewsApp
//
//  Created by Nishu Priya on 9/29/18.
//  Copyright © 2018 Nishu Priya. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate, LoginViewModelDelegate {

    @IBOutlet weak var signInButton: GIDSignInButton!
    let viewModel: LoginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.configureViewModel()
        GIDSignIn.sharedInstance().uiDelegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: LoginViewModelDelegate
    func signInSuccess() {
        //next view controller
        self.performSegue(withIdentifier: viewModel.articleListSegue, sender: self)
    }
    
}

