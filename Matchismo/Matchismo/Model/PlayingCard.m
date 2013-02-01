//
//  PlayingCard.m
//  Machismo
//
//  Created by Aleksander B Hansen on 1/30/13.
//  Copyright (c) 2013 ClearStoneGroup LLC. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if (otherCards.count == 1) {
        PlayingCard *otherCard = [otherCards lastObject];
        
        if ([otherCard.suit isEqualToString:self.suit]) {
            score = 1;
        } else if (otherCard.rank == self.rank) {
            score = 4;
        }
    }
    else {
        for (Card *ocard in otherCards) {
            int cardScore = [self match:@[ocard]];
            if (!cardScore) return 0;
            else score += cardScore;
        }
    }
    
    return score;
}

-(NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [NSString stringWithFormat:@"%@-%@", self.suit, rankStrings[self.rank]];
}

@synthesize suit = _suit;

+(NSArray *)validSuits
{
    return @[@"spades", @"hearts", @"diamonds", @"clubs"];
}

+(NSArray *)rankStrings
{
    static NSArray *rankStrings = nil;
    if (!rankStrings) {
        rankStrings = @[@"?", @"a", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"j", @"q", @"k"];
    }
    return rankStrings;
}

+ (NSUInteger) maxRank
{
    return [self rankStrings].count-1;
}

-(void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (void) setSuit:(NSString *) suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}


- (NSString *) suit
{
    return _suit ? _suit : @"?";
}

-(NSString *)imageName
{
    return [self.contents stringByAppendingString:@"-75.png"];
}

@end
