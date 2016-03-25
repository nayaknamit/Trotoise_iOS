#import "FetcherSampleViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface FetcherSampleViewController () <GMSAutocompleteFetcherDelegate>

@end

@implementation FetcherSampleViewController {
    UITextField *_textField;
    UITextView *_resultText;
    GMSAutocompleteFetcher* _fetcher;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Set bounds to inner-west Sydney Australia.
    CLLocationCoordinate2D neBoundsCorner = CLLocationCoordinate2DMake(-33.843366, 151.134002);
    CLLocationCoordinate2D swBoundsCorner = CLLocationCoordinate2DMake(-33.875725, 151.200349);
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:neBoundsCorner
                                                                       coordinate:swBoundsCorner];
    
    // Set up the autocomplete filter.
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterEstablishment;
    
    // Create the fetcher.
    _fetcher = [[GMSAutocompleteFetcher alloc] initWithBounds:bounds
                                                       filter:filter];
    _fetcher.delegate = self;
    
    // Set up the UITextField and UITextView.
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(5.0f,
                                                               0,
                                                               self.view.bounds.size.width - 5.0f,
                                                               44.0f)];
    _textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_textField addTarget:self
                   action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
    _resultText =[[UITextView alloc] initWithFrame:CGRectMake(0,
                                                              45.0f,
                                                              self.view.bounds.size.width,
                                                              self.view.bounds.size.height - 45.0f)];
    _resultText.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
    _resultText.text = @"No Results";
    _resultText.editable = NO;
    [self.view addSubview:_textField];
    [self.view addSubview:_resultText];
}

- (void)textFieldDidChange:(UITextField *)textField {
    NSLog(@"%@", textField.text);
    [_fetcher sourceTextHasChanged:textField.text];
}

#pragma mark - GMSAutocompleteFetcherDelegate
- (void)didAutocompleteWithPredictions:(NSArray *)predictions {
    NSMutableString *resultsStr = [NSMutableString string];
    for (GMSAutocompletePrediction *prediction in predictions) {
        [resultsStr appendFormat:@"%@\n", [prediction.attributedPrimaryText string]];
    }
    NSLog(@"%@", resultsStr);
}

- (void)didFailAutocompleteWithError:(NSError *)error {
//    _resultText.text = [NSString stringWithFormat:@"%@", error.localizedDescription];
}

@end