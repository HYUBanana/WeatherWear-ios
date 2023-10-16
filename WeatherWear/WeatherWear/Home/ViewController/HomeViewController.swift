//
//  HomeViewController.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/05.
//

import UIKit

class HomeViewController: BaseViewController<HomeView> {
    
    let sections = ["메인 텍스트", "캐릭터", "오늘의 브리핑", "생활 지수"]
    
    var mainTextCells = Array<String>()
    
    var adviceTitles = Array<String>()
    var adviceDescriptions = Array<String>()
    
    var briefings = Array<String>()
    var briefingIcon = Array<String>()
    var briefingState = Array<String>()
    var briefingDescription = Array<String>()
    var briefingValue = Array<CGFloat>()
    var briefingColor = Array<UIColor>()
    
    var comfortIndexIcon = Array<String>()
    var comfortIndexValue = Array<String>()
    var comfortIndexState = Array<String>()
    
    lazy var homeViewDataSource: HomeViewDataSource = HomeViewDataSource(viewController: self)
    lazy var homeViewDelegate: HomeViewDelegateFlowLayout = HomeViewDelegateFlowLayout()
    
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
        mainTextCells.append("7월 24일 월요일,")
        mainTextCells.append("에어컨 없이는\n못 살아.🥵")
        mainTextCells.append("오늘은 어제보다 더 덥고 습해서,\n실외활동은 자제하는 게 좋겠어요.\n다행히 비 소식은 없어요. ")
        
        adviceTitles.append("썬크림 필수")
        adviceTitles.append("얇고 짧은 옷")
        adviceTitles.append("우산 X")
        
        adviceDescriptions.append("자외선이 아주 강해요.")
        adviceDescriptions.append("기온이 아주 높아요.")
        adviceDescriptions.append("강수확률 없어요.")
        
        briefingIcon.append("🌡️")
        briefingIcon.append("😎")
        briefingIcon.append("😷")
        briefingIcon.append("💨")
        
        briefings.append("체감온도")
        briefings.append("자외선")
        briefings.append("대기질")
        briefings.append("바람")
        
        briefingState.append("아주 높음")
        briefingState.append("아주 강함")
        briefingState.append("좋음")
        briefingState.append("약함")
        
        briefingDescription.append("체감 온도 최대 34도.\n어제보다 2도 더 높으며,\n건강에 위협적인 수준이에요.")
        briefingDescription.append("자외선지수 최고 8.\n09시부터 17시 사이에는\n썬크림을 꼭 발라야 해요.")
        briefingDescription.append("미세먼지 좋음 (23μg/m³)\n초미세먼지 좋음 (11μg/m³)\n오랜만에 맑은 공기네요.")
        briefingDescription.append("최대 풍속 2m/s 정도로,\n약한 편이에요.")
        
        briefingValue.append(35)
        briefingValue.append(30)
        briefingValue.append(15)
        briefingValue.append(0)
        
        briefingColor.append(UIColor(red: 255, green: 92, blue: 0))
        briefingColor.append(UIColor(red: 255, green: 184, blue: 0))
        briefingColor.append(UIColor(red: 88, green: 172, blue: 23))
        briefingColor.append(UIColor(red: 36, green: 160, blue: 237))
        
        comfortIndexIcon.append("😡")
        comfortIndexIcon.append("🧺")
        comfortIndexIcon.append("🧽")
        comfortIndexIcon.append("🌼")
        
        comfortIndexValue.append("불쾌 지수 80")
        comfortIndexValue.append("빨래 지수 30")
        comfortIndexValue.append("세차 지수 50")
        comfortIndexValue.append("꽃가루 지수 10")
        
        comfortIndexState.append("아주 나쁨")
        comfortIndexState.append("나쁨")
        comfortIndexState.append("보통")
        comfortIndexState.append("좋음")
        
        self.contentView.collectionView.dataSource = self.homeViewDataSource
        self.contentView.collectionView.delegate = self.homeViewDelegate
        
        self.contentView.collectionView.reloadData()
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
                return viewController.briefings.count
            }
            else if section == 3 {
                return viewController.comfortIndexValue.count
            }
            return 0
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let viewController = viewController else { return UICollectionViewCell() }
            
            if indexPath.section == 0 {
                let mainTextCells = viewController.mainTextCells
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainTextCell", for: indexPath) as! MainTextCell
                cell.dateLabel.text = mainTextCells[0]
                cell.mainLabel.text = mainTextCells[1]
                cell.descriptionLabel.attributedText = mainTextCells[2].attributedStringWithLineSpacing(5)
                return cell
            } else if indexPath.section == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
                cell.advicePositionView.faceAdvice.titleAdviceLabel.text = viewController.adviceTitles[0]
                cell.advicePositionView.faceAdvice.subAdviceLabel.text = viewController.adviceDescriptions[0]
                cell.advicePositionView.clothesAdvice.titleAdviceLabel.text = viewController.adviceTitles[1]
                cell.advicePositionView.clothesAdvice.subAdviceLabel.text = viewController.adviceDescriptions[1]
                cell.advicePositionView.itemAdvice.titleAdviceLabel.text = viewController.adviceTitles[2]
                cell.advicePositionView.itemAdvice.subAdviceLabel.text = viewController.adviceDescriptions[2]
                cell.delegate = viewController
                return cell
            } else if indexPath.section == 2 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BriefingCell", for: indexPath) as! BriefingCell
                cell.iconLabel.text = viewController.briefingIcon[indexPath.item]
                cell.titleLabel.text = viewController.briefings[indexPath.item]
                cell.stateLabel.text = viewController.briefingState[indexPath.item]
                cell.descriptionLabel.attributedText = viewController.briefingDescription[indexPath.item].attributedStringWithLineSpacing(1)
                cell.stateLabel.textColor = viewController.briefingColor[indexPath.item]
                cell.temperatureColorView.color = viewController.briefingColor[indexPath.item]
                cell.temperatureColorView.temperature = viewController.briefingValue[indexPath.item]
                
                return cell
            } else if indexPath.section == 3 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComfortIndexCell", for: indexPath) as! ComfortIndexCell
                cell.iconLabel.text = viewController.comfortIndexIcon[indexPath.item]
                cell.stateLabel.text = viewController.comfortIndexState[indexPath.item]
                cell.valueLabel.text = viewController.comfortIndexValue[indexPath.item]
                cell.stateLabel.textColor = viewController.briefingColor[indexPath.item]
                
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
