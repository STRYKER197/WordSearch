//
//  CustomAnnotation.h
//  WordSearch
//
//  Created by Rodrigo Silva on 5/11/15.
//  Copyright (c) 2015 Rodrigo Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>

@interface CustomAnnotation : NSObject <MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;

- (id) initWithTitle: (NSString *)newTitle Location:(CLLocationCoordinate2D)location;
- (MKAnnotationView *) annotationView;


@end
