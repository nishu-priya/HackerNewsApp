//
//  LoginViewModel.swift
//  HackerNewsApp
//
//  Created by Nishu Priya on 9/29/18.
//  Copyright © 2018 Nishu Priya. All rights reserved.
//

import Foundation
import GoogleSignIn
import Firebase

protocol LoginViewModelDelegate: class {
    func signInSuccess()
}
class LoginViewModel: NSObject, GIDSignInDelegate {
    
    let articleListSegue: String = "ArticleListSegue"
    weak var delegate:LoginViewModelDelegate?
    
    func configureViewModel() {
        configureGoogleSignIN()
    }
    
    private func configureGoogleSignIN() {
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print("sign in error = \(error)")
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("sign in error = \(error)")
                return
            }
            self.delegate?.signInSuccess()
        }
        // ...
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
    }
    
}
