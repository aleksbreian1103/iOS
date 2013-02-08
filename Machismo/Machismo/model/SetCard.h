//
//  SetCard.h
//  Machismo
//
//  Created by John Ramsey, Jr on 2/6/13.
//  Copyright (c) 2013 RamFam. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSString *number;
@property (nonatomic) NSString *symbol;
@property (nonatomic) NSString *shading;
@property (nonatomic) NSString *color;

+ (NSArray *) validNumbers;
+ (NSArray *) validSymbols;
+ (NSArray *) validShadings;
+ (NSArray *) validColors;

@end
