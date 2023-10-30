//
//  DetailViewController.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/13.
//

import UIKit

class DetailViewController: BaseViewController<DetailView> {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        setup()
    }
    
    private func registerCells() {
        self.contentView.collectionView.register(TitleCell.self, forCellWithReuseIdentifier: TitleCell.identifier)
        
        self.contentView.collectionView.register(TemperatureGraphCell.self, forCellWithReuseIdentifier: TemperatureGraphCell.identifier)
        
        self.contentView.collectionView.register(ApparentTemperatureGraphCell.self, forCellWithReuseIdentifier: ApparentTemperatureGraphCell.identifier)
        
    }
    
    private func setup() {
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCell.identifier, for: indexPath) as! TitleCell
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TemperatureGraphCell.identifier, for: indexPath) as! TemperatureGraphCell
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ApparentTemperatureGraphCell.identifier, for: indexPath) as! ApparentTemperatureGraphCell
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.bounds.width, height: 70)
        case 1:
            return CGSize(width: collectionView.bounds.width, height: 330)
        case 2:
            return CGSize(width: collectionView.bounds.width, height: 270)
        default:
            return CGSizeZero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 25)
    }
}
