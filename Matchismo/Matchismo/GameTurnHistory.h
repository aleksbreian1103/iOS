//
//  GameTurnHistory.h
//  Machismo
//
//  Created by Aleksander B Hansen on 1/30/13.
//  Copyright (c) 2013 ClearStoneGroup LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface GameTurnHistory : NSObject
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) NSString *moveDescription;
@property (nonatomic) int score;

- (void) addCard: (Card *) card;
@end
