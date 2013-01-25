/*  CardGameViewController.m
   Matchismo
   Created by Aleksander B Hansen on 1/24/13.
   Copyright (c) 2013 ClearStoneGroup LLC. All rights reserved.
 */
#import "PlayingCardDeck.h"
#import "CardGameViewController.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) PlayingCardDeck *deck;
@end

@implementation CardGameViewController

- (PlayingCardDeck *) deck
{
    if (!_deck) {
        _deck = [[PlayingCardDeck alloc] init];
    }
    
    return _deck;
}

-(void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d",self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    if (sender.selected) {
        Card *card = [self.deck drawRandomCard];
        if (card) {
            self.flipCount++;
            [sender setTitle:[card contents] forState:UIControlStateSelected];
            
        }
    }
}





@end
