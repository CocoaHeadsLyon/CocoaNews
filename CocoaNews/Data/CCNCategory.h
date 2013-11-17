//
//  CCNCategory.h
//  CocoaNews
//
//  Created by Thibaut Jarosz on 14/11/13.
//  Copyright (c) 2013 CocoaHeads Lyon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CCNArticle;

@interface CCNCategory : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *articles;
@end

@interface CCNCategory (CoreDataGeneratedAccessors)

- (void)addArticlesObject:(CCNArticle *)value;
- (void)removeArticlesObject:(CCNArticle *)value;
- (void)addArticles:(NSSet *)values;
- (void)removeArticles:(NSSet *)values;

@end
