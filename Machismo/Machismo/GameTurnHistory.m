//
//  GameTurnHistory.m
//  Machismo
//
//  Created by John Ramsey, Jr on 1/31/13.
//  Copyright (c) 2013 RamFam. All rights reserved.
//

#import "GameTurnHistory.h"


@implementation GameTurnHistory

- (NSMutableArray *) cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (void) addCard: (Card *) card
{
    Card *c = [card copy];
    [self.cards addObject:c];
}

@end


