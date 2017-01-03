//
//  NetManager.h
//  PixelMill
//
//  Created by GoGo on 30/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NetGetPaintType) {
    NEW = 0,
    HOT,
    MYWORK,
    LIKE,
    FOLLOW,
};


@class UIImage;
@interface AYNetManager : NSObject


+(instancetype)shareManager;

+(void)cancelAllRequest;

-(void)loginWithUser:(NSString*)username password:(NSString*)password success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

-(void)logOutSuccess:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

-(void)registWithName:(NSString*)username password:(NSString*)password success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

-(void)addCommentAtPaint_id:(NSInteger)paint_id toUser_id:(NSInteger)to_user_id Text:(NSString*)text Success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

-(void)getPaintComment:(NSInteger)page paintId:(NSInteger)pid success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure responseCache:(void(^)(id responseObject))responseCache;


-(void)postPaint:(UIImage*)image describe:(NSString*)describe mimeType:(NSString*)mimeType progress:(void (^)(NSProgress *progress))progress Success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

-(void)getPaintTimeLineAtPage:(NSInteger)page type:(NetGetPaintType)type success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure responseCache:(void(^)(id responseObject))responseCache;

-(void)likeAtPaintId:(NSInteger)paint_id success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

-(void)dislikeAtPaintId:(NSInteger)paint_id success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

-(void)unfollowUser:(NSInteger)user_id success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

-(void)followUser:(NSInteger)user_id success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;


-(void)getUserIngoWithId:(NSInteger)user_id success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure responseCache:(void(^)(id responseObject))responseCache;

-(void)getMyIngoWhensuccess:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure responseCache:(void(^)(id responseObject))responseCache;

-(void)changeAvatar:(UIImage*)image progress:(void (^)(NSProgress *progress))progress Success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

-(void)getMessagesSuccess:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

@end
