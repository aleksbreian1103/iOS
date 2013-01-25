/*
PlayingCard.m  
  Matchismo
  Created by Aleksander B Hansen on 1/25/13.
  Copyright (c) 2013 ClearStoneGroup LLC. All rights reserved.
*/

#import "PlayingCard.h"

@implementation PlayingCard


-(NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
    
}
/* when implementing the getter AND the setter you HAVE to synthesize manually! */
@synthesize suit = _suit;

+(NSArray *)validSuits
{
    return @[@"♥", @"♦", @"♠", @"♣"];
}


+(NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
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

@end
