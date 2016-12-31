//
//  AYComment.h
//  PixelMill
//
//  Created by GoGo on 31/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AYComment : NSObject

-(instancetype)initWithDict:(NSDictionary*)dict;
+(NSMutableArray *)commentsWithArray:(NSArray *)array;

@property (nonatomic, assign)NSInteger pid;
@property (nonatomic, strong)NSString *from_user_name;
@property (nonatomic, assign)NSInteger from_user_id;
@property (nonatomic, strong)NSString *to_user_name;
@property (nonatomic, assign)NSInteger to_user_id;
@property (nonatomic, strong)NSString *text;



@end
