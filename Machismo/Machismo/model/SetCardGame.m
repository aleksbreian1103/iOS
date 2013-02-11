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

NSMutableAttributedString * makeLabel(SetCard *card, NSArray *otherCards, BOOL isAMatch)
{
    NSMutableAttributedString  *msg = [[NSMutableAttributedString alloc] initWithAttributedString:[card contents]];
    
    for ( SetCard *otherCard in otherCards )
    {
        NSAttributedString *delim = [[NSAttributedString alloc] initWithString:@","];
        [msg appendAttributedString: delim ];
        [msg appendAttributedString:[otherCard contents]];
    }
    
    NSAttributedString * comment;
    if (isAMatch)
    {
        comment = [[NSAttributedString alloc] initWithString:@"match! 3 pts."];
    }
    else
    {
        comment = [[NSAttributedString alloc] initWithString:@"don't match! -1 pts."];
    }
    
    [msg appendAttributedString:comment];
    
    return msg;
}

@implementation SetCardGame

- (NSMutableAttributedString *) moveAttribDesc
{
    if (!_moveAttribDesc)
    {    
        _moveAttribDesc = [[NSMutableAttributedString alloc] initWithString:@"Welcome to SET!!!!"];
        
        [_moveAttribDesc addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(11, 1) ];
        [_moveAttribDesc addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(12, 1) ];
        [_moveAttribDesc addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(13, 1) ];
    }
    
    return _moveAttribDesc;
}

- (void) flipCardAtIndex:(NSUInteger)index
{
    SetCard *card = (SetCard *) [self cardAtIndex:index];
    
    if (card.isUnplayable) return;
    
    card.faceUp = !card.isFaceUp;
    
    if (card.isFaceUp)
    {
        self.moveAttribDesc = [[NSMutableAttributedString alloc] initWithString:@"You flipped "];
        
        [self.moveAttribDesc appendAttributedString:[card contents]];
        
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
                
                self.moveAttribDesc = makeLabel(card, faceUpCards, YES);
                card.unplayable = YES;
                for (SetCard *s in faceUpCards)
                    s.unplayable = YES;
                    
                
            }
            else
            {
                self.moveAttribDesc = makeLabel(card, faceUpCards, NO);
                card.faceUp = NO;
                for (SetCard *s in faceUpCards)
                    s.faceUp = NO;
                self.score -= 1;
            }
        }
    }
}

@end


