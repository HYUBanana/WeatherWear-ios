//
//  WeatherGraphCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/04.
//

import UIKit

class WeatherGraphCell: UICollectionViewCell {
    struct Metric {
        static let cornerRadius: CGFloat = 20
        static let innerHorizontalPadding: CGFloat = 10
        static let innerVerticalPadding: CGFloat = 15
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
    
    func configure(data: [WeatherGraph]) {
        graphContainerView.configure(weatherGraph: data)
    }
    
    private func addSubviews() {
        contentView.addSubview(graphScrollView)
    }
    
    private func setupConstraints() {
        graphScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(300)
        }
        
        graphContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: Metric.innerVerticalPadding,
                                                             left: Metric.innerHorizontalPadding,
                                                             bottom: Metric.innerVerticalPadding,
                                                             right: Metric.innerHorizontalPadding))
        }
    }
}

extension WeatherGraphCell: Sizeable {
    func fittingSize(availableWidth: CGFloat, with viewModel: CellViewModelType) -> CGSize {
        let cell = WeatherGraphCell()
        viewModel.bind(to: cell)
        let targetSize = CGSize(width: availableWidth, height: UIView.layoutFittingCompressedSize.height)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}

extension WeatherGraphCell {
    final class GraphContainerView: UIView {
        private var points: [CGPoint] = []
        
        private var weatherGraph: [WeatherGraph]? {
            didSet {
                addSubviews()
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(weatherGraph: [WeatherGraph]) {
            self.weatherGraph = weatherGraph
        }
        
        private func addSubviews() {
            var lastView: GraphBarView? = nil
            
            guard let weatherGraph = weatherGraph else { return }
            
            for i in 0 ..< weatherGraph.count {
                let view = GraphBarView()
                view.configure(weatherGraph: weatherGraph[i])
                self.addSubview(view)
                
                view.snp.makeConstraints { make in
                    make.top.bottom.equalToSuperview()
                    
                    if let lastView = lastView {
                        make.left.equalTo(lastView.snp.right).offset(2)
                    } else {
                        make.left.equalToSuperview()
                    }
                }
                lastView = view
                
                layoutIfNeeded()
                points.append(CGPoint(x: view.frame.midX, y: view.temperatureDot.frame.origin.y + view.temperatureDot.frame.height / 2))
                
                if points.count == weatherGraph.count {
                    drawGraph()
                }
            }
            
            if let lastView = lastView {
                lastView.snp.makeConstraints { make in
                    make.right.equalToSuperview()
                }
            }
        }
            
        private func drawGraph() {
            let graphPath = UIBezierPath()
            for (index, point) in points.enumerated() {
                if index == 0 {
                    graphPath.move(to: point)
                } else {
                    graphPath.addLine(to: point)
                }
            }
                
            let graphLayer = CAShapeLayer()
            graphLayer.path = graphPath.cgPath
            graphLayer.strokeColor = AppColor.component(.yellow).color.cgColor
            graphLayer.lineWidth = 2.0
            graphLayer.fillColor = UIColor.clear.cgColor
            self.layer.addSublayer(graphLayer)
        }
    }
}

extension WeatherGraphCell {
    final class GraphBarView: UIView {
        
        struct Metric {
            static let barWidth: CGFloat = 36
            static let barHeight: CGFloat = 260
            static let humidityCornerRadius: CGFloat = 3
            
            static let humiditySpacing: CGFloat = 3
            static let humidityBarMaxHeight: CGFloat = 40
            static let humidityBarWidth: CGFloat = 7
            static let maxHumidity: CGFloat = 10
            
            static let dotSize: CGFloat = 2
            
            static let cloudCoverLabelTopPadding: CGFloat = 3
            static let cellPadding: CGFloat = 10
        }
        
        let humidityLabel = UILabel().then {
            $0.font = AppFont.description(.D3(.regular)).font
            $0.textColor = AppColor.component(.highlightBlue).color
        }
        
        let humidityBar = UIView().then {
            $0.backgroundColor = AppColor.component(.highlightBlue).color
            $0.layer.cornerRadius = Metric.humidityCornerRadius
            $0.layer.masksToBounds = true
        }
        
        let cloudCoverLabel = UILabel().then {
            $0.font = AppFont.description(.D3(.regular)).font
            $0.textColor = AppColor.component(.blueGray).color
        }
        
        let dayLabel = UILabel().then {
            $0.font = AppFont.description(.D2(.semibold)).font
            $0.textColor = AppColor.text(.tertiaryDarkText).color
        }
        
        let temperatureDot = CircleView(color: AppColor.component(.yellow).color)
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            setup()
            addSubviews()
            setupConstraints()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(weatherGraph: WeatherGraph) {
            
            humidityLabel.text = weatherGraph.humidity
            cloudCoverLabel.text = weatherGraph.cloudCover
            dayLabel.text = weatherGraph.day
            
            let humidity = CGFloat(Double(weatherGraph.humidity) ?? 0)
            let temperature = CGFloat(Double(weatherGraph.temperature) ?? 0)
            
            let percentageHeight = Metric.humidityBarMaxHeight / Metric.maxHumidity
            let height = humidity * percentageHeight
            
            humidityBar.snp.updateConstraints { make in
                make.height.equalTo(height)
            }
            
            layoutIfNeeded()
            
            let distanceBetweenLabels = dayLabel.frame.origin.y - cloudCoverLabel.frame.maxY
            let dotPercentageHeight = CGFloat(temperature) * distanceBetweenLabels / 50.0
            let dotYPosition = dayLabel.frame.origin.y - dotPercentageHeight
            temperatureDot.snp.updateConstraints { make in
                make.centerY.equalTo(dotYPosition)
            }
        }
        
        private func setup() {
            backgroundColor = .clear
        }
        
        private func addSubviews() {
            addSubview(humidityLabel)
            addSubview(humidityBar)
            addSubview(cloudCoverLabel)
            addSubview(dayLabel)
            addSubview(temperatureDot)
        }
        
        private func setupConstraints() {
            self.snp.makeConstraints { make in
                make.height.equalTo(Metric.barHeight)
                make.width.equalTo(Metric.barWidth)
            }
            
            humidityBar.snp.makeConstraints { make in
                make.height.equalTo(0)
                make.width.equalTo(Metric.humidityBarWidth)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-(Metric.barHeight - (Metric.humidityBarMaxHeight + Metric.cellPadding)))
            }
            
            humidityLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(humidityBar.snp.top).offset(-Metric.humiditySpacing)
            }
            
            cloudCoverLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(humidityBar.snp.bottom).offset(-Metric.cloudCoverLabelTopPadding)
            }
            
            dayLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-Metric.cellPadding)
            }
            
            temperatureDot.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalTo(0)
                make.width.height.equalTo(Metric.dotSize)
            }
        }
    }
}
