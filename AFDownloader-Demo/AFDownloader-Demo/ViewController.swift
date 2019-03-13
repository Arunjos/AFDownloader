//
//  ViewController.swift
//  AFDownloader-Demo
//
//  Created by Arun Jose on 13/03/19.
//  Copyright © 2019 Arun Jose. All rights reserved.
//

import UIKit
import AFDownloader

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("main reached start processing")
        let urlString = "https://images.unsplash.com/profile-fb-1464533812-a91a557e646d.jpg?ixlib=rb-0.3.5\u{0026}q=80\u{0026}fm=jpg\u{0026}crop=faces\u{0026}fit=crop\u{0026}h=128\u{0026}w=128\u{0026}s=512955d67915413e3a20fb8fdbfcdc76"
        AFDownloader.downloadFileRequest(fileURL: URL(string: urlString)!).responseImage(completionHandler: {afResponse, error in
            
            print("response got")
            self.imageView.image = afResponse?.response
        }).start()
        
        AFDownloader.downloadFileRequest(fileURL: URL(string: "https://pastebin.com/raw/wgkJgazE")!).responseJSON(completionHandler: {afResponse, error in
            print("response 2 got")
            print(afResponse?.response ?? "")
        }).start()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonClick(_ sender: Any) {
        print("button clicked")
        let urlString = "https://images.unsplash.com/profile-fb-1464533812-a91a557e646d.jpg?ixlib=rb-0.3.5\u{0026}q=80\u{0026}fm=jpg\u{0026}crop=faces\u{0026}fit=crop\u{0026}h=128\u{0026}w=128\u{0026}s=512955d67915413e3a20fb8fdbfcdc76"
        AFDownloader.downloadFileRequest(fileURL: URL(string: urlString)!).responseImage(completionHandler: {afResponse, error in
            
            print("response got")
            self.imageView.image = afResponse?.response
        }).start()
        
        AFDownloader.downloadFileRequest(fileURL: URL(string: "https://pastebin.com/raw/wgkJgazE")!).responseJSON(completionHandler: {afResponse, error in
            print("response 2 got")
            print(afResponse?.response ?? "")
        }).start()
    }
    
    @IBAction func Button2Clicked(_ sender: Any) {
        let cache = Cache<Data>(capacity:3)
        print("button2 clicked")
        let urlString = "https://images.unsplash1.com/profile-fb-1464533812-a91a557e646d.jpg?ixlib=rb-0.3.5\u{0026}q=80\u{0026}fm=jpg\u{0026}crop=faces\u{0026}fit=crop\u{0026}h=128\u{0026}w=128\u{0026}s=512955d67915413e3a20fb8fdbfcdc763"
        AFDownloader.downloadFileRequest(fileURL: URL(string: urlString)!).responseImage(completionHandler: {afResponse, error in
            
            print("response got")
            self.imageView.image = afResponse?.response
        }).start()
    }
}

