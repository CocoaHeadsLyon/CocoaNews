//
//  CCNDataManager.h
//  CocoaNews
//
//  Created by Thibaut Jarosz on 14/11/13.
//  Copyright (c) 2013 CocoaHeads Lyon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCNDataManager : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *mainContext;

+ (instancetype)sharedInstance;

- (void)importData;

@end
