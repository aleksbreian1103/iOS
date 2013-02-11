//
//  SetGameViewController.m
//  Machismo
//
//  Created by John Ramsey, Jr on 2/8/13.
//  Copyright (c) 2013 RamFam. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardGame.h"
#import "SetDeck.h"
#import "SetCard.h"

@interface SetGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardDescLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray *moveHistory;
@end

@implementation SetGameViewController


- (NSMutableArray *) moveHistory
{
    if (!_moveHistory) _moveHistory = [[NSMutableArray alloc] init];
    return _moveHistory;
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self updateUI];
}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

- (void) setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (IBAction)flipCard:(id)sender
{
    UIButton *cardButton = (UIButton *) sender;
    int index = [self.cardButtons indexOfObject:cardButton];
    NSLog(@"Card at %d flipped", index);
    [self.game flipCardAtIndex:index];
    if ([self.game cardAtIndex:index].isFaceUp)
        self.flipCount++;
    [self updateUI];
    SetCardGame *g = (SetCardGame *) self.game;
    [self.moveHistory addObject:g.moveAttribDesc];
    [self.slider setValue:(float) self.flipCount animated:NO];
    self.cardDescLabel.alpha = 1.0;
}


- (IBAction)sliderValueChanged:(id)sender
{
    UISlider *sli = (UISlider *) sender;
    int index = (int) [sli value];
    NSLog(@"Slider index is: %d", index);
    
    if (index < 0 || (index > self.flipCount - 1)) return;
    
    if (index < self.flipCount-1)
        self.cardDescLabel.alpha = 0.3;
    else
        self.cardDescLabel.alpha = 1.0;
    
    [self.cardDescLabel setAttributedText:[self.moveHistory objectAtIndex: index]];
}


- (IBAction)deal:(id)sender
{
    NSLog(@"Deal clicked");
    self.game = nil;
    self.flipCount = 0;
    [self updateUI];
}

- (CardMatchingGame *) game
{
    if (!_game)
    {
        _game = [[SetCardGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[[SetDeck alloc] init]];
        
        [self updateUI];
    }
    
    return _game;
}

- (void) updateUI
{
    for (UIButton *cardButton in self.cardButtons)
    {
        int card_index = [self.cardButtons indexOfObject:cardButton];
        SetCard *card = (SetCard *) [self.game cardAtIndex:card_index];
        
        [cardButton setAttributedTitle:[card contents] forState: UIControlStateNormal];
        
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        
        cardButton.alpha = 1.00;
        
        if (cardButton.isSelected)
        {
            cardButton.alpha = 0.20;
        }
        if (!cardButton.isEnabled)
        {
            cardButton.alpha = 0.00;
        }
    }
    
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %d", self.game.score]];

    [self.flipsLabel setText:[NSString stringWithFormat:@"Flips: %d", self.flipCount]];
    SetCardGame *g = (SetCardGame *) self.game;
    
    [self.cardDescLabel setAttributedText:g.moveAttribDesc];
    
    [self.slider setMinimumValue:0.0f];
    [self.slider setMaximumValue:(float) self.flipCount];
    
}

@end
