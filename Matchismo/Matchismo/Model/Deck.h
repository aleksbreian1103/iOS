/*  Deck.h
    Matchismo
    Created by Aleksander B Hansen on 1/25/13.
    Copyright (c) 2013 ClearStoneGroup LLC. All rights reserved. 
 */

#import "Card.h"
#import <Foundation/Foundation.h>



@interface Deck : NSObject

-(void)addCard:(Card *)card atTop:(BOOL)atTop;
-(Card *)drawRandomCard;


@end
