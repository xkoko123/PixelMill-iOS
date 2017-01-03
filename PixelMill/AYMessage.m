//
//  AYMessage.m
//  PixelMill
//
//  Created by GoGo on 03/01/2017.
//  Copyright © 2017 tygogo. All rights reserved.
//

#import "AYMessage.h"


@implementation AYMessage



-(instancetype)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        self.from_user = dict[@"from_user"];
        self.from_id = [dict[@"from_user_id"] integerValue];
        self.paint_id = [dict[@"paint_id"] integerValue];
        self.type = [dict[@"type"] integerValue];
    }
    return self;
}

@end
