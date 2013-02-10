//
//  SetCardGame.m
//  Machismo
//
//  Created by John Ramsey, Jr on 2/8/13.
//  Copyright (c) 2013 RamFam. All rights reserved.
//

#import "SetCardGame.h"
#import "SetCard.h"
@interface SetCardGame()
@property (nonatomic, readwrite) int score;

@end;

@implementation SetCardGame

- (void) flipCardAtIndex:(NSUInteger)index
{
    SetCard *card = (SetCard *) [self cardAtIndex:index];
    
    if (card.isUnplayable) return;
    
    card.faceUp = !card.isFaceUp;
    
    if (card.isFaceUp)
    {
        
        NSMutableArray *faceUpCards = [[NSMutableArray alloc] init];
        
        for (SetCard *otherCard in self.cards)
        {
            if (card == otherCard) continue;
            
            if ( otherCard.isFaceUp && !otherCard.isUnplayable )
            {
                [faceUpCards addObject:otherCard];
            }
        }
        
        if ( [faceUpCards count] == 2 )
        {
            int matchscore = [card match:faceUpCards];
            
            if (matchscore)
            {
                self.score += 3;
                
                card.unplayable = YES;
                for (SetCard *s in faceUpCards)
                    s.unplayable = YES;
            }
            else
            {
                card.faceUp = NO;
                for (SetCard *s in faceUpCards)
                    s.faceUp = NO;
                self.score -= 1;
            }
        }
    }
}

@end
