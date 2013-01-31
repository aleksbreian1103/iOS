//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Nikita Kukushkin on 30/01/2013.
//  Copyright (c) 2013 Nikita Kukushkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

@property (nonatomic, readonly) int score;

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck;
- (NSString *)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@end
