//
//  PlayingCard.h
//  Matchismo
//


#import <Foundation/Foundation.h>
#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;
@property (nonatomic, strong) UIImage *faceImage;

+ (NSArray *)rankStrings;
+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
