
//

#import "MapAnnotation.h"

@implementation MapAnnotation

@synthesize title, subtitle, coordinate, tag;
@synthesize userData       = _userData;
@synthesize annotationType = _annotationType;

- (id)initWithUser:(CLLocationCoordinate2D)coord  name:(NSString *)name annotationType:(WPMapAnnotationType) annotationType{
	if (self = [super init]) {
		self.title = name;
		//self.subtitle = [user desc];
		coordinate.longitude = coord.longitude;
		coordinate.latitude = coord.latitude;
		_annotationType = annotationType;
        

        if(annotationType == WPMapAnnotationCategoryImage)
        {
            self.userData = @"pin1.png";
            
        }
		return self;
	}
	return self;
}

- (id)initWithUser:(CLLocationCoordinate2D)coord  name:(NSString *)name annotationType:(WPMapAnnotationType) annotationType tagMe:(NSInteger)tagMe{
	if (self = [super init]) {
		self.title = name;
		//self.subtitle = [user desc];
		coordinate.longitude = coord.longitude;
		coordinate.latitude = coord.latitude;
		_annotationType = annotationType;
        tag = tagMe;
        
        if(annotationType == WPMapAnnotationCategoryImage)
        {
            self.userData = @"pin1.png";
            
        }
		return self;
	}
	return self;
}


@end
