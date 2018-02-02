//
//  PhotoVC.swift
//  Slippery_Example
//
//  Created by BaekSungwook on 1/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Slippery

class PhotoVC: UIViewController {
    
    @IBOutlet weak var photoIndex: UILabel!
    @IBOutlet weak var photoView: UICollectionView!
    private var collectionViewLayout: SlipperyFlowLayout!
    
    
    var dummyPhotos = Array<String>()
    var focusedItem = Int() {
        didSet {
            photoIndex.text = String(focusedItem)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        createDummyPhotos()
        setupCollectionView()
        
        print(dummyPhotos)
        
    }
    func createDummyPhotos(){
        
        for i in 1 ... 10 {
            dummyPhotos.append(String(i))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
    }
    

}

extension PhotoVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var intialOffset: CGFloat {
        return self.collectionViewLayout.initialOffset
        
    }
    
    
    func scrollToItem(item: Int, animated: Bool) {
        
        let itemOffset = self.collectionViewLayout.updateOffset(item: item)
        self.photoView.setContentOffset(CGPoint(x: itemOffset, y: 0), animated: true)
        self.photoView.layoutIfNeeded()
        
    }
    
    func setupCollectionView(){
        
        self.collectionViewLayout = SlipperyFlowLayout.configureLayout(collectionView: self.photoView, itemSize: CGSize(width: 150, height: 180), minimumLineSpacing: 20, highlightOption: .center(.normal))
        
        self.collectionViewLayout.minimumOpacityFactor = 0.1
        self.collectionViewLayout.minimumScaleFactor = 1.0
        
        self.collectionViewLayout.invalidateLayout()
        self.photoView.layoutIfNeeded()
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        cell.photo.image = UIImage(named:dummyPhotos[indexPath.row])
        
        return cell
        
    }
    
}

extension PhotoVC: UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollview: UIScrollView){
        
        guard collectionViewLayout != nil else { return }
        
        let itemPage = collectionViewLayout.itemSize.width + collectionViewLayout.minimumLineSpacing
        
        let page = Int((scrollview.contentOffset.x + scrollview.contentInset.left + ((itemPage) / 2 ) + intialOffset) / (itemPage))
        guard page < dummyPhotos.count else { return }
        
        focusedItem = page
        
    }
    
}




