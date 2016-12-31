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
        self.from_user_name = dict[@"from_user_name"];
        self.to_user_id = [dict[@"to_user_id"] integerValue];
        self.to_user_name = dict[@"to_user_name"];
        self.text = dict[@"text"];
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
