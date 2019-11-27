//
//  NavigationMapOutDoorViewController.swift
//  TMapsSample
//
//  Created by Tagipedia on 6/11/19.
//  Copyright © 2019 Tagipedia. All rights reserved.
//

import Foundation
import UIKit
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

@objc protocol NavigationMapDelegate{
    @objc optional func navigationEnd(tGMapViewController :TGMapViewController, origin:CLLocationCoordinate2D, destination:CLLocationCoordinate2D, profile:String, isCanceld:Bool)
}

@objc class NavigationMapOutDoorViewController: UIViewController {
    @objc var delegate:NavigationMapDelegate?
    public var profile : String!
    public var origin : CLLocationCoordinate2D!
    public var destination : CLLocationCoordinate2D!
    public var viewController : ViewController!
    public var tGMapViewController :TGMapViewController!
    
    @objc func setController(controller:TGMapViewController) {
        tGMapViewController = controller;
    }
    @objc func setNeededNavigationDetails(origin:CLLocationCoordinate2D, destination:CLLocationCoordinate2D, profile:String) {
        self.origin = origin;
        self.destination = destination;
        self.profile = profile;
    }
    lazy var accessToken: String = {
        guard let path = Bundle.main.path(forResource: "Config.Secrets", ofType: "plist"),
        let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject],
        let token = dict["mapbox_access_token"] as? String else {
            return ""
        }
        return token
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        let options: NavigationRouteOptions = {
            if(profile == "mapbox/walking"){
                return NavigationRouteOptions(coordinates: [origin, destination], profileIdentifier: MBDirectionsProfileIdentifier.walking)
            }
            else if(profile == "mapbox/cycling"){
                 return NavigationRouteOptions(coordinates: [origin, destination], profileIdentifier: MBDirectionsProfileIdentifier.cycling)
            }
            else if(profile == "mapbox/driving"){
                return NavigationRouteOptions(coordinates: [origin, destination], profileIdentifier: MBDirectionsProfileIdentifier.automobileAvoidingTraffic)
            }
            return NavigationRouteOptions(coordinates: [origin, destination], profileIdentifier: MBDirectionsProfileIdentifier.automobileAvoidingTraffic)
            
        }()
        let direction = Directions.init(accessToken:accessToken)
        direction.calculate(options) { (waypoints, routes, error) in
            guard let route = routes?.first, error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            // For demonstration purposes, simulate locations if the Simulate Navigation option is on.

//            let navigationService = MapboxNavigationService.init(route: route, directions: direction, simulating: true ? .never : .onPoorGPS)
            let navigationService = MapboxNavigationService.init(route: route, directions: direction, simulating:.never)
            let navigationOptions = NavigationOptions.init(navigationService: navigationService)
            let navigationViewController = NavigationViewController.init(for: route, options: navigationOptions)
            navigationViewController.mapView?.delegate = self
            navigationViewController.delegate = self
            self.present(navigationViewController, animated: true, completion: nil)
        }
    }
}

@objc extension NavigationMapOutDoorViewController: MGLMapViewDelegate {
    func navigationViewController(_ navigationViewController: NavigationViewController, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        var annotationImage = navigationViewController.mapView!.dequeueReusableAnnotationImage(withIdentifier: "marker")
        
        if annotationImage == nil {
            // Leaning Tower of Pisa by Stefan Spieler from the Noun Project.
            var image = UIImage(named: "marker")!
            
            // The anchor point of an annotation is currently always the center. To
            // shift the anchor point to the bottom of the annotation, the image
            // asset includes transparent bottom padding equal to the original image
            // height.
            //
            // To make this padding non-interactive, we create another image object
            // with a custom alignment rect that excludes the padding.
            image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height / 2, right: 0))
            
            // Initialize the ‘pisa’ annotation image with the UIImage we just loaded.
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "marker")
        }
        
        return annotationImage
    }
}
extension NavigationMapOutDoorViewController: NavigationViewControllerDelegate {
    func navigationViewControllerDidDismiss(_ navigationViewController: NavigationViewController, byCanceling canceled: Bool){
        navigationController?.popViewController(animated: true)
        self.delegate?.navigationEnd!(tGMapViewController: self.tGMapViewController, origin: self.origin, destination: self.destination, profile: self.profile, isCanceld: canceled);
        dismiss(animated: true, completion: nil)
    }
    
    func navigationViewController(_ navigationViewController: NavigationViewController, didArriveAt waypoint: Waypoint) -> Bool {
        navigationController?.popViewController(animated: true)
        self.delegate?.navigationEnd!(tGMapViewController: self.tGMapViewController, origin: self.origin, destination: self.destination, profile: self.profile, isCanceld: true);
        return true
    }
}
