//
//  ContainsSegment.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/06.
//

import RxCocoa

protocol ContainsSegment {
    var segmentTap: ControlEvent<Void> { get }
}
