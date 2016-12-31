//
//  NetManager.m
//  PixelMill
//
//  Created by GoGo on 30/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYNetManager.h"
#import "AYNetworkHelper.h"
#import "AYNetworkCache.h"
#import <AFNetworking.h>

static NSString *const rootUrl = @"http://192.168.1.103:8000/pm/";

@implementation AYNetManager
{
}

+(instancetype)shareManager
{
    
    static AYNetManager *shareManager = nil;
    if (!shareManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shareManager = [[self alloc] initPrivate];
        });
    }
    return shareManager;
}


- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Single" reason:@"use +(instancetype)shareManager" userInfo:nil];
}


- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


#pragma mark - 登陆 注销 注册
-(void)loginWithUser:(NSString*)username password:(NSString*)password success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure
{
    
    NSDictionary *parameters = @{@"username":username,@"password":password};
    
    [AYNetworkHelper POST:[rootUrl stringByAppendingString:@"api_login"]
               parameters:parameters
                  success:success
                  failure:failure
     ];
}

-(void)logOutSuccess:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure
{

    [AYNetworkHelper GET:[rootUrl stringByAppendingString:@"api_logout"]
              parameters:nil
                 success:success
                 failure:failure
     ];
}

-(void)registWithName:(NSString*)username password:(NSString*)password success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure
{
    
    NSDictionary *parameters = @{@"username":username,@"password":password};
    
    [AYNetworkHelper POST:[rootUrl stringByAppendingString:@"api_regist"]
               parameters:parameters
                  success:success
                  failure:failure
     ];

}


#pragma mark - 发表 评论

//mimeType: gif or png or..
-(void)postPaint:(UIImage*)image describe:(NSString*)describe mimeType:(NSString*)mimeType Success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure
{
    NSString *url = [rootUrl stringByAppendingString:@"api_post"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd#HH:mm:ss"];
    NSString *fileName = [df stringFromDate:[NSDate date]];
    
    [AYNetworkHelper uploadWithURL:url
                        parameters:@{@"describe": describe,}
                            images:@[image]
                              name:@"image"
                          fileName:fileName
                          mimeType:mimeType
                          progress:nil
                           success:success
                           failure:failure
     ];
}


-(void)addCommentAtPaint_id:(NSInteger)paint_id Text:(NSString*)text Success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure
{
    
    NSString *url = [rootUrl stringByAppendingString:@"api_comment"];
    NSDictionary *parameters = @{@"paint_id":[NSString stringWithFormat:@"%ld",paint_id],@"text":text};
    
    [AYNetworkHelper POST:url
               parameters:parameters
                  success:success
                  failure:failure];
    
}



//with cache
-(void)getPaintTimeLineAtPage:(NSInteger)page success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure responseCache:(void(^)(id responseObject))responseCache
{
    NSString *url = [rootUrl stringByAppendingString:@"api_timeline"];
    
    [AYNetworkHelper GET:url parameters:@{@"page":[NSString stringWithFormat:@"%ld",page]} responseCache:responseCache success:success failure:failure];
}


-(void)getPaintComment:(NSInteger)page paintId:(NSInteger)pid success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure responseCache:(void(^)(id responseObject))responseCache
{
    NSString *url = [rootUrl stringByAppendingString:@"api_timeline"];
    
    [AYNetworkHelper GET:url parameters:@{@"page":[NSString stringWithFormat:@"%ld",page],
                                          @"id":[NSString stringWithFormat:@"%ld",pid]}
           responseCache:responseCache
                 success:success
                 failure:failure];
}


- (NSString *)jsonToString:(NSDictionary *)dic
{
    if(!dic){
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
