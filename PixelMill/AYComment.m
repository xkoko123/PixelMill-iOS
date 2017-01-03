//
//  AYComment.m
//  PixelMill
//
//  Created by GoGo on 31/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYComment.h"

@implementation AYComment


-(instancetype)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        self.pid = [dict[@"comment_id"] integerValue];
        self.from_user_id = [dict[@"from_user_id"] integerValue];
        self.from_user = dict[@"from_user"];
        self.to_user_id = [dict[@"to_user_id"] integerValue];
        self.to_user = dict[@"to_user"];
        self.text = dict[@"text"];
        self.from_user_avatar = dict[@"from_user_avatar"];
    }
    return self;
}


+(NSMutableArray *)commentsWithArray:(NSArray *)array
{
    NSMutableArray *am = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in array) {
        AYComment *comment = [[AYComment alloc] initWithDict:dict];
        [am addObject:comment];
    }
    return am;
}

@end
