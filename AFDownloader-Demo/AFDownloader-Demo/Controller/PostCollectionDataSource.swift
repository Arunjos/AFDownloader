//
//  PostCollectionDataSource.swift
//  AFDownloader-Demo
//
//  Created by Arun Jose on 14/03/19.
//  Copyright © 2019 Arun Jose. All rights reserved.
//

import Foundation
import UIKit
import AFDownloader

public class PostCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    let reuseIdentifier = "PostCollectionCell" // also enter this string as the cell identifier in the storyboard
    
    
    // MARK: - UICollectionViewDataSource protocol
    // tell the collection view how many cells to make
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return HomeViewController.postsList.count
    }
    
    // make a cell for each cell index path
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PostCollectionViewCell
        
        cell.postImageView.image = nil
        
        if let imageString = HomeViewController.postsList[indexPath.row].url?.full, let imageURL = URL(string: imageString){
            
            AFDownloader.downloadFileRequest(fileURL: imageURL).responseImage(completionHandler: {image, error in
                
                if let image = image?.response {
                    DispatchQueue.main.async {
                        if let cellExisit: PostCollectionViewCell = collectionView.cellForItem(at: indexPath) as? PostCollectionViewCell {
                            cellExisit.postImageView.image = image
                            self.animateFadeImageFor(imageView: cellExisit.postImageView)
                        }else{
                            cell.postImageView.image = image
                            self.animateFadeImageFor(imageView: cell.postImageView)
                        }
                    }
                }else{
                    print("Image load failed for indexpath:\(indexPath.row) due to ", error?.localizedDescription ?? "")
                }
                
            }).start()
            
        }
        return cell
    }
    
    func animateFadeImageFor(imageView:UIImageView?){
        imageView?.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            imageView?.alpha = 1
        })
    }
}
