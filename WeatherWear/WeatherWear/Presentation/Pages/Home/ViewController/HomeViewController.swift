//
//  HomeViewController.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/05.
//

import UIKit

class HomeViewController: BaseViewController<HomeView> {
    
    let provider: ServiceProviderType
    
    var weather: Weather? {
        didSet {
            contentView.collectionView.reloadData()
        }
    }
    
    let sections = ["메인 텍스트", "캐릭터", "오늘의 브리핑", "생활 지수"]
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        loadData()
        setup()
    }
    
    private func registerCells() {
        self.contentView.collectionView.register(HomeTitleCell.self, forCellWithReuseIdentifier: HomeTitleCell.identifier)
        self.contentView.collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.identifier)
        self.contentView.collectionView.register(BriefingCell.self, forCellWithReuseIdentifier: BriefingCell.identifier)
        self.contentView.collectionView.register(ComfortIndexCell.self, forCellWithReuseIdentifier: ComfortIndexCell.identifier)
        self.contentView.collectionView.register(HomeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeHeaderView.identifier)
    }
    
    private func loadData() {
        provider.weatherService.getWeather { [weak self] weather in
            self?.weather = weather
        }
    }
    
    private func setup() {
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
    }
}

extension HomeViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1.0) { [weak self] in
            self?.contentView.mainWeatherImageView.alpha = 1.0
        }
    }
}

extension HomeViewController: CharacterCellDelegate {
    func downloadButtonTapped() {
        let alertController = UIAlertController(title: "", message: "다운로드 로직", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let weather = weather else { return 0 }
        
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return weather.briefingDatas.count
        case 3:
            return weather.comfortDatas.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let weather = weather else { return UICollectionViewCell() }
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTitleCell.identifier, for: indexPath) as! HomeTitleCell
            cell.configure(weather: weather)
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier, for: indexPath) as! CharacterCell
            cell.configure(weather: weather)
            cell.delegate = self
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BriefingCell.identifier, for: indexPath) as! BriefingCell
            cell.configure(briefingData: weather.briefingDatas[indexPath.item])
            return cell
            
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComfortIndexCell.identifier, for: indexPath) as! ComfortIndexCell
            cell.configure(comfortData: weather.comfortDatas[indexPath.item])
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeHeaderView.identifier, for: indexPath) as! HomeHeaderView
            headerView.configure(headerText: sections[indexPath.section])
            return headerView
        
        default:
            return UICollectionReusableView()
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let weather = weather else { return CGSizeZero }
        switch indexPath.section {
        case 0:
            return HomeTitleCell.fittingSize(availableWidth: collectionView.bounds.width, weather: weather)
            
        case 1:
            return CharacterCell.fittingSize(availableWidth: collectionView.bounds.width, weather: weather)
            
        case 2:
            return BriefingCell.fittingSize(availableWidth: collectionView.bounds.width, briefingData: weather.briefingDatas[indexPath.item])
            
        case 3:
            return ComfortIndexCell.fittingSize(availableWidth: (collectionView.bounds.width - 13)/2.0, comfortData: weather.comfortDatas[indexPath.item])
            
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 2:
            return HomeHeaderView.fittingSize(availableWidth: collectionView.bounds.width, headerText: sections[section])
        case 3:
            return HomeHeaderView.fittingSize(availableWidth: collectionView.bounds.width, headerText: sections[section])
        default:
            return CGSizeZero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            guard let cell = cell as? CharacterCell else { return }
            cell.advicePositionView.alpha = 0.0
            cell.advicePositionView.transform = CGAffineTransform(translationX: 0, y: 10)
            cell.showViewWithAnimation()
        
        default:
            return
        }
    }
}
