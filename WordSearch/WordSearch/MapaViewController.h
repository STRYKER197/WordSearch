//
//  MapaViewController.h
//  WordSearch
//
//  Created by Rodrigo Silva on 5/8/15.
//  Copyright (c) 2015 Rodrigo Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>

@interface MapaViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic , retain) IBOutlet MKMapView *mapKit;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblPoint;

@property (weak, nonatomic) IBOutlet UILabel *lblPais;

@end
