//
//  SetCardGame.h
//  Machismo
//
//  Created by John Ramsey, Jr on 2/8/13.
//  Copyright (c) 2013 RamFam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardMatchingGame.h"

@interface SetCardGame : CardMatchingGame
@property (nonatomic, strong) NSMutableAttributedString *moveAttribDesc;
@end
