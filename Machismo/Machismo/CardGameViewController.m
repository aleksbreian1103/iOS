//
//  CardGameViewController.m
//  Machismo
//
//  Created by John Ramsey, Jr on 1/24/13.
//  Copyright (c) 2013 RamFam. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"



@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *cardDescLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchNumSwitch;
@property (nonatomic) float sliderValue;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (nonatomic, strong) NSMutableArray *moveHistory;
@end

@implementation CardGameViewController

- (NSMutableArray *) moveHistory
{
    if (!_moveHistory) _moveHistory = [[NSMutableArray alloc] init];
    return _moveHistory;
}

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    int index = (int) sender.value;
    NSLog(@"Slider index is: %d", index);
    
    if (index < 0 || (index > self.flipCount - 1)) return;
    
    if (index < self.flipCount-1)
        self.cardDescLabel.alpha = 0.3;
    else
        self.cardDescLabel.alpha = 1.0;
    
    self.cardDescLabel.text = [self.moveHistory objectAtIndex: index];
}

- (IBAction)deal:(id)sender
{
    self.game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init]];
    
    [self.matchNumSwitch setEnabled:YES];
    self.flipCount = 0;
    self.sliderValue = 0;
    self.moveHistory = nil;
    [self updateUI];
}

- (IBAction)matchReqChanged:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0)
        self.game.requiredMatches = 2;
    else
        self.game.requiredMatches = 3;
}

- (CardMatchingGame *) game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                          usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}

- (void) setCardButtons:(NSArray *) cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void) updateUI
{
    UIImage *image = [UIImage imageNamed:@"th-1.jpeg"];
    
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
        if (!card.isFaceUp) {
            [cardButton setImage:image forState:UIControlStateNormal];
            cardButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        }
        else {
            [cardButton setImage:nil forState:UIControlStateNormal];
        }

    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    self.cardDescLabel.text = self.game.moveDescription;

    
    [self.slider setMinimumValue:0.0f];
    [self.slider setMaximumValue:(float) self.flipCount];


}

- (void) setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    NSLog(@"Flips updated to %d", flipCount);
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject: sender]];
    self.flipCount++;
    [self.matchNumSwitch setEnabled:NO];

    [self updateUI];
    [self.slider setValue: self.flipCount animated:NO];
    self.cardDescLabel.alpha = 1.0;
    
    [self.moveHistory addObject:self.game.moveDescription];
}


@end
