//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Nikita Kukushkin on 30/01/2013.
//  Copyright (c) 2013 Nikita Kukushkin. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (nonatomic) int flipCount;
@property (nonatomic, strong) CardMatchingGame *game;
@property (nonatomic) enum GameMode gameMode;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSegmentControl;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@end

@implementation CardGameViewController


// Utility method to resize images
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (void)updateUI
{
    UIImage *cardBackImage = [UIImage imageNamed:@"CardBack.jpg"];
    cardBackImage = [self imageWithImage:cardBackImage convertToSize:[self.cardButtons[0] size]];
    
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
        if (!cardButton.selected){
            [cardButton setImage:cardBackImage forState:UIControlStateNormal];
        }
        else {
            [cardButton setImage:nil forState:UIControlStateNormal];
        }
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

#pragma mark - Actions

- (IBAction)deal:(id)sender {
    self.gameModeSegmentControl.enabled = YES;
    self.flipCount = 0;
    self.statusLabel.text = @"match cards of the same rank or suite";
    self.game = nil;
    [self updateUI];
}

- (IBAction)flipCard:(UIButton *)sender
{
    self.gameModeSegmentControl.enabled = NO;
    self.statusLabel.text = [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}

#pragma mark - Accessors

- (IBAction)changeGameMode:(UISegmentedControl *)sender {
    // Just gets rid of an old game
    // so it can crate a new one
    // with desired game mode
    self.game = nil;
}

- (enum GameMode)gameMode
{
    if (self.gameModeSegmentControl.selectedSegmentIndex == 1) {
        return threeCards;
    }
    else {
        return twoCards;
    }
}

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] andGameMode:self.gameMode usingDeck:[[PlayingCardDeck alloc] init]];
    }
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.statusLabel.text = @"match cards of the same rank or suite";
    
    UIEdgeInsets insets = UIEdgeInsetsMake(5, 6, 5, 6);
    for (UIButton *cardButton in self.cardButtons) {
        [cardButton setImageEdgeInsets:insets];
    }
}

@end
