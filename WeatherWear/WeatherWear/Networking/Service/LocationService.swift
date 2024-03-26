//
//  LocationService.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/10.
//

import CoreLocation
import RxSwift

class LocationService: NSObject, CLLocationManagerDelegate {
    static let shared: LocationService = LocationService()
    private let manager = CLLocationManager()
    private let locationSubject = BehaviorSubject<CLLocation?>(value: nil)
    
    var locationObservable: Observable<CLLocation?> {
        return locationSubject.asObservable()
    }
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.requestWhenInUseAuthorization()
    }
    
    func updateLocation() {
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationSubject.onNext(location)
        }
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationSubject.onError(error)
    }
    
    func getPlacemark(with location: CLLocation) -> Single<CLPlacemark> {
        let geocoder = CLGeocoder()
        
        return Single<CLPlacemark>.create { single in
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let _ = error {
                    single(.failure(LocalError("reverse geocode failed")))
                }
                
                if let placemark = placemarks?.first {
                    single(.success(placemark))
                } else {
                    single(.failure(LocalError("no placemark")))
                }
            }
            return Disposables.create()
        }
    }
}
