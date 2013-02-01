//
//  GameTurnHistory.h
//  Machismo
//
//  Created by John Ramsey, Jr on 1/31/13.
//  Copyright (c) 2013 RamFam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface GameTurnHistory : NSObject
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) NSString *moveDescription;
@property (nonatomic) int score;

- (void) addCard: (Card *) card;
@end
