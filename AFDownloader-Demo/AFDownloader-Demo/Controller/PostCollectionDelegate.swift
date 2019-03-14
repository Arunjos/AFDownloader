//
//  PostCollectionDelegate.swift
//  AFDownloader-Demo
//
//  Created by Arun Jose on 14/03/19.
//  Copyright © 2019 Arun Jose. All rights reserved.
//

import Foundation
import UIKit

public class PostCollectionDelegate: NSObject, UICollectionViewDelegate {
    // MARK: - UICollectionViewDelegate protocol
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
}
