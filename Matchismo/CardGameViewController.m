//
//  CardGameViewController.m
//  Matchismo
//


#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "PlayingCard.h" 
#import "Utilities.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (nonatomic, strong) CardMatchingGame *game;
@property (nonatomic) enum GameMode gameMode;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSegmentControl;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@end

@implementation CardGameViewController

// Synchronises Model with the View
- (void)updateUI
{    
    self.statusLabel.text = [self.game.history lastObject];
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.game.flipCount];
    
    self.historySlider.maximumValue = [self.game.history count] - 1;
    self.historySlider.value = self.historySlider.maximumValue;
    
    for (UIButton *cardButton in self.cardButtons) {
        
        // We assume that the cards in the model are PlayingCards,
        // because we need card.faceImage of PlayingCard
        PlayingCard *card = (PlayingCard *)[self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        
       // [cardButton setTitle:card.contents forState:UIControlStateSelected];
      //  [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 0.97;
        
        if (card.isFaceUp) {
            // Shrinking cardFaceImage the size of the button
            UIImage *cardFaceImage = [Utilities imageWithImage:card.faceImage convertToSize:[self.cardButtons[0] size]];
            // and then settings it as an image for the button
            [cardButton setImage:cardFaceImage forState:UIControlStateNormal];
        }
        else {
            // Shrinking cardBackImage the size of the button
            UIImage *cardBackImage = [Utilities imageWithImage:[UIImage imageNamed:@"card-back.png"] convertToSize:[self.cardButtons[0] size]];
            // and then settings it as an image for the button
            [cardButton setImage:cardBackImage forState:UIControlStateNormal];
        }

    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

#pragma mark - Actions

// Resets UI and starts a new game
- (IBAction)deal:(id)sender {
    self.gameModeSegmentControl.enabled = YES;
    self.gameModeSegmentControl.alpha = 1.0;
    self.historySlider.enabled = NO;
    self.historySlider.alpha = 0.0;
    
    self.game = nil; // note: new game creates @ accessor for self.game
    [self updateUI];
}

- (IBAction)slideThruHistory:(UISlider *)sender {
    self.statusLabel.text = self.game.history[(int)sender.value];
}

- (IBAction)flipCard:(UIButton *)sender
{
    // Animating the flip
    [UIView beginAnimations:@"flipCard" context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:sender
                             cache:YES];
    [UIView setAnimationDuration:0.23];
    [UIView commitAnimations];
    
    self.historySlider.enabled = YES;
    self.historySlider.alpha = 1.0;
    self.gameModeSegmentControl.enabled = NO;
    self.gameModeSegmentControl.alpha = 0.0;
    
    // Updating the Model
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    // and syncing it with view
    [self updateUI];
}

#pragma mark - Accessors

- (IBAction)changeGameMode:(UISegmentedControl *)sender {
    // Just gets rid of an old game
    // so it can crate a new one
    // with desired game mode
    self.game = nil; // note: new game creates @ accessor for game
}

- (enum GameMode)gameMode
{
    // gameMode returns value according to the
    // segmentControl's selected index
    // 0 - twoCard game (default)
    // 1 - threeCard game
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

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Settings initial parameters for Views
    self.gameModeSegmentControl.enabled = YES;
    self.gameModeSegmentControl.alpha = 1.0;
    self.historySlider.enabled = NO;
    self.historySlider.alpha = 0.0;
    self.historySlider.minimumValue = 0.0;
    self.statusLabel.text = @"match cards for rank or suit";
    
    // Settings background
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"table-background"]];
}

@end
