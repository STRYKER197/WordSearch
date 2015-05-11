//
//  CustomAnnotation.m
//  WordSearch
//
//  Created by Rodrigo Silva on 5/11/15.
//  Copyright (c) 2015 Rodrigo Silva. All rights reserved.
//

#import "CustomAnnotation.h"


@implementation CustomAnnotation

- (id) initWithTitle: (NSString *)newTitle Location:(CLLocationCoordinate2D)location
{
    self = [super init];
    if (self) {
        _title = newTitle;
        _coordinate = location;
    }
    return self;
}

- (MKAnnotationView *) annotationView
{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MyCustomAnnotation"];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"acerto.png"];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure] ;

    return annotationView;
}

@end
