//
//  FeedController.swift
//  Instagram
//
//  Created by Islam NourEldin on 25/07/2022.
//

import UIKit

private let identifier = "cell"

class FeedController: UICollectionViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(FeedCollectionCell.self, forCellWithReuseIdentifier: "cell")
    }
}

extension FeedController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

        return cell
    }
}

extension FeedController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: view.frame.height*0.3)
    }
}
