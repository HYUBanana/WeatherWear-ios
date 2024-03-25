//
//  WeatherGraphCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/04.
//

import UIKit

class WeatherGraphCell: BaseCell {
    
    struct Metric {
        static let cellHeight: CGFloat = 200
        static let cornerRadius: CGFloat = 20
        static let topPadding: CGFloat = 20
        static let bottomPadding: CGFloat = 15
        static let horizontalPadding: CGFloat = 25
        
        static let labelHeight: CGFloat = 15
        static let labelTopPadding: CGFloat = 5
    }
    
    var viewModel: WeatherGraphCellViewModel?
    
    let timeLineView = TimeLineView()
    
    var timeLabels: [UILabel] = {
        var labels = [UILabel]()
        var time = 0
        for _ in 0..<9 {
            let label = UILabel().then {
                $0.font = AppFont.description(.D3(.medium)).font
                $0.textColor = AppColor.text(.lightText).color
                $0.text = String(format: "%02d", time)
            }
            labels.append(label)
            time += 3
        }
        return labels
    }()
    
    var lines: [UIView] = {
        var views = [UIView]()
        for _ in 0..<9 {
            let view = UIView().then {
                $0.backgroundColor = AppColor.graph(.line).color
            }
            views.append(view)
        }
        return views
    }()
    
    let containerView = ContainerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = Metric.cornerRadius
        contentView.layer.masksToBounds = true
        
        contentView.layer.shadowColor = AppColor.component(.black).color.cgColor
        contentView.layer.shadowOpacity = 0.07
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowRadius = 10
    }
    
    private func addSubviews() {
        contentView.addSubview(containerView)
        timeLabels.forEach { contentView.addSubview($0) }
        lines.forEach { contentView.addSubview($0) }
        contentView.addSubview(timeLineView)
    }
    
    private func setupConstraints() {
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Metric.topPadding)
            make.left.right.equalToSuperview().inset(Metric.horizontalPadding)
            make.bottom.equalToSuperview().inset(Metric.bottomPadding + Metric.labelHeight + Metric.labelTopPadding)
        }
        
        contentView.snp.makeConstraints { make in
            make.height.equalTo(Metric.cellHeight)
            make.width.equalToSuperview()
        }
        
        for index in 0..<9 {
            if index == 0 {
                timeLabels[index].snp.makeConstraints { make in
                    make.centerX.equalTo(Metric.horizontalPadding)
                    make.bottom.equalToSuperview().inset(Metric.bottomPadding)
                }
                
                lines[index].snp.makeConstraints { make in
                    make.centerX.equalTo(Metric.horizontalPadding)
                    make.bottom.equalToSuperview().inset(Metric.bottomPadding + Metric.labelHeight + Metric.labelTopPadding)
                    make.top.equalToSuperview().inset(Metric.topPadding)
                    make.width.equalTo(1)
                }
            }
            
            else {
                let xDividedWidth = (self.bounds.width - Metric.horizontalPadding * 2) / 8.0
                timeLabels[index].snp.makeConstraints { make in
                    make.centerX.equalTo(timeLabels[index - 1]).offset(xDividedWidth)
                    make.bottom.equalToSuperview().inset(Metric.bottomPadding)
                }
                
                lines[index].snp.makeConstraints { make in
                    make.centerX.equalTo(lines[index - 1]).offset(xDividedWidth)
                    make.bottom.equalToSuperview().inset(Metric.bottomPadding + Metric.labelHeight + Metric.labelTopPadding)
                    make.top.equalToSuperview().inset(Metric.topPadding)
                    make.width.equalTo(1)
                }
            }
        }
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        // 이 시점에서 subview의 width를 알기 위해 붙인 것임.
        layoutIfNeeded()
        
        let graphType = viewModel.graphType
        let hourlyData = viewModel.data.hourlyWeather
        
        switch graphType {
        case .all:
            setTimeLinePosition(hour: viewModel.data.hour,
                              minute: viewModel.data.minute)
            containerView.drawGraph(graphType: graphType,
                                    values: hourlyData.map { $0.temperature })
            containerView.drawCloudCoverGraph(cloudCovers: hourlyData.map { $0.cloudCover })
            containerView.drawRainFallGraph(rainfalls: hourlyData.map { $0.rainfall })
            
        case .apparentTemperature:
            hideTimeLine()
            containerView.hideCloudCoverGraph()
            containerView.drawGraph(graphType: graphType,
                                    values: hourlyData.map { $0.apparentTemperature })
            
        case .uvIndex:
            hideTimeLine()
            containerView.hideCloudCoverGraph()
            containerView.drawGraph(graphType: graphType,
                                    values: hourlyData.map { $0.uvIndex })
            
        case .wind:
            hideTimeLine()
            containerView.hideCloudCoverGraph()
            containerView.drawGraph(graphType: graphType,
                                    values: hourlyData.map { $0.wind })
            
        case .rainfall:
            hideTimeLine()
            containerView.hideCloudCoverGraph()
            containerView.drawGraph(graphType: graphType,
                                    values: hourlyData.map { $0.rainfall })
            
        default:
            return
        }
    }
    
    private func setTimeLinePosition(hour: Int, minute: Int) {
        let totalMinutesInDay = 24 * 60
        let currentMinuteOfDay = hour * 60 + minute
        
        let positionFraction = CGFloat(currentMinuteOfDay) / CGFloat(totalMinutesInDay)
        let xPosition = Metric.horizontalPadding + positionFraction * (self.bounds.width - Metric.horizontalPadding * 2)
        
        timeLineView.timeLabel.text = String(format: "%02d", hour) + ":" + String(format: "%02d", minute)
        timeLineView.frame = .init(x: 0, y: 0, width: 20, height: self.bounds.height - Metric.topPadding - Metric.bottomPadding + Metric.labelHeight/2)
        timeLineView.center = CGPoint(x: xPosition, y: self.bounds.height / 2)
        
        timeLineView.layer.animateOpacity(to: 1.0)
    }
    
    private func hideTimeLine() {
        timeLineView.layer.animateOpacity(to: 0.0)
    }
}

extension WeatherGraphCell {
    final class ContainerView: UIView {
        
        struct Metric {
            static let graphTopPadding: CGFloat = 13
            static let graphBottomPadding: CGFloat = 7
            static let extremaPadding: CGFloat = 15
        }
        
        private let pathMaker: PathMaker = PathMaker(graphTopPadding: Metric.graphTopPadding,
                                                     graphBottomPadding: Metric.graphBottomPadding)
        
        private lazy var highestValueLabel =  UILabel().then {
            $0.textColor = AppColor.component(.red).color
            $0.font = AppFont.Description.D2(.semibold).font
            addSubview($0)
        }
        
        private lazy var lowestValueLabel = UILabel().then {
            $0.textColor = AppColor.component(.highlightBlue).color
            $0.font = AppFont.Description.D2(.semibold).font
            addSubview($0)
        }
        
        private lazy var graphShapeLayer: CAShapeLayer = CAShapeLayer().then {
            $0.lineWidth = 2.0
            $0.fillColor = UIColor.clear.cgColor
            layer.addSublayer($0)
        }
        
        private var gradientShapeLayer: CAShapeLayer = CAShapeLayer()
        
        private lazy var gradientLayer: CAGradientLayer = CAGradientLayer().then {
            layer.insertSublayer($0, at: 0)
            $0.frame = self.bounds
            $0.mask = gradientShapeLayer
        }
        
        private lazy var cloudCoverShapeLayer: CAShapeLayer = CAShapeLayer().then {
            $0.lineWidth = 1.0
            $0.strokeColor = AppColor.graph(.cloudBorder).color.cgColor
            $0.fillColor = AppColor.graph(.cloudInside).color.cgColor
            
            layer.addSublayer($0)
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func drawGraph(graphType: GraphType, values: [Double]) {
            drawMainStroke(graphType: graphType, values: values)
            fillMainGradient(graphType: graphType, values: values)
            setHighestLabelPosition(values: values)
            setLowestLabelPosition(values: values)
        }
        
        func drawCloudCoverGraph(cloudCovers: [Double]) {
            let graphPath = pathMaker.makeCloudCoverPath(view: self, cloudCovers: cloudCovers)
            
            cloudCoverShapeLayer.path = graphPath.cgPath
            cloudCoverShapeLayer.animateOpacity(to: 1.0)
        }
        
        func hideCloudCoverGraph() {
            cloudCoverShapeLayer.animateOpacity(to: 0.0)
        }
        
        private func drawMainStroke(graphType: GraphType, values: [Double]) {
            var graphPath = UIBezierPath()
            var strokeColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
            
            switch graphType {
            case .all:
                graphPath = pathMaker.makeTemperaturePath(view: self, temperatures: values)
                strokeColor = AppColor.stroke(.temperatureStroke).color.cgColor
                
            case .apparentTemperature:
                graphPath = pathMaker.makeTemperaturePath(view: self, temperatures: values)
                strokeColor = AppColor.stroke(.apparentTemperatureStroke).color.cgColor
                
            case .uvIndex:
                graphPath = pathMaker.makeUVIndexPath(view: self, uvIndices: values)
                strokeColor = AppColor.stroke(.uvIndexStroke).color.cgColor
                
            case .wind:
                graphPath = pathMaker.makeWindPath(view: self, winds: values)
                strokeColor = AppColor.stroke(.windStroke).color.cgColor
                
            case .rainfall:
                graphPath = pathMaker.makeRainfallPath(view: self, rainfalls: values)
                strokeColor = AppColor.stroke(.rainfallStroke).color.cgColor
                
            default:
                return
            }
            
            graphShapeLayer.animatePath(to: graphPath.cgPath)
            graphShapeLayer.strokeColor = strokeColor
        }
        
        private func fillMainGradient(graphType: GraphType, values: [Double]) {
            var gradientPath: UIBezierPath = UIBezierPath()
            var backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
            
            switch graphType {
            case .all:
                gradientPath = pathMaker.makeTemperatureGradientPath(view: self, temperatures: values)
                backgroundColor = AppColor.strokeGradientBackground(.temperatureBackground).color.cgColor
                
            case .apparentTemperature:
                gradientPath = pathMaker.makeTemperatureGradientPath(view: self, temperatures: values)
                backgroundColor = AppColor.strokeGradientBackground(.apparentTemperatureBackground).color.cgColor
                
            case .uvIndex:
                gradientPath = pathMaker.makeUVIndexGradientPath(view: self, uvIndices: values)
                backgroundColor = AppColor.strokeGradientBackground(.uvIndexBackground).color.cgColor
                
            case .wind:
                gradientPath = pathMaker.makeWindGradientPath(view: self, winds: values)
                backgroundColor = AppColor.strokeGradientBackground(.windBackground).color.cgColor
                
            case .rainfall:
                gradientPath = pathMaker.makeRainfallGradientPath(view: self, rainfalls: values)
                backgroundColor = AppColor.strokeGradientBackground(.rainfallBackground).color.cgColor
                
            default:
                return
            }
            gradientLayer.colors = [backgroundColor,
                                    UIColor.white.cgColor]
            
            gradientShapeLayer.animatePath(to: gradientPath.cgPath)
        }
        
        private func setHighestLabelPosition(values: [Double]) {
            guard let maxElement = values.enumerated().max(by: { $0.element < $1.element }) else { return }
            let maxHeight: CGFloat = 50
            
            let maxIndex = CGFloat(maxElement.offset)
            let maxValue = Int(maxElement.element)
            let xDividedWidth = self.bounds.width / 24
            
            let xPosition = xDividedWidth * maxIndex
            let yPosition = self.bounds.height - maxHeight - Metric.graphBottomPadding - Metric.extremaPadding
            let newPosition = CGPoint(x: xPosition, y: yPosition)
            
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.highestValueLabel.alpha = 0.0
            }, completion: { _ in
                self.highestValueLabel.text = String(maxValue)
                self.highestValueLabel.sizeToFit()
                self.highestValueLabel.center = newPosition
                
                UIView.animate(withDuration: 0.3) {
                    self.highestValueLabel.alpha = 1.0
                }
            })
        }
        
        private func setLowestLabelPosition(values: [Double]) {
            guard let minElement = values.enumerated().min(by: { $0.element < $1.element }) else { return }
            
            let minIndex = CGFloat(minElement.offset)
            let minValue = Int(minElement.element)
            let xDividedWidth = self.bounds.width / 24
            
            let xPosition = xDividedWidth * minIndex
            let yPosition = self.bounds.height - Metric.graphBottomPadding - Metric.extremaPadding
            let newPosition = CGPoint(x: xPosition, y: yPosition)
            
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.lowestValueLabel.alpha = 0.0
            }, completion: { _ in
                self.lowestValueLabel.text = String(minValue)
                self.lowestValueLabel.sizeToFit()
                self.lowestValueLabel.center = newPosition
                
                UIView.animate(withDuration: 0.3) {
                    self.lowestValueLabel.alpha = 1.0
                }
            })
        }
        
        func drawRainFallGraph(rainfalls: [Double]) {
            
            let maxRainfallHeight: CGFloat = 30
            let xDividedWidth = self.bounds.width / 24
            
            var xPosition: CGFloat = 0
            
            for i in 0..<rainfalls.count {
                let rainfall = CGFloat(rainfalls[i])
                
                let rainfallHeight = maxRainfallHeight * rainfall
                
                let view = RainFallView()
                
                if i == 0 || i == rainfalls.count - 1 {
                    view.alpha = 0.5
                }
                else if i == 1 || i == rainfalls.count - 2 {
                    view.alpha = 0.8
                }
                
                addSubview(view)
                view.frame = .init(x: xPosition - 2.5, y: 30, width: 5, height: rainfallHeight)
                xPosition += xDividedWidth
            }
        }
    }
}

extension WeatherGraphCell: Bindable {
    func bind(with model: ViewModel) {
        guard let model = model as? WeatherGraphCellViewModel else { return }
        viewModel = model
        configure()
    }
}
