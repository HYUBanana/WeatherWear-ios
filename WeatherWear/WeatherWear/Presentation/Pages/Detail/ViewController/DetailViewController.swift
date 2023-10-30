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
        self.contentView.collectionView.register(DetailTitleCell.self, forCellWithReuseIdentifier: DetailTitleCell.identifier)
        
        self.contentView.collectionView.register(TemperatureGraphCell.self, forCellWithReuseIdentifier: TemperatureGraphCell.identifier)
        
        self.contentView.collectionView.register(ApparentTemperatureGraphCell.self, forCellWithReuseIdentifier: ApparentTemperatureGraphCell.identifier)
        
        self.contentView.collectionView.register(DetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailHeaderView.identifier)
        
        self.contentView.collectionView.register(DetailHeaderDescriptionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailHeaderDescriptionView.identifier)
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailTitleCell.identifier, for: indexPath) as! DetailTitleCell
            cell.configure()
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TemperatureGraphCell.identifier, for: indexPath) as! TemperatureGraphCell
            cell.configure()
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ApparentTemperatureGraphCell.identifier, for: indexPath) as! ApparentTemperatureGraphCell
            cell.configure()
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if indexPath.section == 1 {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DetailHeaderView.identifier, for: indexPath) as! DetailHeaderView
                headerView.configure()
                return headerView
            }
                
            else if indexPath.section == 2 {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DetailHeaderDescriptionView.identifier, for: indexPath) as! DetailHeaderDescriptionView
                headerView.configure()
                return headerView
            }
            
            else { return UICollectionReusableView() }
            
        default:
            return UICollectionReusableView()
        }
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return DetailTitleCell.fittingSize(availableWidth: collectionView.bounds.width)
        case 1:
            return TemperatureGraphCell.fittingSize(availableWidth: collectionView.bounds.width)
            
        case 2:
            return ApparentTemperatureGraphCell.fittingSize(availableWidth: collectionView.bounds.width)
        default:
            return CGSizeZero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 1:
            return DetailHeaderView.fittingSize(availableWidth: collectionView.bounds.width)
            
        case 2:
            return DetailHeaderDescriptionView.fittingSize(availableWidth: collectionView.bounds.width)
            
        default:
            return CGSizeZero
        }
    }
}
