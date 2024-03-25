//
//  PathMaker.swift
//  WeatherWear
//
//  Created by 디해 on 2024/01/30.
//

import UIKit

class PathMaker {
    
    private var graphTopPadding: CGFloat
    private var graphBottomPadding: CGFloat
    
    init(graphTopPadding: CGFloat = 0, graphBottomPadding: CGFloat = 0) {
        self.graphTopPadding = graphTopPadding
        self.graphBottomPadding = graphBottomPadding
    }
    
    func makeTemperaturePath(view: UIView, temperatures: [Double]) -> UIBezierPath {
        let points = getTemperaturePoints(view: view, temperatures: temperatures)
        
        return smoothLine(with: points)
    }
    
    func makeTemperatureGradientPath(view: UIView, temperatures: [Double]) -> UIBezierPath {
        let points = getTemperaturePoints(view: view, temperatures: temperatures)
        let smoothedPath = smoothLine(with: points)
        
        return makeGradientPath(view: view, path: smoothedPath, points: points)
    }
    
    func makeUVIndexPath(view: UIView, uvIndices: [Double]) -> UIBezierPath {
        let points = getUVIndexPoints(view: view, uvIndices: uvIndices)
        
        return smoothLine(with: points)
    }
    
    func makeUVIndexGradientPath(view: UIView, uvIndices: [Double]) -> UIBezierPath {
        let points = getUVIndexPoints(view: view, uvIndices: uvIndices)
        let smoothedPath = smoothLine(with: points)
        
        return makeGradientPath(view: view, path: smoothedPath, points: points)
    }
    
    func makeWindPath(view: UIView, winds: [Double]) -> UIBezierPath {
        let points = getWindPoints(view: view, winds: winds)
        
        return smoothLine(with: points)
    }
    
    func makeWindGradientPath(view: UIView, winds: [Double]) -> UIBezierPath {
        let points = getWindPoints(view: view, winds: winds)
        let smoothedPath = smoothLine(with: points)
        
        return makeGradientPath(view: view, path: smoothedPath, points: points)
    }
    
    func makeRainfallPath(view: UIView, rainfalls: [Double]) -> UIBezierPath {
        let points = getRainfallPoints(view: view, rainfalls: rainfalls)
        
        return smoothLine(with: points)
    }
    
    func makeRainfallGradientPath(view: UIView, rainfalls: [Double]) -> UIBezierPath {
        let points = getRainfallPoints(view: view, rainfalls: rainfalls)
        let smoothedPath = smoothLine(with: points)
        
        return makeGradientPath(view: view, path: smoothedPath, points: points)
    }
    
    func makeCloudCoverPath(view: UIView, cloudCovers: [Double]) -> UIBezierPath {
        let maxCloudCoverHeight: CGFloat = 10
        let cloudCoverRange: CGFloat = 100
        let xDividedWidth = view.bounds.width / 24
        
        let graphPath = UIBezierPath()
        var isNewLine = true
        var startPoint: CGPoint = CGPoint()
        var reversedPoints: [CGPoint] = []
        
        var xPosition: CGFloat = 0
        
        for i in 0..<cloudCovers.count {
            let cloudCover = CGFloat(cloudCovers[i])
            if cloudCover > 0 {
                let cloudCoverPosition = (cloudCover / cloudCoverRange) * maxCloudCoverHeight
                
                let x = xPosition
                let y = 10 + (maxCloudCoverHeight / 2) - cloudCoverPosition
                let reversedY = 10 + (maxCloudCoverHeight / 2) + cloudCoverPosition
                
                let newPoint = CGPoint(x: x, y: y)
                let reversedPoint = CGPoint(x: x, y: reversedY)
                
                if isNewLine {
                    graphPath.move(to: newPoint)
                    startPoint = newPoint
                    isNewLine = false
                } else {
                    graphPath.addLine(to: newPoint)
                }
                reversedPoints.append(reversedPoint)
            }
            
            else {
                isNewLine = true
                if !reversedPoints.isEmpty {
                    for point in reversedPoints.reversed() {
                        graphPath.addLine(to: point)
                    }
                    graphPath.addLine(to: startPoint)
                    reversedPoints.removeAll()
                    startPoint = CGPoint()
                }
            }
            xPosition += xDividedWidth
        }
        
        isNewLine = true
        if !reversedPoints.isEmpty {
            for point in reversedPoints.reversed() {
                graphPath.addLine(to: point)
            }
            graphPath.addLine(to: startPoint)
            reversedPoints.removeAll()
            startPoint = CGPoint()
        }
        
        return graphPath
    }
    
    private func makeGradientPath(view: UIView, path: UIBezierPath, points: [CGPoint]) -> UIBezierPath {
        if let lastPoint = points.last, let firstPoint = points.first {
            path.addLine(to: CGPoint(x: lastPoint.x, y: view.bounds.height))
            path.addLine(to: CGPoint(x: firstPoint.x, y: view.bounds.height))
            path.addLine(to: firstPoint)
            path.close()
        }
        
        return path
    }
    
    private func smoothLine(with points: [CGPoint]) -> UIBezierPath {
        let graphPath = UIBezierPath()
        
        if let firstPoint = points.first {
            graphPath.move(to: firstPoint)
        }
        
        for index in 1..<points.count {
            let currentPoint = points[index]
            let previousPoint = points[index - 1]
            let midPoint = CGPoint(x: (previousPoint.x + currentPoint.x) / 2, y: (previousPoint.y + currentPoint.y) / 2)
            
            if index == 1 {
                graphPath.addLine(to: midPoint)
            } else {
                let previousMidPoint = CGPoint(x: (points[index - 2].x + previousPoint.x) / 2, y: (points[index - 2].y + previousPoint.y) / 2)
                graphPath.addCurve(to: midPoint, controlPoint1: previousMidPoint, controlPoint2: previousPoint)
            }
        }
        
        if let lastPoint = points.last {
            graphPath.addLine(to: lastPoint)
        }
        
        return graphPath
    }
}

extension PathMaker {
    private func getTemperaturePoints(view: UIView, temperatures: [Double]) -> [CGPoint] {
        let highestTemperature = temperatures.max() ?? 0
        let lowestTemperature = temperatures.min() ?? 0
        
        let xDividedWidth = view.bounds.width / 24
        let maxTemperatureHeight = 50
        let temperatureRange = CGFloat(highestTemperature - lowestTemperature)
        
        var temperaturePoints: [CGPoint] = []
        var currentX: Double = 0
        
        var highestTemperaturePoint: CGPoint?
        var lowestTemperaturePoint: CGPoint?
        
        for temperature in temperatures {
            let temperatureHeight = (Double(temperature - lowestTemperature) / temperatureRange) * Double(maxTemperatureHeight)
            let temperaturePoint = CGPoint(x: currentX,
                                           y: view.bounds.height - graphBottomPadding - temperatureHeight)
            
            if temperature == highestTemperature && highestTemperaturePoint == nil {
                highestTemperaturePoint = temperaturePoint
            }
            if temperature == lowestTemperature && lowestTemperaturePoint == nil {
                lowestTemperaturePoint = temperaturePoint
            }
            
            temperaturePoints.append(temperaturePoint)
            currentX += xDividedWidth
        }
        
        return temperaturePoints
    }
    
    private func getUVIndexPoints(view: UIView, uvIndices: [Double]) -> [CGPoint] {
        let maxUVIndexheight = view.bounds.height - (graphTopPadding + graphBottomPadding)
        let highestUVIndex = uvIndices.max()!
        let lowestUVIndex = uvIndices.min()!
        let uvIndexRange = highestUVIndex - lowestUVIndex
        let xDividedWidth = view.bounds.width / 24
        
        var uvIndexPoints: [CGPoint] = []
        var currentX: Double = 0
        
        for uvIndex in uvIndices {
            let uvIndexHeight = ((uvIndex - lowestUVIndex) / uvIndexRange) * Double(maxUVIndexheight)
            let uvIndexPoint = CGPoint(x: currentX,
                                       y: view.bounds.height - graphBottomPadding - uvIndexHeight)
            
            uvIndexPoints.append(uvIndexPoint)
            currentX += xDividedWidth
        }
        
        return uvIndexPoints
    }
    
    private func getWindPoints(view: UIView, winds: [Double]) -> [CGPoint] {
        let maxWindHeight = view.bounds.height - (graphTopPadding + graphBottomPadding)
        let highestWind = winds.max()!
        let lowestWind = winds.min()!
        let windRange = highestWind - lowestWind
        let xDividedWidth = view.bounds.width / 24
        
        var windPoints: [CGPoint] = []
        var currentX: Double = 0
        
        for wind in winds {
            let windHeight = ((wind - lowestWind) / windRange) * Double(maxWindHeight)
            let windPoint = CGPoint(x: currentX,
                                    y: view.bounds.height - graphBottomPadding - windHeight)
            
            windPoints.append(windPoint)
            currentX += xDividedWidth
        }
        
        return windPoints
    }
    
    private func getRainfallPoints(view: UIView, rainfalls: [Double]) -> [CGPoint] {
        let maxRainfallHeight = view.bounds.height - (graphTopPadding + graphBottomPadding)
        let highestRainfall = rainfalls.max()!
        let lowestRainfall = rainfalls.min()!
        let rainfallRange = highestRainfall - lowestRainfall
        let xDividedWidth = view.bounds.width / 24
        
        var rainfallPoints: [CGPoint] = []
        var currentX: Double = 0
        
        for rainfall in rainfalls {
            let rainfallHeight = ((rainfall - lowestRainfall) / rainfallRange) * Double(maxRainfallHeight)
            let rainfallPoint = CGPoint(x: currentX,
                                        y: view.bounds.height - graphBottomPadding - rainfallHeight)
            
            rainfallPoints.append(rainfallPoint)
            currentX += xDividedWidth
        }
        
        return rainfallPoints
    }
}
