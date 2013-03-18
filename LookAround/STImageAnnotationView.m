//
//

#import "STImageAnnotationView.h"
#import "MapAnnotation.h"

#define kHeight 26
#define kWidth  16
#define kBorder 2

@implementation STImageAnnotationView
@synthesize imageView = _imageView;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	self.frame = CGRectMake(0, 0, kWidth, kHeight);
	self.backgroundColor = [UIColor clearColor];
	
	MapAnnotation* csAnnotation = (MapAnnotation*)annotation;
	
	UIImage* image = [UIImage imageNamed:csAnnotation.userData];
	_imageView = [[UIImageView alloc] initWithImage:image];
	
	//_imageView.frame = CGRectMake(kBorder, kBorder, kWidth - 2 * kBorder, kHeight - 2 * kBorder);
    if([csAnnotation.userData isEqualToString:@"07-map-marker.png"])
    {
        _imageView.frame = CGRectMake(0, 0, 16, 26);

    }
    else {
        _imageView.frame = CGRectMake(0, 0, 16, 26);

    }
	_imageView.contentMode = UIViewContentModeScaleAspectFill;
	_imageView.backgroundColor = [UIColor clearColor];
	[self addSubview:_imageView];
	
	return self;
	
}




@end
