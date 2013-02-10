//
//  PlayingCard.m
//  Matchismo
//


#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] > 0) {
        // Initial assumption that all other
        // cards match with this card
        BOOL matchedSuit = YES;
        BOOL matchedRank = YES;
        
        for (id card in otherCards) { 
            if ([card isKindOfClass:[PlayingCard class]]) {
                PlayingCard *playingCard = (PlayingCard *)card;
                
                // If atleast one card doesn't match
                // we mark initial assumption as false
                if(![self.suit isEqualToString: playingCard.suit]){
                    matchedSuit = NO;
                }
                if(self.rank != playingCard.rank){
                    matchedRank = NO;
                }
                
            }
        }
        // If initial assuptions hold, match returns the score
        // note: only one assuption may stay true!
        score += matchedSuit ? 2 * [otherCards count] : 0;
        score += matchedRank ? 4 * [otherCards count] : 0;
    }
    
    return score;
}


#pragma mark - Utility

+ (NSArray *)validSuits
{
    static NSArray *validSuits = nil;
    if (!validSuits) {
        validSuits = @[@"♠",@"♣",@"♥",@"♦"];
    }
    return validSuits;
}

+ (NSArray *)rankStrings
{
    static NSArray *rankStrings = nil;
    if (!rankStrings) {
        rankStrings = @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
    }
    return rankStrings;
}

+ (NSUInteger)maxRank
{
    return [self rankStrings].count - 1;
}

#pragma mark - Accessors

- (UIImage*)faceImage
{
    if (!_faceImage) {
        NSDictionary *suitNames = @{@"♥":@"heart",
                                    @"♦":@"diamond",
                                    @"♠":@"spade",
                                    @"♣":@"club"};
        // Card image name format:
        // suite(name)-rank(number)
        // e.g. "diamond-13"
        NSString *suitName = [suitNames objectForKey:self.suit];
        if (suitName) {
            NSString *imageName = [NSString stringWithFormat:@"%@-%d", suitName, self.rank];
            _faceImage = [UIImage imageNamed:imageName];
        }
    }
    return _faceImage;
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (NSString *)description
{
    return self.contents;
}


@end
