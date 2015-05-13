//
//  Score.h
//  WordSearch
//
//  Created by Rodrigo Silva on 5/13/15.
//  Copyright (c) 2015 Rodrigo Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Score : NSManagedObject

@property (nonatomic, retain) NSString * pontuacao;
@property (nonatomic, retain) NSString * data;

@end
