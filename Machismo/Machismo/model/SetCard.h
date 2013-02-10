//
//  SetCard.h
//  Machismo
//
//  Created by John Ramsey, Jr on 2/6/13.
//  Copyright (c) 2013 RamFam. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *shading;
@property (nonatomic, strong) NSString *color;

+ (NSArray *) validNumbers;
+ (NSArray *) validSymbols;
+ (NSArray *) validShadings;
+ (NSArray *) validColors;

- (NSAttributedString *) contents;

@end
