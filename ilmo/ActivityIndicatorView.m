//
//  ActivityIndicator.m
//
//  Created by Sami Koskimäki on 6/12/12.
//

#import "ActivityIndicatorView.h"

@interface ActivityIndicatorView()

@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) UIView *coveredView;

@end


@implementation ActivityIndicatorView

@synthesize indicator = _indicator;
@synthesize coveredView = _coveredView;


#pragma mark -
#pragma mark Init and dealloc


-(id)init {
    self = [super init];
    
    if (self) {       
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.5; 
    }

    return self;
}


#pragma mark -
#pragma mark Public methods


-(void)startAnimatingOverView:(UIView*)viewToCover {
    if (self.indicator) {
        return;
    }
    
    self.coveredView = viewToCover;
    self.frame = self.coveredView.frame;
    
    self.indicator = [[UIActivityIndicatorView alloc] 
                      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    self.indicator.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [self addSubview:self.indicator];
    
    // Start following updates to frame property of the covered view. This way we can stay
    // on top of it when it is moved or resized.
    [self.coveredView addObserver:self forKeyPath:@"frame" options:0 context:nil];
    [self.coveredView.superview insertSubview:self aboveSubview:self.coveredView];
    [self.indicator startAnimating];
}

-(void)stopAnimating {
    if (!self.coveredView) {
        return;
    }
    
    [self.indicator stopAnimating];
    [self removeFromSuperview];
    [self.coveredView removeObserver:self forKeyPath:@"frame"];
    
    self.indicator = nil;
    self.coveredView = nil;
}


#pragma mark -
#pragma mark NSObject method overrides


// Notified when the frame of the covered view is changed (the view is moved or resized).
-(void)observeValueForKeyPath:(NSString *)keyPath 
                     ofObject:(id)object change:(NSDictionary *)change 
                      context:(void *)context {
    
    if (object == self.coveredView && [keyPath isEqualToString:@"frame"]) {
        // Move this view over the covered view.
        self.frame = self.coveredView.frame;
        
        if (self.indicator) {
            // Center the indicator.
            self.indicator.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        }
    }
}

@end
