//
//  SetDeck.m
//  Machismo
//
//  Created by John Ramsey, Jr on 2/8/13.
//  Copyright (c) 2013 RamFam. All rights reserved.
//

#import "SetDeck.h"
#import "SetCard.h"

@implementation SetDeck

- (id) init
{
    self = [super init];
    
    if (self) {
        for (NSString *number in [SetCard validNumbers]) {
            for (NSString *color in [SetCard validColors]){
                for (NSString *symbol in [SetCard validSymbols]) {
                    for (NSString *shading in [SetCard validShadings]) {
                        SetCard *card = [[SetCard alloc] init];
                        card.number = number;
                        card.shading = shading;
                        card.symbol = symbol;
                        card.color = color;
                        
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    
    return self;
}
@end
