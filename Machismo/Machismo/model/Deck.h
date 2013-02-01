//
//  Deck.h
//  Machismo
//
//  Created by John Ramsey, Jr on 1/24/13.
//  Copyright (c) 2013 RamFam. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Card.h"

@interface Deck : NSObject


- (void) addCard:(Card *)card
           atTop:(BOOL)atTop;

- (Card *) drawRandomCard;

@end
