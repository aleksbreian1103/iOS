//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Nikita Kukushkin on 30/01/2013.
//  Copyright (c) 2013 Nikita Kukushkin. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (nonatomic) PlayingCardDeck *cardDeck;
@property (weak, nonatomic) IBOutlet UIButton *cardButton;

@end

@implementation CardGameViewController

- (PlayingCardDeck *)cardDeck
{
    if (!_cardDeck) {
        _cardDeck = [[PlayingCardDeck alloc] init];
    }
    return _cardDeck;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    if (!sender.isSelected) {
        [self.cardButton setTitle:[NSString stringWithFormat:@"%@",[self.cardDeck drawRandomCard]] forState:UIControlStateSelected];
    }
    sender.selected = !sender.isSelected;
    self.flipCount++;
}


@end
