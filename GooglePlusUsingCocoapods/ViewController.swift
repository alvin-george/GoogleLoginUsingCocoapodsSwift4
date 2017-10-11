//
//  ViewController.swift
//  GooglePlusUsingCocoapods
//
//  Created by Pushpam Group on 25/03/17.
//  Copyright © 2017 Pushpam Group. All rights reserved.

import UIKit
import GoogleSignIn
import Google


class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet var signOutButton: UIButton!
    @IBOutlet var disconnectButton: UIButton!
    @IBOutlet var signInOnButton: GIDSignInButton!
    @IBOutlet var statusLabel: UILabel!
    
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var userIdLabel: UILabel!
    @IBOutlet var familyNameLabel: UILabel!
    @IBOutlet var givenNameLabel: UILabel!
    @IBOutlet var profileDescriptionLabel: UILabel!
    
    
    
    var gid_signinSharedInstance = GIDSignIn.sharedInstance()
    var profileDataDict = [String: AnyObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gid_signinSharedInstance?.delegate = self
        gid_signinSharedInstance?.uiDelegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if(profileDataDict.count != 0){
            usernameLabel.text = profileDataDict["name"] as! String?
            
            
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //GIDSignInUIDelegate Methods
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!){
        
        //UIActivityIndicatorView.stopAnimating()
        
    }
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!){
        
        self.present(viewController, animated: true, completion: nil)
        
    }
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //GIDSignInDelegate Methods
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!){
        
        
        if ((gid_signinSharedInstance?.hasAuthInKeychain) != nil) {
            // Signed in
            signInOnButton.isHidden = true
            signOutButton.isHidden = false
            disconnectButton.isHidden = false
            statusLabel.text =  "logged In"
            
        } else {
            print("Not signed in")
            signInOnButton.isHidden = false
            signOutButton.isHidden = true
            disconnectButton.isHidden = true
            statusLabel.text = "Google Sign in\niOS Demo"
        }
        
        
        if (error == nil) {
            
            // let imageURL = user.profile.imageURL(withDimension: 200)
            
            //Add to Dict
            profileDataDict = ["user_id":user.userID as AnyObject ,"id_token": user.authentication.idToken as AnyObject,"profile_name": user.profile.name as AnyObject,"given_name": user.profile.givenName as AnyObject,"family_name": user.profile.familyName as AnyObject,"email": user.profile.email as AnyObject, "profile_description": user.profile.description as AnyObject]
          
            print(profileDataDict)
            
            if(user.profile.hasImage){
                print("profile image available")
                let dimension = round(300 * UIScreen.main.scale);
                let picURL = user.profile.imageURL(withDimension: UInt(dimension))
                
                profilePicture.setRounded()
                profilePicture.downloadedFrom(url: picURL!)
            }
            
            //Display Data
            usernameLabel.text = profileDataDict["profile_name"] as! String?
            emailLabel.text = profileDataDict["email"] as! String?
            userIdLabel.text = profileDataDict["user_id"] as! String?
            familyNameLabel.text = profileDataDict["family_name"] as! String?
            givenNameLabel.text = profileDataDict["given_name"] as! String?
            profileDescriptionLabel.text = profileDataDict["profile_description"] as! String?
            
            
        } else {
            print("\(error.localizedDescription)")
        }
        
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!){
        print("logged out")
    }
    
    //UIButton Actions
    @IBAction func signOutButtonClicked(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        statusLabel.text = "Signed out."
        
    }
    @IBAction func disconnectButtonClicked(_ sender: Any) {
        GIDSignIn.sharedInstance().disconnect()
        statusLabel.text = "Disconnecting."
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

//ImageView: Extension for
extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
