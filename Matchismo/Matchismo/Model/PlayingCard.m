/*
PlayingCard.m  
  Matchismo
  Created by Aleksander B Hansen on 1/25/13.
  Copyright (c) 2013 ClearStoneGroup LLC. All rights reserved.
*/

#import "PlayingCard.h"

@implementation PlayingCard


-(int) match:(NSArray *)otherCards {
    int score = 0;
    
    if(otherCards.count == 1) {
        PlayingCard *otherCard = [otherCards lastObject];
        if ([otherCard.suit isEqualToString:self.suit]) {
            score = 1;
        } else if (otherCard.rank == self.rank) {
            score = 4;
        }
    }
    return score;
}


-(NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [NSString stringWithFormat:@"%@-%@", self.suit, rankStrings[self.rank]];
    
}
/* when implementing the getter AND the setter you HAVE to synthesize manually! */
@synthesize suit = _suit;

+(NSArray *)validSuits
{
    static NSArray *validSuits = nil;
    if (!validSuits) {
  validSuits = @[@"spades", @"hearts", @"diamonds", @"clubs"];
    }
    return validSuits;
}
-(void) setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}
-(NSString *)suit
{
    return _suit ? _suit : @"?";
}

+(NSArray *)rankStrings
{
    static NSArray *rankStrings = nil;
    if (!rankStrings) {
        rankStrings = @[@"?", @"a", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"j", @"q", @"k"];
    }
    return rankStrings;
}


+(NSUInteger)maxRank {
    return [self rankStrings].count-1;
}

-(void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}


-(NSString *)imageName
{
    return [self.contents stringByAppendingString:@"-75.png"];
}

@end
