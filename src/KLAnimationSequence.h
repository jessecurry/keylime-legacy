//
//  KLAnimationSequence.h
//  keylime
//
//  Created by Daniel Tartaglia on 9/7/11.
//

#import <UIKit/UIKit.h>
@class KLAnimationSequence;


@protocol KLAnimationSequenceDelegate <NSObject>
- (void)animationSequenceDidRestart: (KLAnimationSequence*)animationSequence;
- (void)animationSequenceDidStop: (KLAnimationSequence*)animationSequence;
@end


@interface KLAnimationSequence : UIView
{
	NSArray* images;
	NSInteger framesPerSecond;
	BOOL continuous;
	id<KLAnimationSequenceDelegate> delegate;

	UIImageView* imageView;
	NSInteger index;
	NSTimer* timer;
}

@property (nonatomic, copy) NSArray* images;
@property (nonatomic, assign) NSInteger framesPerSecond;
@property (nonatomic, assign) BOOL continuous;
@property (nonatomic, assign) id<KLAnimationSequenceDelegate> delegate;

- (BOOL)playing;
- (BOOL)wound;
- (BOOL)unwound;

- (void)loadImagesNamedPrefix: (NSString*)prefix;
- (void)loadImagesNamedPrefix: (NSString*)prefix sequenceStep: (NSInteger)step;
- (void)setImage: (UIImage*)image;

- (void)play;
- (void)pause;
- (void)rewind;

@end
