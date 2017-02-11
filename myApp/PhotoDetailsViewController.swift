//
//  PhotoDetailsViewController.swift
//  myApp
//
//  Created by Suraj Upreti on 2/9/17.
//  Copyright © 2017 Suraj Upreti. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    
    @IBOutlet weak var detalilText: UITextView! //detailText
    
    @IBOutlet weak var photoDetail: UIImageView!  //photoLabel
    
    var imageText: String?
    var pictureUrlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detalilText.text = imageText
        
        let imageUrl = URL(string: pictureUrlString!)
        if let imageUrl = imageUrl {
            photoDetail.setImageWith(imageUrl)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
}
    

}
