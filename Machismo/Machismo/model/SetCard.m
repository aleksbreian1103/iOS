//
//  SetCard.m
//  Machismo
//
//  Created by John Ramsey, Jr on 2/6/13.
//  Copyright (c) 2013 RamFam. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard


+ (NSArray *) validNumbers
{
    return @[@"1", @"2", @"3"];
}

+ (NSArray *) validSymbols
{
    return @[@"Diamond", @"Squiggle", @"Oval"];
}

+ (NSArray *) validShadings
{
    return @[@"Solid", @"Striped", @"Open"];
}

+ (NSArray *) validColors
{
    return @[@"Red", @"Green", @"Purple"];
}

- (void) setNumber: (NSString *) number
{
    if ([[SetCard validNumbers] containsObject:number])
        _number = number;
}

- (void) setSymbol: (NSString *) symbol
{
    if ([[SetCard validSymbols] containsObject:symbol])
        _symbol = symbol;
}

- (void) setShading:(NSString *)shading
{
    if ([[SetCard validShadings] containsObject:shading])
        _shading = shading;
}

- (void) setColor:(NSString *)color
{
    if ([[SetCard validColors] containsObject:color])
        _color = color;
}

- (int) match:(NSArray *)otherCards
{
    int matchScore = 1;
    
    if ([otherCards count] != 2) return 0;
    
    NSArray *myThreeCards = @[self, [otherCards objectAtIndex:0], [otherCards objectAtIndex:1]];
    
    NSMutableSet *numbersSet = [[NSMutableSet alloc] init];
    NSMutableSet *symbolsSet = [[NSMutableSet alloc] init];
    NSMutableSet *shadingsSet = [[NSMutableSet alloc] init];
    NSMutableSet *colorsSet = [[NSMutableSet alloc] init];
    
    for (SetCard *card in myThreeCards)
    {
        [numbersSet addObject:card.number];
        [symbolsSet addObject:card.symbol];
        [shadingsSet addObject:card.shading];
        [colorsSet addObject:card.color];
    }
    
    if ([numbersSet count] == 2) matchScore = 0;
    if ([symbolsSet count] == 2) matchScore = 0;
    if ([shadingsSet count] == 2) matchScore = 0;
    if ([colorsSet count] == 2) matchScore = 0;
    
    return matchScore;
}

@end