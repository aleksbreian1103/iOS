//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Nikita Kukushkin on 30/01/2013.
//  Copyright (c) 2013 Nikita Kukushkin. All rights reserved.
//

#import "CardMatchingGame.h"



@interface CardMatchingGame()

@property (nonatomic, readwrite) int score;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic) NSUInteger flipCost;

@end

@implementation CardMatchingGame

#define MATCH_BONUS 5
#define MISMATCH_PENALTY 2

#pragma mark - Game Logic

- (BOOL)checkForGameOver
{
    BOOL gameOver = NO;
    
    NSMutableArray *unplayedCards = [[NSMutableArray alloc] init];
    for (Card *card in self.cards) {
        if (!card.isUnplayable) {
            [unplayedCards addObject:card];
        }
    }
    // If there is less cards than needed for a match then
    // it's a game over (gameMode = 2/3 for twoCard/threeCard)
    if ([unplayedCards count] < self.gameMode) {
        gameOver = YES;
    }
    // If there is more than 8(worst case for 3 card match)
    // cards still ready to be played, game can not be over
    else if ([unplayedCards count] > 8) {
        gameOver = NO;
    }
    // Code below checks for avalable matches
    // if there are none, then the game is over
    else {
        NSUInteger avalableMatches = 0;
        
        if (self.gameMode == twoCards) {
            for (Card *cardOne in unplayedCards) {
                for (Card *cardTwo in unplayedCards) {
                    if([cardOne match:@[cardTwo]]) {
                        avalableMatches++;
                    }
                }
            }
            // Subtrcating duplicate counts
            avalableMatches -= [unplayedCards count];
        }
        // * terrible performance, worse than O(n^3)
        // worst case for the game ~343 enumerations/flip,
        // however need to test on the phone to see if worth optimising
        else if (self.gameMode == threeCards) {
            NSMutableSet *threeCardCombinations = [[NSMutableSet alloc] init];
            for (Card *cardOne in unplayedCards) {
                for (Card *cardTwo in unplayedCards) {
                    for (Card *cardThree in unplayedCards) {
                        NSSet *threeCardCombination = [NSSet setWithArray:@[cardOne, cardTwo, cardThree]];
                        if ([threeCardCombination count] == 3) {
                            [threeCardCombinations addObject:threeCardCombination];
                        }
                    }
                }
            }
            for (NSSet *cardTrioS in [threeCardCombinations allObjects]) {
                NSArray *cardTrio = [cardTrioS allObjects];
                if ([cardTrio[0] match:@[cardTrio[1], cardTrio[2]]]) {
                    avalableMatches++;
                }
            }
        }
    
        gameOver = (avalableMatches) ? NO : YES;
    }

    // Disabling some game fatures
    // since the game is over
    if (gameOver) {
        self.flipCost = 0;
        for (Card *card in unplayedCards) {
            card.faceUp = YES;
        }
    }
    return gameOver;
}

- (NSString *)twoCardGameFlipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    NSString *status = nil;
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        otherCard.unplayable = YES;
                        card.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                        status = [NSString stringWithFormat:@"matched %@ and %@ for %d points", card, otherCard, matchScore * MATCH_BONUS];
                    }
                    else {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        status = [NSString stringWithFormat:@"%@ and %@ don't match: %d points penalty", card, otherCard, MISMATCH_PENALTY];
                    }
                }
            }
            self.score -= self.flipCost;
        }
        card.faceUp = !card.isFaceUp;
    }
    return [self checkForGameOver] ? @"Game Over" : status;
}

- (NSString *)threeCardGameFlipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    NSString *status = nil;
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            NSMutableArray *otherCards = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    [otherCards addObject:otherCard];
                    if (otherCards.count == 2)
                    {
                        int matchScore = [card match:otherCards];
                        if (matchScore) {
                            for (Card *card in otherCards) {
                                card.unplayable = YES;
                            }
                            card.unplayable = YES;
                            self.score += matchScore * MATCH_BONUS;
                            status = [NSString stringWithFormat:@"matched %@ %@ %@ for %d points", card, otherCards[0], otherCards[1], matchScore * MATCH_BONUS];
                        }
                        else {
                            for (Card *card in otherCards) {
                                card.faceUp = NO;
                            }
                            self.score -= MISMATCH_PENALTY;
                            status = [NSString stringWithFormat:@"%@ %@ %@ don't match: %d points penalty", card, otherCards[0], otherCards[1], MISMATCH_PENALTY];
                        }
                    }
                }
            }
            self.score -= self.flipCost;
        }
        card.faceUp = !card.isFaceUp;
    }
    return [self checkForGameOver] ? @"Game Over" : status;
}

#pragma mark - Public

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

- (NSString *)flipCardAtIndex:(NSUInteger)index
{
    if (self.gameMode == threeCards) {
        return [self threeCardGameFlipCardAtIndex:index];
    }
    else {
        return [self twoCardGameFlipCardAtIndex:index];
    }
}

#pragma mark - Accessors

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

#pragma mark - Initializers

- (id)initWithCardCount:(NSUInteger)cardCount andGameMode:(enum GameMode)gameMode usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        self.flipCost = 1;
        self.gameMode = gameMode;
        for (int i = 0; i < cardCount; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
            }
            else {
                self.cards[i] = card;
            }
        }
    }
    
    return self;
}

@end
