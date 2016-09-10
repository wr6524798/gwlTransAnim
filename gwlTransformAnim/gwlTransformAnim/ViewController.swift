//
//  ViewController.swift
//  gwlTransformAnim
//
//  Created by wangrui on 16/8/30.
//  Copyright © 2016年 tools. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    let imageView = UIImageView();
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
}


class ViewController: UIViewController {
    var imageMaskTransiton:ImageMaskTransition?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "main"
        self.view.backgroundColor = UIColor.whiteColor()
        self.setupCollectionView()
    }
    
    func setupCollectionView() {
        let collectionFlow = UICollectionViewFlowLayout()
        collectionFlow.minimumInteritemSpacing = 10;
        collectionFlow.minimumLineSpacing = 10;
        collectionFlow.itemSize = CGSizeMake(60, 90)
        collectionFlow.scrollDirection = UICollectionViewScrollDirection.Vertical;
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: collectionFlow);
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(CollectionCell.self, forCellWithReuseIdentifier: "cell")
        
        self.view.addSubview(collectionView)
    }

}

extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as? CollectionCell
        cell?.imageView.image = UIImage(named: "libai")
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CollectionCell
        let dvc = DeatilViewController()
        imageMaskTransiton = ImageMaskTransition(fromImageView: cell.imageView,toImageView:dvc.imageView)
        // present的方法
//        dvc.transitioningDelegate = imageMaskTransiton
//        presentViewController(dvc, animated: true, completion: nil)
        // push的方法
                self.navigationController?.delegate = imageMaskTransiton
        self.navigationController?.pushViewController(dvc, animated: true)
        
    }
}

