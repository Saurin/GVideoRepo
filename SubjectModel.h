

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SubjectModel : NSManagedObject

@property (nonatomic, retain) NSNumber * subjectId;
@property (nonatomic, retain) NSString * subjectName;
@property (nonatomic, retain) NSString * assetUrl;
@property (nonatomic, retain) NSNumber * rank;

@end
