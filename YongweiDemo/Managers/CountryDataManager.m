//
//  CountryDataManager.m
//  YongweiDemo
//
//  Created by Yongwei.Chen on 8/4/14.
//  Copyright (c) 2014 YW. All rights reserved.
//

#import "CountryDataManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "MTLJSONAdapter.h"

@interface CountryDataManager ()

@property (nonatomic, retain) YWCountry *countryCache;

@end

@implementation CountryDataManager

+(instancetype)manager
{
    static CountryDataManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        manager = [[CountryDataManager alloc] init];
    });
    
    return manager;
}

-(void)cacheCountry:(BFTaskCompletionSource *)cs
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.responseSerializer.acceptableContentTypes = JSON_CONTENTTYPE;
    
    [manager GET:COUNTRYDATA_URLSTR parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        self.countryCache = [MTLJSONAdapter modelOfClass:[YWCountry class] fromJSONDictionary:responseObject error:&error];
        if (error) {
            [cs setError:error];
        }
        else {
            [cs setResult:self.countryCache];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [cs setError:error];
    }];
}

/**
 Get country data from cache, very quickly.
 */
-(YWCountry *)country
{
    return self.countryCache;
}

-(void)dealloc
{
    [super dealloc];
    
    [self.countryCache release];
}

@end
