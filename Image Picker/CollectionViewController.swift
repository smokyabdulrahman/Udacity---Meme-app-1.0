//
//  CollectionViewController.swift
//  Image Picker
//
//  Created by ABDULRAHMAN ALRAHMA on 11/5/18.
//  Copyright © 2018 ABDULRAHMAN ALRAHMA. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    let CELL_ID = "CollectionCell"
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addMemeCreatorPresenterButton()
        
        // setup flow layout
        initFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! MemeCell
        cell.memeImgView.image = memes[indexPath.row].memeImg
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeVC = storyboard?.instantiateViewController(withIdentifier: "MemeViewController") as! ViewController
        
        memeVC.meme = memes[indexPath.row]

        present(memeVC, animated: true, completion: nil)
    }
    
    func initFlowLayout() {
        let space: CGFloat = 3.0
        let numberOfItemsInEachRow: CGFloat = 3.0
        let dimension = (view.frame.width - (2 * space)) / numberOfItemsInEachRow
        
        // min space width to use between rows
        flowLayout.minimumLineSpacing = space
        // min space width to use between items in the same row
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

}
