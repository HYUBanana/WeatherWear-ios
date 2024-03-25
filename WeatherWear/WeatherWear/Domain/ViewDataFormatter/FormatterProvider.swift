//
//  FormatterProvider.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/06.
//

protocol FormatterProviderType: AnyObject {
    var homeViewDataFormatter: HomeViewDataFormatterType { get }
    var settingViewDataFormatter: SettingViewDataFormatterType { get }
    var detailViewDataFormatter: DetailViewDataFormatterType { get }
}

//final class FormatterProvider: FormatterProviderType {
//    var homeViewDataFormatter: HomeViewDataFormatterType = HomeViewDataFormatter()
//}

final class MockFormatterProvider: FormatterProviderType {
    var homeViewDataFormatter: HomeViewDataFormatterType = MockHomeViewDataFormatter()
    var settingViewDataFormatter: SettingViewDataFormatterType = MockSettingViewDataFormatter()
    var detailViewDataFormatter: DetailViewDataFormatterType = MockDetailViewDataFormatter()
}
