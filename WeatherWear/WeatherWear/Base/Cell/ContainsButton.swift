//
//  ContainsButton.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/06.
//
import RxSwift

protocol ContainsButton: BaseCell {
    var buttonTap: Observable<Void> { get }
}
