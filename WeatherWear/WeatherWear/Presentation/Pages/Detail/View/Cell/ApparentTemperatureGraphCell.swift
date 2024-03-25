
//
//  ApparentTemperatureGraphCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/13.
//

import UIKit
import RxSwift

class ApparentTemperatureGraphCell: UICollectionViewCell {
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

extension ApparentTemperatureGraphCell: Sizeable {
    func fittingSize(availableWidth: CGFloat, with viewModel: CellViewModelType) -> CGSize {
        let cell = ApparentTemperatureGraphCell()
        viewModel.bind(to: cell)
        let targetSize = CGSize(width: availableWidth, height: UIView.layoutFittingCompressedSize.height)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}

extension ApparentTemperatureGraphCell {
    class GraphContainerView: UIView {
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
            var backgroundToggle = true
            
            guard let weatherGraph = weatherGraph else { return }
            
            for i in 0 ..< weatherGraph.count {
                let view = GraphBarView()
                
                view.configure(weatherGraph: weatherGraph[i])
                view.backgroundColor = backgroundToggle ? AppColor.background(.white).color : AppColor.background(.lightGray).color
                self.addSubview(view)
                
                view.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.bottom.equalToSuperview()
                    
                    if let lastView = lastView {
                        make.left.equalTo(lastView.snp.right).offset(2)
                    } else {
                        make.left.equalToSuperview()
                    }
                }
                backgroundToggle.toggle()
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
            graphLayer.strokeColor = UIColor.black.cgColor
            graphLayer.lineWidth = 2.0
            graphLayer.fillColor = UIColor.clear.cgColor
            self.layer.addSublayer(graphLayer)
        }
    }
}

extension ApparentTemperatureGraphCell {
    class GraphBarView: UIView {
        
        private var didNotLayoutSetup = true
        
        struct Metric {
            static let totalPadding: CGFloat = 15
            static let topPadding: CGFloat = 30
            static let cornerRadius: CGFloat = 20
            
            static let dotSize: CGFloat = 5
            static let dotLabelPadding: CGFloat = 2
            
            static let barWidth: CGFloat = 36
            static let barHeight: CGFloat = 130
        }
        
        let temperatureLabel = UILabel().then {
            $0.textColor = AppColor.text(.tertiaryDarkText).color
            $0.font = AppFont.description(.D3(.semibold)).font
        }
        
        let temperatureDot = CircleView(color: .black)
        
        let dateLabel = UILabel().then {
            $0.textColor = AppColor.text(.tertiaryDarkText).color
            $0.font = AppFont.description(.D2(.bold)).font
        }
        
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
            temperatureLabel.text = weatherGraph.temperature
            dateLabel.text = weatherGraph.day
            
            layoutIfNeeded()
            
            let temperature = CGFloat(Double(weatherGraph.temperature) ?? 0)
            let distanceBetweenLabels = dateLabel.frame.origin.y - Metric.topPadding
            let dotHeight = (temperature + 10) * distanceBetweenLabels / 50.0
            let dotYPosition = dateLabel.frame.origin.y - dotHeight
            temperatureDot.snp.makeConstraints { make in
                make.centerY.equalTo(dotYPosition)
            }
        }
        
        private func setup() {
            self.layer.cornerRadius = Metric.cornerRadius
            self.layer.masksToBounds = true
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
