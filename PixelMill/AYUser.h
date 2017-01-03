//
//  AYUser.h
//  PixelMill
//
//  Created by GoGo on 31/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AYUser : NSObject

@property (nonatomic, assign)NSInteger pid;
@property (nonatomic, strong)NSString *username;
@property (nonatomic, strong)NSString *avatar;
@property (nonatomic, strong)NSString *profile;
@property (nonatomic, assign)NSInteger followCount;
@property (nonatomic, assign)NSInteger followerCount;


-(instancetype)initWithDict:(NSDictionary*)dict;

@end
