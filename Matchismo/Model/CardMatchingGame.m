//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Nikita Kukushkin on 30/01/2013.
//  Copyright (c) 2013 Nikita Kukushkin. All rights reserved.
//

#import "CardMatchingGame.h"
#import "PlayingCard.h"

@interface CardMatchingGame()

// Keeps track of how many cards
// are being matched this game
@property (nonatomic) enum GameMode gameMode;

@property (nonatomic, readwrite) NSArray *history;
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) int flipCount;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic) NSUInteger flipCost;
@property (nonatomic) NSUInteger matchBonus;
@property (nonatomic) NSUInteger mismatchPenalty;
@end

@implementation CardMatchingGame

#pragma mark - Game Logic

- (BOOL)isGameOver
{
    BOOL gameOver = YES;
    
    // Getting an array of cards
    // that haven't been played yet
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
    else {
        
        // Dictionaries will hold the number of avalable suits and ranks
        NSMutableDictionary *ranks = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *suits = [[NSMutableDictionary alloc] init];
        
        // Initiating
        for (NSString *rank in [PlayingCard rankStrings]) {
            [ranks setObject:@0 forKey:rank];
        }
        for (NSString *suit in [PlayingCard validSuits]) {
            [suits setObject:@0 forKey:suit];
        }
        
        // Filling with values
        for (PlayingCard *card in unplayedCards) {
            NSNumber *rankNum = [ranks objectForKey:[PlayingCard rankStrings][card.rank]];
            NSNumber *suitNum = [suits objectForKey:card.suit];
            rankNum = [NSNumber numberWithInt:[rankNum intValue] + 1];
            suitNum = [NSNumber numberWithInt:[suitNum intValue] + 1];
            [ranks setObject:rankNum forKey:[PlayingCard rankStrings][card.rank]];
            [suits setObject:suitNum forKey:card.suit];
        }
        

        // If there are enouch equal rank or suits for
        // a match then the game can no be over
        for (NSString *key in suits) {
            if ([[suits objectForKey:key] intValue] >= self.gameMode) {
                gameOver = NO;
                break;
            }
        }
        if (gameOver) {
            for (NSString *key in ranks) {
                if ([[ranks objectForKey:key] intValue] >= self.gameMode) {
                    gameOver = NO;
                    break;
                }
            }
        }
    }
    // Reacting to game over
    if (gameOver) {
        self.flipCost = 0;
        if (![[self.history lastObject] isEqualToString:@"Game Over"]) {
            self.history = [self.history arrayByAddingObject:@"Game Over"];
        }
        for (Card *card in unplayedCards) {
            card.faceUp = YES;
        }
    }
    return gameOver;
}

#pragma mark - Public

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    NSString *status = nil;
    
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            status = [NSString stringWithFormat:@"lost 1 point for flipping %@", card];
            
            NSMutableArray *otherCards = [[NSMutableArray alloc] init];
            
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    
                    [otherCards addObject:otherCard];
                    
                    // gameMode = 2/3 for twoCard/threeCard
                    if (otherCards.count == self.gameMode - 1)
                    {
                        int matchScore = [card match:otherCards];
                        if (matchScore) {
                            for (Card *card in otherCards) {
                                card.unplayable = YES;
                            }
                            card.unplayable = YES;
                            
                            self.score += matchScore * self.matchBonus;
                            status = [NSString stringWithFormat:@"matched %@ %@ for %d points",
                                      card,
                                      [otherCards componentsJoinedByString:@" "],
                                      matchScore * self.matchBonus];
                        }
                        else {
                            for (Card *card in otherCards) {
                                card.faceUp = NO;
                            }
                            self.score -= self.mismatchPenalty;
                            status = [NSString stringWithFormat:@"%@ %@ don't match: -%d points",
                                      card,
                                      [otherCards componentsJoinedByString:@" "],
                                      self.mismatchPenalty];
                        }
                    }
                }
            }
            self.score -= self.flipCost;
        }
        card.faceUp = !card.isFaceUp;
    }
    if (![self isGameOver]) {
        self.flipCount++;
        if (status) {
            self.history = [self.history arrayByAddingObject:status];
        }
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

- (NSArray *)history
{
    if (!_history) {
        _history = @[@"match cards for rank or suit"];
    }
    return _history;
}

#pragma mark - Initializers

- (id)initWithCardCount:(NSUInteger)cardCount andGameMode:(enum GameMode)gameMode usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        // Initializing game settings
        self.flipCost = 1;
        self.matchBonus = 5;
        self.mismatchPenalty = 2;
        
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
