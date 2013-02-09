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
@end

@implementation SetGameViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//	// Do any additional setup after loading the view.
//}
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
    UIButton *card = (UIButton *) sender;
    NSLog(@"Card at %d flipped", [self.cardButtons indexOfObject:card]);
}


- (IBAction)sliderValueChanged:(id)sender
{
    NSLog(@"Slider value: %f", [self.slider value]);
}


- (IBAction)deal:(id)sender
{
    NSLog(@"Deal clicked");
}

- (CardMatchingGame *) game
{
    if (!_game)
    {
        _game = [[SetCardGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[[SetDeck alloc] init]];
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
    }
}

@end
