//
//  AYPublicHeader.h
//  PixelMill
//
//  Created by GoGo on 19/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#ifndef AYPublicHeader_h
#define AYPublicHeader_h

typedef NS_ENUM(NSUInteger, MOVE) {
    MOVE_UP = 0,
    MOVE_DOWN,
    MOVE_LEFT,
    MOVE_RIGHT,
};


typedef NS_ENUM(NSUInteger, AYCursorDrawType) {
    PEN = 0,
    BUCKET,
    LINE,
    ERASER,
    FINGER,
    CIRCLE,
    COPY,
    COLOR_PICKER,
};
#endif /* AYPublicHeader_h */
