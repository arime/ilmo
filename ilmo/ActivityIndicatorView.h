//
//  ActivityIndicator.h
//
//  Created by Sami Koskimäki on 6/12/12.
//

#import <UIKit/UIKit.h>

/**
 * Standard iOs activity indicator that can be easily placed over some other view. This indicator
 * covers the given view and centers the indicator inside it. If the covered view is resized or
 * moved, this indicator automatically follows it.
 */
@interface ActivityIndicatorView : UIView

-(void)startAnimatingOverView:(UIView*)view;
-(void)stopAnimating;

@end
