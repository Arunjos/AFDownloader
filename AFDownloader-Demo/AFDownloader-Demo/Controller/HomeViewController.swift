//
//  HomeViewController.swift
//  AFDownloader-Demo
//
//  Created by Arun Jose on 14/03/19.
//  Copyright © 2019 Arun Jose. All rights reserved.
//

import UIKit
import AFDownloader
import ObjectMapper

class HomeViewController: UIViewController {
    
    var postCollectionDataSource:PostCollectionDataSource? = nil
    var postCollectionDelegate:PostCollectionDelegate? = nil
    static var postsList:[Post] = []
    var refreshControl:UIRefreshControl?
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.whiteLarge )
    
    @IBOutlet weak var postCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializePostCollectionView()
        setupPullToRefresh()
        initializeActivityIndicator()
        getPostDetails()
    }
    
    func initializePostCollectionView(){
        if let layout = postCollectionView.collectionViewLayout as? PostLayout {
            layout.delegate = self
        }
        postCollectionDataSource = PostCollectionDataSource()
        postCollectionDelegate = PostCollectionDelegate()
        postCollectionView.dataSource = postCollectionDataSource
        postCollectionView.delegate = postCollectionDelegate
        
    }
    
    func getPostDetails(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        guard let apiURL = URL(string: Constants.API_URL) else {
            return
        }
        AFDownloader.downloadFileRequest(fileURL: apiURL).responseJSON(completionHandler: {jsonObj, error in
            if let jsonArray = jsonObj?.response as? [[String : Any]] {
                HomeViewController.postsList = Post.getPostListFrom(jsonArray: jsonArray)
            }
            DispatchQueue.main.async {
                if self.refreshControl != nil{
                    self.refreshControl?.endRefreshing()
                }
                self.postCollectionView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }).start()
    }
    
    func setupPullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshPostsCollection), for: .valueChanged)
        postCollectionView.refreshControl = refreshControl
    }
    
    @objc func refreshPostsCollection(){
        getPostDetails()
    }
    
    func initializeActivityIndicator(){
        activityIndicator.isHidden = true
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension HomeViewController : PostsLayoutDelegate {
    
    // 1. Returns the posts height
    func collectionView(_ collectionView: UICollectionView, sizeForPhotoAtIndexPath indexPath:IndexPath) -> CGSize {
        let postDetail = HomeViewController.postsList[indexPath.item]
        if let imageWidth = postDetail.width, let imageHeight = postDetail.height {
            return  CGSize(width: imageWidth, height: imageHeight)
        }
        return  CGSize(width: 100, height: 100)
    }
    
}
