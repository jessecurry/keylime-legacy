//
//  KLAnimationSequence.m
//  keylime
//
//  Created by Daniel Tartaglia on 9/7/11.
//

#import "KLAnimationSequence.h"


@implementation KLAnimationSequence

@synthesize images;
@synthesize framesPerSecond;
@synthesize continuous;
@synthesize delegate;


- (id)initWithFrame: (CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self awakeFromNib];
    }
    return self;
}


- (void)dealloc
{
	[imageView release];
	[images release];
	[timer invalidate];
	[timer release];
    [super dealloc];
}


- (void)awakeFromNib
{
	NSAssert(imageView == nil, @"Already woken up.");
	imageView = [[UIImageView alloc] initWithFrame: self.bounds];
	[self addSubview: imageView];
	framesPerSecond = 12;
}


- (BOOL)playing
{
	return timer != nil;
}


- (BOOL)wound
{
	return index == 0;
}


- (BOOL)unwound
{
	return index == images.count;
}


- (NSString*)formatStringForPrefix: (NSString*)prefix
{
	NSString* result = nil;
	int digitCount = 1;
	NSBundle* mainBundle = [NSBundle mainBundle];
	NSString* format = [NSString stringWithFormat: @"%%0.%dd", digitCount];
	NSString* name = [prefix stringByAppendingFormat: format, 0];
	UIImage* image = [UIImage imageWithContentsOfFile: [mainBundle pathForResource: name ofType: @"png"]];
	while (image == nil && digitCount < 10) {
		++digitCount;
		format = [NSString stringWithFormat: @"%%0.%dd", digitCount];
		name = [prefix stringByAppendingFormat: format, 0];
		image = [UIImage imageWithContentsOfFile: [mainBundle pathForResource: name ofType: @"png"]];		
	}
	
	if (image)
		result = format;
	return result;
}


- (void)resetToBeginning
{
	index = 0;
	[self setImage: [images objectAtIndex: 0]];
}


- (void)shutdownTimer
{
	[timer invalidate];
	[timer release];
	timer = nil;
}


- (void)triggerNext
{
	++index;
	if (index < images.count) {
		[self setImage: [images objectAtIndex: index]];
	}
	else {
		if (continuous) {
			[self resetToBeginning];
			if ([delegate respondsToSelector: @selector(animationSequenceDidRestart:)]) {
				[delegate animationSequenceDidRestart: self];
			}
		}
		else {
			[self shutdownTimer];
			if ([delegate respondsToSelector: @selector(animationSequenceDidStop:)]) {
				[delegate animationSequenceDidStop: self];
			}
		}
	}
}


- (void)loadImagesNamedPrefix: (NSString*)prefix
{
	[self loadImagesNamedPrefix: prefix sequenceStep: 1];
}


- (void)loadImagesNamedPrefix: (NSString*)prefix sequenceStep: (NSInteger)step
{
	NSString* formatString = [self formatStringForPrefix: prefix];
	
	if (formatString) {
		NSBundle* mainBundle = [NSBundle mainBundle];
		int i = 0;
		NSMutableArray* imageArray = [[NSMutableArray alloc] init];
		NSString* name = [prefix stringByAppendingFormat: formatString, i * step];
		UIImage* image = [UIImage imageWithContentsOfFile: [mainBundle pathForResource: name ofType: @"png"]];
		while (image) {
			[imageArray addObject: image];
			++i;
			name = [prefix stringByAppendingFormat: formatString, i * step];
			image = [UIImage imageWithContentsOfFile: [mainBundle pathForResource: name ofType: @"png"]];
		}
		[self setImages: imageArray];
		[imageArray release];
	}
	if (images.count) {
		[self setImage: [images objectAtIndex: 0]];
	}
}


- (void)setImage: (UIImage*)image
{
	[imageView setImage: image];
}


- (void)play
{
	if (!self.playing) {
		if (self.unwound) {
			[self rewind];
		}
		timer = [[NSTimer scheduledTimerWithTimeInterval: 1.0 / framesPerSecond target: self selector: @selector(triggerNext) userInfo: nil repeats: YES] retain];
	}
}


- (void)pause
{
	[self shutdownTimer];
}


- (void)rewind
{
	[self resetToBeginning];
}

@end
