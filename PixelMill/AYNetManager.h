//
//  NetManager.h
//  PixelMill
//
//  Created by GoGo on 30/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;
@interface AYNetManager : NSObject


+(instancetype)shareManager;


-(void)loginWithUser:(NSString*)username password:(NSString*)password success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

-(void)logOutSuccess:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

-(void)registWithName:(NSString*)username password:(NSString*)password success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

-(void)addCommentAtPaint_id:(NSInteger)paint_id Text:(NSString*)text Success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

-(void)postPaint:(UIImage*)image describe:(NSString*)describe mimeType:(NSString*)mimeType Success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;



-(void)getPaintTimeLineAtPage:(NSInteger)page success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure responseCache:(void(^)(id responseObject))responseCache;

-(void)getPaintComment:(NSInteger)page paintId:(NSInteger)pid success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure responseCache:(void(^)(id responseObject))responseCache;


@end
