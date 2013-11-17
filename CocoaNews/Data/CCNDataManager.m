//
//  CCNDataManager.m
//  CocoaNews
//
//  Created by Thibaut Jarosz on 14/11/13.
//  Copyright (c) 2013 CocoaHeads Lyon. All rights reserved.
//

#import "CCNDataManager.h"

#import "CCNArticle.h"
#import "CCNCategory.h"

@import CoreData;

@interface CCNDataManager ()

@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStore;
@end

@implementation CCNDataManager

@synthesize persistentStore=_persistentStore;
@synthesize mainContext=_mainContext;

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

- (NSPersistentStoreCoordinator *)persistentStore
{
    if ( _persistentStore )
        return _persistentStore;
    
    
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSURL *url = [[[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject] URLByAppendingPathComponent:@"Data.sqlite"];
    
    _persistentStore = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    [_persistentStore addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:nil];
    
    return _persistentStore;
}

- (NSManagedObjectContext *)mainContext
{
    if ( _mainContext )
        return _mainContext;
    
    _mainContext = [[NSManagedObjectContext alloc] init];
    _mainContext.persistentStoreCoordinator = self.persistentStore;
    
    return _mainContext;
}

- (void)importData
{
    // Getting existing categories
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Category"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    
    NSMutableDictionary *oldCategories = [NSMutableDictionary new];
    [[self.mainContext executeFetchRequest:request error:nil] enumerateObjectsUsingBlock:^(CCNCategory *category, NSUInteger idx, BOOL *stop) {
        [oldCategories setObject:category forKey:category.identifier];
    }];
    
    
    for ( NSUInteger i = 0 ; i < 3 ; i++ )
    {
        NSString *catIdentifier = nil;
        NSString *catName = nil;
        
        switch (i)
        {
            case 0:
                catName = @"OS X";
                catIdentifier = @"2DCEA115";
                break;
            case 1:
                catName = @"iOS";
                catIdentifier = @"A5335746";
                break;
            case 2:
                catName = @"Common";
                catIdentifier = @"F130467D";
                break;
            default:
                break;
        }
        
        // Fetch if category already exists
        CCNCategory *category = [oldCategories objectForKey:catIdentifier];
        if ( category )
        {
            [oldCategories removeObjectForKey:catIdentifier];
        }
        else
        {
            category = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:self.mainContext];
            category.identifier = catIdentifier;
        }
        
        
        // Update category
        if ( category.name != catName || ![category.name isEqualToString:catName] )
            category.name = catName;
        
        
        
        // Fetoch existing articles
        NSMutableDictionary *oldArticles = [NSMutableDictionary new];
        [category.articles enumerateObjectsUsingBlock:^(CCNArticle *article, BOOL *stop) {
            NSString *identifier = article.identifier ? : @"";
            if ( [oldArticles objectForKey:identifier] )
                [self.mainContext deleteObject:article]; // Delete duplicated article
            else
                [oldArticles setObject:article forKey:identifier];
        }];
        
        
        for ( NSUInteger j = 0 ; j < 5 ; j++ )
        {
            NSString *artTitle = [NSString stringWithFormat:@"Article %d", j];
            NSString *artIdentifier = [NSString stringWithFormat:@"%@-%d", catIdentifier, j];
            
            // Fetch if article already exists
            CCNArticle *article = [oldArticles objectForKey:artIdentifier];
            if ( article )
            {
                [oldArticles removeObjectForKey:artIdentifier];
            }
            else
            {
                article = [NSEntityDescription insertNewObjectForEntityForName:@"Article" inManagedObjectContext:self.mainContext];
                article.identifier = artIdentifier;
                [category addArticlesObject:article]; // Add article to category
            }
            
            if ( article.title != artTitle || ![article.title isEqualToString:artTitle] )
                article.title = artTitle;
        }
        
        [oldArticles enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [self.mainContext deleteObject:obj];
        }];
    }
    
    [oldCategories enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self.mainContext deleteObject:obj];
    }];
    
    if ( [self.mainContext hasChanges] )
        [self.mainContext save:nil];
}

@end
