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
    return [NSString stringWithFormat:@"%@-%@", self.suit, rankStrings[self.rank]];
    
}
/* when implementing the getter AND the setter you HAVE to synthesize manually! */
@synthesize suit = _suit;

+(NSArray *)validSuits
{
    return @[@"spades", @"hearts", @"diamonds", @"clubs"];
}


+(NSArray *)rankStrings
{
    return @[@"?", @"a", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"j", @"q", @"k"];
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
-(NSString *)imageName
{
    return [self.contents stringByAppendingString:@"-75.png"];
}

@end
