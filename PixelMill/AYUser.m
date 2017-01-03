//
//  AYUser.m
//  PixelMill
//
//  Created by GoGo on 31/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYUser.h"

@implementation AYUser


-(instancetype)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        self.pid = [dict[@"user_id"] integerValue];
        self.username = dict[@"username"];
        self.avatar = dict[@"avatar"];
        self.profile = dict[@"profile"];
        self.followCount = [dict[@"followCount"] integerValue];
        self.followerCount = [dict[@"followerCount"] integerValue];

    }
    return self;
}


@end
