#import "NWAppDelegate.h"
#import "NWManager.h"

#define NWHelper (NWManager *)[NWManager sharedInstance]
#define LIGHT_BLUE_COLOR [UIColor colorWithRed:90. / 255 green:150. / 255 blue:200. / 255 alpha:1]
#define LIGHT_BLUE_COLOR2 [UIColor colorWithRed:90. / 255 green:180. / 255 blue:220. / 255 alpha:1]

#define BLUE_TEXT_COLOR [UIColor colorWithRed:10 / 255 green:40 / 255 blue:200. / 255 alpha:1]
#define appDelegate ((NWAppDelegate *)[[UIApplication sharedApplication] delegate]) 

#define FONT @"Helvetica Neue"
#define FONTBOLD @"HelveticaNeue-Bold"


#define CLIENT_ID @"4AI4XUE0BZQ2G1PFEIUITRMTNHQ45I353UMKWF30TPNLAVLK"
#define CLIENT_SECRET @"XJEEEUDB25ATGNQFHN04AGWTCTN0INXEXLBJOMOU25BRM20I"
#define PATH_TO_4SERVER @"https://api.foursquare.com/v2/venues/explore?"
#define LIMIT @"50"
#define RADIUS @"500"

#define OpenTableReserveUrl @"http://opentable.heroku.com/api/restaurants?zip=%@"

static inline double radians (double degrees) { return degrees * M_PI/180; }

typedef enum
{
    SearchPageBy4square,
    
    SearchPagePastSearches,
    
    SearchNewType
    
    
} SearchPageListType;

#define kRCFoursquareClientID           @"LZ0C00MK1JPNA2TJAQ22ZZ4HIRC4OB12I5OUGFCFJQOLMR1C"
#define kRCFoursquareCallbackURL        @"lookaround://foursquare"


#define degrees(x) (180.0 * x / M_PI)

#define chHeadingUpdated @"HeadingUpdated"
#define chMotionUpdated @"MotionUpdated"
#define chOrientationChanged @"OrientationChanged"
#define chLocationUpdated @"LocationUpdated"
#define chLocationMuchUpdated @"LocationMuchUpdated"




#define degreesToRadian(x)              (M_PI * (x) / 180.0)
#define radiansToDegrees(x)             ((x) * 180.0 / M_PI)
#define degreesToRadians(x)             degreesToRadian(x)
#define radiansToDegree(x)              radiansToDegrees(x)



//iphone screen dimensions
#define SCREEN_WIDTH  320
#define SCREEN_HEIGTH 480
#define SCREEN_HEIGTH_5 568



