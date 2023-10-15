//
//  SettingViewController.swift
//  WeatherWear
//
//  Created by 디해 on 2023/09/22.
//

import UIKit

class SettingViewController: BaseViewController<SettingView> {
    // 테스트 코드
    let sections = ["위치", "외출 시간", "단위", "자동 정렬"]
    
    let outingTimes = ["08시 00분에 나가서,", "19시 00분에 돌아와요.", "총 11시간 00분"]
    
    let degreeOptions = ["온도", "바람"]
    let degreeOptionSegmentTitles = [[(0, "°C"),(1, "°F")], [(0, "m/s"),(1, "km/h"),(2,"mph")]]
    
    let autoOptions = ["오늘의 브리핑", "자세히"]
    let autoOptionSegmentTitles = [[(0, "자동"), (1, "수동")], [(0, "자동"), (1, "수동")]]
    
    let provider: ServiceProviderType
    
    var userLocations: [UserLocation]?
    
    var selectedRadioButtonIndex: IndexPath?
    
    lazy var settingViewDataSource: SettingViewDataSource = SettingViewDataSource(viewController: self)
    lazy var settingViewDelegate: SettingViewDelegateFlowLayout = SettingViewDelegateFlowLayout(viewController: self)
    
    struct Metric {
        static let collectionViewPadding: CGFloat = 17
        static let userLocationCellHeight: CGFloat = 70
        static let outingTimeCellHeight: CGFloat = 80
        static let segmentedControlHeight: CGFloat = 45
        static let cellSpacing: CGFloat = 15
        static let segmentItemWidth: CGFloat = 70
    }
    
    struct Color {
        static let blueColor = UIColor(red: 36, green: 160, blue: 237)
    }
    
    init(serviceProvider: ServiceProviderType) {
        self.provider = serviceProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        loadData()
    }
    
    private func registerCells() {
        self.contentView.collectionView.register(UserLocationCell.self, forCellWithReuseIdentifier: "UserLocationCell")
        self.contentView.collectionView.register(OutingTimeCell.self, forCellWithReuseIdentifier: "OutingTimeCell")
        self.contentView.collectionView.register(OptionCollectionView.self, forCellWithReuseIdentifier: "OptionCollectionViewCell")
        self.contentView.collectionView.register(SettingHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
    }
    
    private func loadData() {
        provider.userLocationService.getUserLocoation { [weak self] userLocations in
            guard let userLocations = userLocations else { return }
            self?.userLocations = userLocations
            self?.contentView.collectionView.dataSource = self?.settingViewDataSource
            self?.contentView.collectionView.delegate = self?.settingViewDelegate
            self?.contentView.collectionView.reloadData()
        }
    }
}

extension SettingViewController {
    final class SettingViewDataSource: NSObject, UICollectionViewDataSource {
        weak var viewController: SettingViewController?
        
        init(viewController: SettingViewController) {
            self.viewController = viewController
            super.init()
        }
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            guard let viewController = viewController else { return 0 }
            return viewController.sections.count
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            guard let viewController = viewController else { return 0 }
            guard let userLocations = viewController.userLocations else { return 0 }
            
            if section == 0 {
                return userLocations.count
            }
            else if section == 1 {
                return 1
            }
            else if section == 2 {
                return 1
            }
            else if section == 3 {
                return 1
            }
            return 0
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let viewController = viewController else { return UICollectionViewCell() }
            guard let userLocations = viewController.userLocations else { return UserLocationCell() }
            
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserLocationCell", for: indexPath) as! UserLocationCell
                
                let userLocation = userLocations[indexPath.item]
                if userLocation.isSelected {
                    cell.radioButton.isSelected = true
                } else {
                    cell.radioButton.isSelected = false
                }
                
                cell.locationLabel.text = userLocation.location
                cell.timeLabel.text = userLocation.time
                cell.temperatureLabel.text = userLocation.temperatureString
                cell.weatherLabel.text = userLocation.weather
                cell.delegate = viewController
                return cell
            }
            
            else if indexPath.section == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OutingTimeCell", for: indexPath) as! OutingTimeCell
                cell.delegate = viewController
                cell.departureTimeLabel.attributedText = makeAttributedText(text: viewController.outingTimes[0])
                cell.arrivalTimeLabel.attributedText = makeAttributedText(text: viewController.outingTimes[1])
                cell.totalTimeLabel.text = viewController.outingTimes[2]
                
                return cell
            }
            else if indexPath.section == 2 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionCollectionViewCell", for: indexPath) as! OptionCollectionView
                cell.dataSource = DegreeOptionDataSource(viewController: viewController)
                cell.collectionView.dataSource = cell.dataSource
                cell.delegate = DegreeOptionDelegateFlowLayout()
                cell.collectionView.delegate = cell.delegate
                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionCollectionViewCell", for: indexPath) as! OptionCollectionView
                cell.dataSource = AutoOptionDataSource(viewController: viewController)
                cell.collectionView.dataSource = cell.dataSource
                cell.delegate = AutoOptionDelegateFlowLayout()
                cell.collectionView.delegate = cell.delegate
                return cell
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            guard let viewController = viewController else { return UICollectionViewCell() }
            if kind == UICollectionView.elementKindSectionHeader {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! SettingHeader
                if indexPath.section == 0 {
                    header.plusButton.isHidden = false
                    header.delegate = viewController
                } else {
                    header.plusButton.isHidden = true
                }
                header.titleLabel.text = viewController.sections[indexPath.section]
                return header
            }
            return UICollectionViewCell()
        }
        
        private func makeAttributedText(text: String) -> NSMutableAttributedString {
            let attributedString = NSMutableAttributedString(string: text)
            
            if let endIndex = text.range(of: "분")?.upperBound {
                let range = NSRange(text.startIndex..<endIndex, in: text)
                attributedString.addAttribute(.foregroundColor, value: Color.blueColor, range: range)
            }
            return attributedString
        }
    }
    
    final class SettingViewDelegateFlowLayout: NSObject, UICollectionViewDelegateFlowLayout {
        weak var viewController: SettingViewController?
        
        init(viewController: SettingViewController) {
            self.viewController = viewController
            super.init()
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let viewController = viewController else { return }
            guard let userLocations = viewController.userLocations else { return }
            let provider = viewController.provider
            if indexPath.section == 0 {
                
                guard let previousSelectedIndex = userLocations.firstIndex(where: { $0.isSelected }) else { return }
                let currentSelectedIndex = indexPath.item
                
                provider.userLocationService.userLocationSelected(previous: previousSelectedIndex, next: currentSelectedIndex) { userLocations in
                    guard let userLocations = userLocations else { return }
                    viewController.userLocations = userLocations
                    let previousIndexPath = IndexPath(item: previousSelectedIndex, section: 0)
                    let currentIndexPath = IndexPath(item: currentSelectedIndex, section: 0)
                    viewController.contentView.collectionView.reloadItems(at: [previousIndexPath, currentIndexPath])
                }
            }
            
            else if indexPath.section == 1 {
                let alertController = UIAlertController(title: "", message: "대충 시간 설정하는 화면", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                viewController.present(alertController, animated: true)
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            guard let viewController = viewController else { return CGSizeZero }
            if indexPath.section == 0 {
                return CGSize(width: collectionView.bounds.width-Metric.collectionViewPadding*2, height: Metric.userLocationCellHeight)
            }
            else if indexPath.section == 1 {
                return CGSize(width: collectionView.bounds.width-Metric.collectionViewPadding*2, height: Metric.outingTimeCellHeight)
            }
            else if indexPath.section == 2 {
                return CGSize(width: collectionView.bounds.width-Metric.collectionViewPadding*2, height: Metric.segmentedControlHeight*CGFloat(viewController.degreeOptions.count)+Metric.collectionViewPadding*2+Metric.cellSpacing)
            }
            else {
                return CGSize(width: collectionView.bounds.width-Metric.collectionViewPadding*2, height: Metric.segmentedControlHeight*CGFloat(viewController.autoOptions.count)+Metric.collectionViewPadding*2+Metric.cellSpacing)
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.bounds.width, height: 30)
        }
    }
}

extension SettingViewController {
    final class DegreeOptionDataSource: NSObject, UICollectionViewDataSource {
        
        weak var viewController: SettingViewController?
        
        init(viewController: SettingViewController) {
            self.viewController = viewController
            super.init()
        }
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return viewController?.degreeOptions.count ?? 0
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let viewController = viewController else { return UICollectionViewCell() }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionCell", for: indexPath) as! OptionCell
            cell.degreeTitle.text = viewController.degreeOptions[indexPath.item]
            cell.segmentControl.isUserInteractionEnabled = true
            
            let segmentTitles = viewController.degreeOptionSegmentTitles[indexPath.item]
            cell.segmentControl.removeAllSegments()
            for (index, title) in segmentTitles {
                cell.segmentControl.insertSegment(withTitle: title, at: index, animated: false)
            }
            cell.segmentControl.selectedSegmentIndex = 0
            cell.segmentControl.snp.updateConstraints { make in
                make.width.equalTo(CGFloat(segmentTitles.count) * Metric.segmentItemWidth)
            }
            return cell
        }
    }
    
    final class DegreeOptionDelegateFlowLayout: NSObject, UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.bounds.width-Metric.collectionViewPadding*2, height: Metric.segmentedControlHeight)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: 0, height: 0)
        }
    }
}

extension SettingViewController {
    final class AutoOptionDataSource: NSObject, UICollectionViewDataSource {
        
        weak var viewController: SettingViewController?
        
        init(viewController: SettingViewController) {
            self.viewController = viewController
            super.init()
        }
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return viewController?.autoOptions.count ?? 0
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let viewController = viewController else { return UICollectionViewCell() }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionCell", for: indexPath) as! OptionCell
            cell.degreeTitle.text = viewController.autoOptions[indexPath.item]
            cell.segmentControl.isUserInteractionEnabled = true
            
            let segmentTitles = viewController.autoOptionSegmentTitles[indexPath.item]
            cell.segmentControl.removeAllSegments()
            for (index, title) in segmentTitles {
                cell.segmentControl.insertSegment(withTitle: title, at: index, animated: false)
            }
            cell.segmentControl.selectedSegmentIndex = 0
            cell.segmentControl.snp.updateConstraints { make in
                make.width.equalTo(CGFloat(segmentTitles.count) * Metric.segmentItemWidth)
            }
            return cell
        }
    }
    
    final class AutoOptionDelegateFlowLayout: NSObject, UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.bounds.width-Metric.collectionViewPadding*2, height: Metric.segmentedControlHeight)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: 0, height: 0)
        }
    }
}

extension SettingViewController: SettingHeaderDelegate {
    func plusButtonTapped() {
        provider.userLocationService.addUserLocation { userLocations in
            guard let userLocations = userLocations else { return }
            self.userLocations = userLocations
            self.contentView.collectionView.reloadData()
        }
    }
}

extension SettingViewController: UserLocationCellDelegate {
    
    func radioButtonTapped(cell: UserLocationCell) {
        UIView.animate(withDuration: 0.15, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { _ in
            UIView.animate(withDuration: 0.15, animations: {
                cell.transform = CGAffineTransform.identity
            }) { [weak self] _ in
                guard let collectionView = self?.contentView.collectionView else { return }
                guard let indexPath = collectionView.indexPath(for: cell) else { return }
                
                self?.settingViewDelegate.collectionView(collectionView, didSelectItemAt: indexPath)
            }
        }
    }
    
    func radioButtonLongPressed(cell: UserLocationCell, gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            UIView.animate(withDuration: 0.15) {
                cell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
            }
        case .ended, .cancelled, .failed:
            let touchLocation = gesture.location(in: cell)
            if cell.bounds.contains(touchLocation) {
                if let indexPath = contentView.collectionView.indexPath(for: cell) {
                    settingViewDelegate.collectionView(contentView.collectionView, didSelectItemAt: indexPath)
                }
            }
            UIView.animate(withDuration: 0.15) {
                cell.transform = CGAffineTransform.identity
            }
        default:
            break
        }
    }
}

extension SettingViewController: OutingTimeCellDelegate {
    func outingTimeViewTapped(cell: OutingTimeCell) {
        UIView.animate(withDuration: 0.15, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                cell.transform = CGAffineTransform.identity
            }
        }
        
        if let indexPath = contentView.collectionView.indexPath(for: cell) {
            settingViewDelegate.collectionView(contentView.collectionView, didSelectItemAt: indexPath)
        }
    }
    
    func outingTimeViewLongPressed(cell: OutingTimeCell, gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            UIView.animate(withDuration: 0.15) {
                cell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
            }
        case .ended, .cancelled, .failed:
            let touchLocation = gesture.location(in: cell)
            if cell.bounds.contains(touchLocation) {
                if let indexPath = contentView.collectionView.indexPath(for: cell) {
                    settingViewDelegate.collectionView(contentView.collectionView, didSelectItemAt: indexPath)
                }
            }
            UIView.animate(withDuration: 0.15) {
                cell.transform = CGAffineTransform.identity
            }
        default:
            break
        }
    }
}
