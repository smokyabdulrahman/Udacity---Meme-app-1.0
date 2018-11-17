//
//  MemeDetailsViewController.swift
//  Image Picker
//
//  Created by ABDULRAHMAN ALRAHMA on 11/17/18.
//  Copyright © 2018 ABDULRAHMAN ALRAHMA. All rights reserved.
//

import UIKit

class MemeDetailsViewController: UIViewController {
    
    var memeImg: UIImage!
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memeImageView.contentMode = .scaleAspectFit
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        memeImageView.image = memeImg;
    }

}
