//
//  HomeViewController.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/05.
//

import UIKit

class HomeViewController: BaseViewController<HomeView> {
    
    let provider: ServiceProviderType
    
    var weather: Weather?
    
    let sections = ["메인 텍스트", "캐릭터", "오늘의 브리핑", "생활 지수"]
    
    lazy var homeViewDataSource: HomeViewDataSource = HomeViewDataSource(viewController: self)
    lazy var homeViewDelegate: HomeViewDelegateFlowLayout = HomeViewDelegateFlowLayout()
    
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
        self.contentView.collectionView.register(MainTextCell.self, forCellWithReuseIdentifier: MainTextCell.identifier)
        self.contentView.collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.identifier)
        self.contentView.collectionView.register(BriefingCell.self, forCellWithReuseIdentifier: BriefingCell.identifier)
        self.contentView.collectionView.register(ComfortIndexCell.self, forCellWithReuseIdentifier: ComfortIndexCell.identifier)
        self.contentView.collectionView.register(HomeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeHeaderView.identifier)
    }
    
    private func loadData() {
        provider.weatherService.getWeather { [weak self] weather in
            self?.weather = weather
            self?.contentView.collectionView.dataSource = self?.homeViewDataSource
            self?.contentView.collectionView.delegate = self?.homeViewDelegate
            self?.contentView.collectionView.reloadData()
        }
    }
    
    private func setup() {
        
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

extension HomeViewController {
    final class HomeViewDataSource: NSObject, UICollectionViewDataSource {
        
        weak var viewController: HomeViewController?
        
        init(viewController: HomeViewController) {
            self.viewController = viewController
            super.init()
        }
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            guard let viewController = viewController else { return 0 }
            return viewController.sections.count
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            guard let viewController = viewController else { return 0 }
            if section == 0 {
                return 1
            }
            else if section == 1 {
                return 1
            }
            else if section == 2 {
                return viewController.weather?.briefingDatas.count ?? 0
            }
            else if section == 3 {
                return viewController.weather?.comfortDatas.count ?? 0
            }
            return 0
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let viewController = viewController else { return UICollectionViewCell() }
            
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainTextCell", for: indexPath) as! MainTextCell
                cell.dateLabel.text = viewController.weather?.dateTitle
                cell.mainLabel.text = viewController.weather?.title
                cell.descriptionLabel.attributedText = viewController.weather?.description.attributedStringWithLineSpacing(5)
                return cell
            } else if indexPath.section == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
                cell.temperatureLabel.text = viewController.weather?.temperatureString
                cell.highestTemperatureLabel.text = viewController.weather?.highestTemperatureString
                cell.lowestTemperatureLabel.text = viewController.weather?.lowestTemperatureString
                
                cell.weatherLabel.text = viewController.weather?.weatherConditionString
                cell.weatherImageView.image = viewController.weather?.weatherConditionImage
                
                cell.locationLabel.text = viewController.weather?.location
                cell.lastUpdateDateLabel.text = viewController.weather?.lastUpdatedDate
                
                cell.advicePositionView.faceAdvice.titleAdviceLabel.text = viewController.weather?.faceAdvice.title
                cell.advicePositionView.faceAdvice.subAdviceLabel.text = viewController.weather?.faceAdvice.description
                
                cell.advicePositionView.clothesAdvice.titleAdviceLabel.text = viewController.weather?.clothesAdvice.title
                cell.advicePositionView.clothesAdvice.subAdviceLabel.text = viewController.weather?.clothesAdvice.description
                
                cell.advicePositionView.itemAdvice.titleAdviceLabel.text = viewController.weather?.itemAdvice.title
                cell.advicePositionView.itemAdvice.subAdviceLabel.text = viewController.weather?.itemAdvice.description
                cell.delegate = viewController
                return cell
                
            } else if indexPath.section == 2 {
                guard let weather = viewController.weather else { return UICollectionViewCell() }
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BriefingCell", for: indexPath) as! BriefingCell
                cell.configureData(with: weather)
                cell.iconLabel.text = weather.briefingDatas[indexPath.item].icon
                cell.titleLabel.text = weather.briefingDatas[indexPath.item].title
                cell.stateLabel.text = weather.briefingDatas[indexPath.item].state
                cell.descriptionLabel.attributedText = weather.briefingDatas[indexPath.item].description.attributedStringWithLineSpacing(1)
                cell.stateLabel.textColor = weather.briefingDatas[indexPath.item].color
                return cell
                
            } else if indexPath.section == 3 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComfortIndexCell", for: indexPath) as! ComfortIndexCell
                cell.iconLabel.text = viewController.weather?.comfortDatas[indexPath.item].icon
                cell.stateLabel.text = viewController.weather?.comfortDatas[indexPath.item].state
                cell.valueLabel.text = viewController.weather?.comfortDatas[indexPath.item].valueTitle
                cell.stateLabel.textColor = viewController.weather?.comfortDatas[indexPath.item].color
                
                return cell
            }
            return UICollectionViewCell()
        }
        
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            if kind == UICollectionView.elementKindSectionHeader {
                
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeHeaderView.identifier, for: indexPath) as! HomeHeaderView
                headerView.titleLabel.text = viewController?.sections[indexPath.section]
                return headerView
                
            }
            return UICollectionReusableView()
        }
    }
    
    final class HomeViewDelegateFlowLayout: NSObject, UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if indexPath.section == 0 {
                return CGSize(width: collectionView.bounds.width, height: 200)
            }
            else if indexPath.section == 1 {
                return CGSize(width: collectionView.bounds.width, height: 450)
            }
            else if indexPath.section == 2 {
                return CGSize(width: collectionView.bounds.width, height: 90)
            }
            else if indexPath.section == 3 {
                
                return CGSize(width: collectionView.bounds.width/2 - 6, height: 80)
            }
            return CGSize.zero
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            if (section == 2 || section == 3) {
                return CGSize(width: collectionView.bounds.width, height: 40)
            }
            return CGSizeZero
        }
        
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if indexPath.section == 1, let customCell = cell as? CharacterCell {
                customCell.advicePositionView.alpha = 0.0
                customCell.advicePositionView.transform = CGAffineTransform(translationX: 0, y: 10)
                
                customCell.showViewWithAnimation()
            }
        }
    }
}
