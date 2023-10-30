
//
//  ApparentTemperatureGraphCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/13.
//

import UIKit

class ApparentTemperatureGraphCell: UICollectionViewCell {
    
    static let identifier = "ApparentTemperatureGraphCell"
    
    struct Metric {
        static let cornerRadius: CGFloat = 20
        static let innerHorizontalPadding: CGFloat = 10
        static let innerVerticalPadding: CGFloat = 15
    }
    
    struct Color {
    }
    
    struct Font {
    }
    
    let graphContainerView = GraphContainerView()
    
    lazy var graphScrollView = UIScrollView().then {
        $0.addSubview(graphContainerView)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = Metric.cornerRadius
        $0.layer.masksToBounds = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func fittingSize(availableWidth: CGFloat) -> CGSize {
        let cell = ApparentTemperatureGraphCell()
        cell.configure()
        let targetSize = CGSize(width: availableWidth, height: UIView.layoutFittingCompressedSize.height)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    func configure() {
    }
    
    private func addSubviews() {
        contentView.addSubview(graphScrollView)
    }
    
    private func setupConstraints() {
        
        graphScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            // 수정 필요
            make.height.equalTo(165)
        }
        
        graphContainerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.innerHorizontalPadding)
            make.right.equalToSuperview().offset(-Metric.innerHorizontalPadding)
            make.top.equalToSuperview().offset(Metric.innerVerticalPadding)
            make.bottom.equalToSuperview().offset(-Metric.innerVerticalPadding)
        }
    }
}

extension ApparentTemperatureGraphCell {
    class GraphContainerView: UIView {
        var lastCell: GraphBarView? = nil
        
        struct Metric {
            static let barCount: Int = 14
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
            addSubviews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setup() {
        }
        
        private func addSubviews() {
            var backgroundToggle = true
            
            for _ in 0 ..< Metric.barCount {
                let cell = GraphBarView(temperature: 10, date: 12, isLightBackground: backgroundToggle)
                self.addSubview(cell)
                
                cell.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.bottom.equalToSuperview()
                    
                    if let lastCell = lastCell {
                        make.left.equalTo(lastCell.snp.right).offset(2)
                    } else {
                        make.left.equalToSuperview()
                    }
                }
                backgroundToggle.toggle()
                lastCell = cell
            }
            
            if let lastCell = lastCell {
                lastCell.snp.makeConstraints { make in
                    make.right.equalToSuperview()
                }
            }
        }
    }
}

extension ApparentTemperatureGraphCell {
    class GraphBarView: UIView {
        
        let temperature: Int
        let date: Int
        let isLightBackground: Bool
        
        private var didNotLayoutSetup = true
        
        struct Metric {
            static let totalPadding: CGFloat = 8
            static let cornerRadius: CGFloat = 20
            
            static let dotSize: CGFloat = 5
            static let dotLabelPadding: CGFloat = 2
            
            static let barWidth: CGFloat = 36
            static let barHeight: CGFloat = 130
        }
        
        struct Color {
            static let lightBackgroundColor = UIColor(red: 255, green: 255, blue: 255)
            static let darkBackgroundColor = UIColor(red: 243, green: 243, blue: 243)
            
            static let temperatureLabel = UIColor(red: 91, green: 91, blue: 91)
            static let dateLabel = UIColor(red: 91, green: 91, blue: 91)
        }
        
        struct Font {
            static let temperatureLabel = UIFont.systemFont(ofSize: 13, weight: .semibold)
            static let dateLabel = UIFont.systemFont(ofSize: 14, weight: .bold)
        }
        
        let temperatureLabel = UILabel().then {
            $0.textColor = Color.temperatureLabel
            $0.font = Font.temperatureLabel
        }
        
        let temperatureDot = CircleView(color: .black)
        
        let dateLabel = UILabel().then {
            $0.textColor = Color.dateLabel
            $0.font = Font.dateLabel
        }
        
        init(frame: CGRect = CGRectZero, temperature: Int, date: Int, isLightBackground: Bool) {
            self.temperature = temperature
            self.date = date
            self.isLightBackground = isLightBackground
            
            super.init(frame: frame)
            
            setup()
            addSubviews()
            setupConstraints()
            
            setDotPosition()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setDotPosition() {
            self.layoutIfNeeded()
            let distanceBetweenLabels = dateLabel.frame.origin.y - self.frame.origin.y
            let dotHeight = CGFloat(temperature + 10) * distanceBetweenLabels / 50.0
            let dotYPosition = dateLabel.frame.origin.y - dotHeight
            temperatureDot.snp.makeConstraints { make in
                make.centerY.equalTo(dotYPosition)
            }
        }
        
        private func setup() {
            self.backgroundColor = isLightBackground ? Color.lightBackgroundColor : Color.darkBackgroundColor
            self.layer.cornerRadius = Metric.cornerRadius
            self.layer.masksToBounds = true
            
            self.temperatureLabel.text = String(temperature)
            self.dateLabel.text = String(date)
        }
        
        private func addSubviews() {
            addSubview(temperatureDot)
            addSubview(temperatureLabel)
            addSubview(dateLabel)
        }
        
        private func setupConstraints() {
            
            self.snp.makeConstraints { make in
                make.height.equalTo(Metric.barHeight)
                make.width.equalTo(Metric.barWidth)
            }
            
            temperatureDot.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.height.equalTo(Metric.dotSize)
            }
            
            temperatureLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(temperatureDot.snp.top).offset(-Metric.dotLabelPadding)
            }
            
            dateLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-Metric.totalPadding)
            }
        }
    }
}
