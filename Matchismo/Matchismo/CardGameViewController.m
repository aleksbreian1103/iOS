/*  CardGameViewController.m
   Matchismo
   Created by Aleksander B Hansen on 1/24/13.
   Copyright (c) 2013 ClearStoneGroup LLC. All rights reserved.
 */
#import "PlayingCardDeck.h"
#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "GameTurnHistory.h"
@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (nonatomic) float sliderValue;
@property (weak, nonatomic) IBOutlet UILabel *cardDescLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchNumSwitch;

@property (strong, nonatomic) NSMutableArray *gameTurnHistory;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation CardGameViewController

- (NSMutableArray *) gameTurnHistory
{
    if (!_gameTurnHistory) _gameTurnHistory = [[NSMutableArray alloc] init];
    return _gameTurnHistory;
}

- (IBAction)deal:(id)sender
{
    self.game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init]];
    
    [self.matchNumSwitch setEnabled:YES];
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
    [self.slider setMaximumValue:50.0f];
    [self.slider setValue: self.sliderValue animated:YES];
    
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
    self.sliderValue++;
    [self.matchNumSwitch setEnabled:NO];
    [self updateUI];
    

}

@end
