//
//  SliceVC.swift
//  Slippery_Example
//
//  Created by BaekSungwook on 1/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Slippery

class SliceVC: UIViewController {

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var sliceView: UICollectionView!
    private var collectionViewLayout: SlipperyFlowLayout!
    var focusedItem = Int() {
        didSet {
            itemLabel.text = String(focusedItem)
        }
    }
    
    lazy var dummyNumbers = Array<Int>()
    override func viewDidLoad() {
        super.viewDidLoad()
        createDummyNumbers()
        
        setupCollectionView()
        scrollToItem(item: 20, animated: true)
    }
    
    func createDummyNumbers(){
        
        for i in 0 ... 100 {
            dummyNumbers.append(i)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
    }
    
    


}


extension SliceVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var intialOffset: CGFloat {
        return self.collectionViewLayout.initialOffset
    }
    
    
    func scrollToItem(item: Int, animated: Bool) {
        
        let itemOffset = self.collectionViewLayout.updateOffset(item: item)
        self.sliceView.setContentOffset(CGPoint(x: itemOffset, y: 0), animated: true)
        self.sliceView.layoutIfNeeded()
        
    }
    
    func setupCollectionView() {
        self.collectionViewLayout = SlipperyFlowLayout.configureLayout(collectionView: self.sliceView, itemSize: CGSize(width: 30, height: self.sliceView.frame.height), minimumLineSpacing: 20, highlightOption: .custom(.leading, .third))
        
        self.collectionViewLayout.invalidateLayout()
        self.sliceView.layoutIfNeeded()
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyNumbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliceCell", for: indexPath) as! NumberCell

        cell.number.text = String(dummyNumbers[indexPath.row])
 
        return cell
        
    }
    
}

extension SliceVC: UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollview: UIScrollView){
        
        guard collectionViewLayout != nil else { return }
        
        let itemPage = collectionViewLayout.itemSize.width + collectionViewLayout.minimumLineSpacing
        
        let page = Int((scrollview.contentOffset.x + scrollview.contentInset.left + ((itemPage) / 2 ) + intialOffset) / (itemPage))
        guard page < dummyNumbers.count else { return }
       
        focusedItem = page
    }
    
}


