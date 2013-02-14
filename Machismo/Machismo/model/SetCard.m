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
    return @[@"Circle", @"Triangle", @"Square"];
}

+ (NSArray *) validShadings
{
    return @[@"Solid", @"Shaded", @"Open"];
}

+ (NSArray *) validColors
{
    return @[@"Red", @"Green", @"Blue"];
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

- (NSAttributedString *) contents
{
    NSString *shape;
    NSMutableAttributedString *rval;
    
    if ([self.symbol isEqualToString: @"Circle"])
    {
        shape = @"●";
    }
    else if ([self.symbol isEqualToString:@"Triangle"])
    {
        shape = @"▴";
    }
    else if ([self.symbol isEqualToString:@"Square"])
    {
        shape = @"■";
    }
    
    if ([self.number isEqualToString:@"2"])
    {
        shape = [@[shape, shape] componentsJoinedByString:@""];
    }
    else if ([self.number isEqualToString:@"3"])
    {
        shape = [@[shape, shape, shape] componentsJoinedByString:@""];
    }
    
    rval = [[NSMutableAttributedString alloc] initWithString:shape];
    NSRange rval_length = NSMakeRange(0, [rval length]);
    UIColor *color;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if ([self.color isEqualToString:@"Red"])
    {
        color = [UIColor redColor];
    }
    else if ([self.color isEqualToString:@"Green"])
    {
        color = [UIColor greenColor];
    }
    else if ([self.color isEqualToString:@"Blue"])
    {
        color = [UIColor blueColor];
    }
    
    [dict setObject:color forKey:NSForegroundColorAttributeName];
    
    if ([self.shading isEqualToString:@"Open"])
    {
        [dict setObject:color forKey:NSStrokeColorAttributeName];
        [dict setObject:@3.0 forKey:NSStrokeWidthAttributeName];
    }
    else if ([self.shading isEqualToString:@"Shaded"])
    {
        CGFloat red, blue, green, alpha;
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        
        UIColor *shaded = [UIColor colorWithRed:red green:green blue:blue alpha:0.25];
        
        [dict setObject:shaded forKey:NSForegroundColorAttributeName];
        [dict setObject:color forKey:NSStrokeColorAttributeName];
        [dict setObject:@-3.0 forKey:NSStrokeWidthAttributeName];
    }
       

    [rval addAttributes:dict range:rval_length];
    
    return rval;
}

@end