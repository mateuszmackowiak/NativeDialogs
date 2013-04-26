/*
 * NativeDialogs
 *
 * Created by Mateusz Mackowiak on 02.02.2013.
 * Copyright (c) 2013 __MyCompanyName__. All rights reserved.
 */

#import "FlashRuntimeExtensions.h"
#import "NativeDialogControler.h"
#import "SVProgressHUD.h"
#import "WToast.h"

#define MYDEBUG

#pragma mark - dialog methods


FREObject showAlertWithTitleAndMessage (FREContext ctx, void* functionData, uint32_t argc, FREObject argv[] ){
    NativeDialogControler *nativeDialogController = functionData;
    //Temporary values to hold our actionscript code.


    uint32_t stringLength;
    const uint8_t *title = nil;
    const uint8_t *message = nil;
    const uint8_t *closeLabel;
    const uint8_t *otherLabels = nil;
    
    NSString *titleString = nil;
    NSString *messageString = nil;
    NSString *closeLabelString = nil;
    NSString *otherLabelsString = nil;
    
    //Turn our actionscrpt code into native code.
    if(argv[0] && FREGetObjectAsUTF8(argv[0], &stringLength, &title)==FRE_OK){
        titleString = [NSString stringWithUTF8String:(char*)title];
    }
    if(argv[1] && FREGetObjectAsUTF8(argv[1], &stringLength, &message)==FRE_OK){
        messageString = [NSString stringWithUTF8String:(char*)message];
    }
    if(argv[2] && FREGetObjectAsUTF8(argv[2], &stringLength, &closeLabel)==FRE_OK){
        closeLabelString = [NSString stringWithUTF8String:(char*)closeLabel];
    }
    if(argv[3] && FREGetObjectAsUTF8(argv[3], &stringLength, &otherLabels)==FRE_OK){
        otherLabelsString = [NSString stringWithUTF8String:(char*)otherLabels];
    }
    
    //Create our Strings for our Alert.
    
    
    
    [nativeDialogController showAlertWithTitle:titleString
                      message:messageString
                   closeLabel:closeLabelString
                  otherLabels:otherLabelsString];
    return NULL;
}

FREObject showListDialog (FREContext ctx, void* functionData, uint32_t argc, FREObject argv[] )
{
    NativeDialogControler *nativeDialogController = functionData;
    
    //Temporary values to hold our actionscript code.
    uint32_t stringLength;
    const uint8_t *title;
    const uint8_t *message;
    uint32_t cancelableInt;
    BOOL cancelable;
    
    NSString *titleString = nil;
    NSString *messageString = nil;
    
    if(argv[0] && (FREGetObjectAsUTF8(argv[0], &stringLength, &title)==FRE_OK)){
        titleString = [NSString stringWithUTF8String:(char*)title];
    }
    if(argv[4] && (FREGetObjectAsBool(argv[4], &cancelableInt)==FRE_OK)) {
        cancelable = cancelableInt == 1;
    }
    
    uint32_t type;
    FREGetObjectAsUint32(argv[5], &type);
    
    if(argv[6] && (FREGetObjectAsUTF8(argv[6], &stringLength, &message)==FRE_OK)){
        messageString = [NSString stringWithUTF8String:(char*)message];
    }
    
    [nativeDialogController showSelectDialogWithTitle:titleString message:messageString type:type options:argv[2] checked: argv[3] buttons:argv[1]];
    [nativeDialogController setCancelable:cancelable];

    return NULL;
}


FREObject showTextInputDialog(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[] )
{
    NativeDialogControler *nativeDialogController = functionData;
    //Temporary values to hold our actionscript code.
    uint32_t stringLength;
    const uint8_t *title;
    const uint8_t *message;
    
    //Create our Strings for our Alert.
    
    
    NSString *titleString = nil;
    NSString *messageString =nil;
    
    if(argv[0] &&  (FREGetObjectAsUTF8(argv[0], &stringLength, &title)==FRE_OK)){
        titleString = [NSString stringWithUTF8String:(char*)title];
    }
    if(argv[1] &&  FREGetObjectAsUTF8(argv[1], &stringLength, &message)==FRE_OK){
        messageString = [NSString stringWithUTF8String:(char*)message];
    }
    [nativeDialogController showTextInputDialog:titleString message:messageString textInputs:argv[2] buttons:argv[3]];
    
    
    return nil;
}

FREObject isShowing(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[] ){
    NativeDialogControler *nativeDialogController = functionData;

    FREObject returnVal;
    FRENewObjectFromBool([nativeDialogController isShowing], &returnVal);
    
    return returnVal;
}



FREObject updateMessage(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[] ){
    NativeDialogControler *nativeDialogController = functionData;
    
    uint32_t messageLength;
    const uint8_t *message;
    
    NSString*messageString = nil;
    //Turn our actionscrpt code into native code.
    if(FREGetObjectAsUTF8(argv[0], &messageLength, &message)==FRE_OK){
        messageString = [NSString stringWithUTF8String:(char*)message];
    }
    
    [nativeDialogController updateMessage:messageString];
    return nil;
}




FREObject updateTitle(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[] )
{
    NativeDialogControler *nativeDialogController = functionData;
    
    uint32_t titleLength;
    const uint8_t *title;
    
    NSString*titleString = nil;
    //Turn our actionscrpt code into native code.
    if(argv[0] && FREGetObjectAsUTF8(argv[0], &titleLength, &title)==FRE_OK){
        titleString = [NSString stringWithUTF8String:(char*)title];
    }
    [nativeDialogController updateTitle:titleString];
    
    return nil;
}



FREObject shake(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[] ){
     NativeDialogControler *nativeDialogController = functionData;
    [nativeDialogController shake];
    return nil;
}

FREObject dismiss(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[] )
{
    NativeDialogControler *nativeDialogController = functionData;
    int32_t index = 0;
    if(argv[0])
        FREGetObjectAsInt32(argv[0], &index);
    
    [nativeDialogController dismissWithButtonIndex:index];
    [SVProgressHUD dismiss];
    return nil;
}


FREObject showProgressPopup (FREContext ctx, void* functionData, uint32_t argc, FREObject argv[] )
{
    NativeDialogControler *nativeDialogController = functionData;
    //Temporary values to hold our actionscript code.
    uint32_t stringLength;
    
    const uint8_t *title = nil;
    const uint8_t *message = nil;
    double progressParam = 0;
    
    uint32_t showActivityValue = 0, cancleble = 0;
    int32_t style = 0 ,theme = 0;
    
    
    NSString *titleString = nil;
    NSString *messageString = nil;
    
    
    //Turn our actionscrpt code into native code.
    if(argv[3] && FREGetObjectAsUTF8(argv[3], &stringLength, &title)==FRE_OK){
        if(title)
            titleString = [NSString stringWithUTF8String:(char*)title];
    }
    
    if(argv[4] && FREGetObjectAsUTF8(argv[4], &stringLength, &message)==FRE_OK){
        if(message)
            messageString =[NSString stringWithUTF8String:(char*)message];
    }
    
    FREGetObjectAsDouble(argv[0], &progressParam);
    ///Secondary progress ignored
    FREGetObjectAsInt32(argv[2], &style);
    FREGetObjectAsBool(argv[5], &cancleble);
    FREGetObjectAsBool(argv[6], &showActivityValue);
    FREGetObjectAsInt32(argv[7], &theme);
    
    
    
    
    if(theme == 2){
        if(messageString && ![messageString isEqualToString:@""]){
            if(cancleble)
                [SVProgressHUD showWithStatus:messageString];
            else
                [SVProgressHUD showWithStatus:messageString maskType:SVProgressHUDMaskTypeBlack];
        }else {
                if (cancleble)
                    [SVProgressHUD show];
                else
                    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            }
    
    }else if(theme == 3){
        if(messageString && ![messageString isEqualToString:@""]){
            if(cancleble)
                [SVProgressHUD showWithStatus:messageString];
            else
                [SVProgressHUD showWithStatus:messageString maskType:SVProgressHUDMaskTypeClear];
        } else {
                if (cancleble)
                    [SVProgressHUD show];
                else
                    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            }
    }else if(theme == 4){
        if(messageString && ![messageString isEqualToString:@""]){
            if(cancleble)
                [SVProgressHUD showWithStatus:messageString];
            else
                [SVProgressHUD showWithStatus:messageString maskType:SVProgressHUDMaskTypeGradient];
        }else {
                if (cancleble)
                    [SVProgressHUD show];
                else
                    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
            }
    }else{

        NSNumber *progressValue =[NSNumber numberWithDouble:progressParam];
        
        [nativeDialogController showProgressPopup:titleString
                           style:style
                         message:messageString
                        progress:progressValue
                    showActivity:showActivityValue
                       cancleble:cancleble];
    }
    return nil;
}



FREObject updateProgress (FREContext ctx, void* functionData, uint32_t argc, FREObject argv[] )
{
    NativeDialogControler *nativeDialogController = functionData;
    //Temporary values to hold our actionscript code.
    double perc;
    //Turn our actionscrpt code into native code.
    if(FREGetObjectAsDouble(argv[0], &perc)==FRE_OK)
        [nativeDialogController updateProgress:perc];
    //Create our Strings for our Alert.
    return nil;
}




FREObject showDatePicker(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[] )
{
    NativeDialogControler *nativeDialogController = functionData;
    uint32_t stringLength;
    
    const uint8_t *title = nil;
    const uint8_t *message = nil;
    const uint8_t *style = nil;
    
    NSString *titleString = nil;
    NSString *messageString = nil;
    
    if(FREGetObjectAsUTF8(argv[0], &stringLength, &title)==FRE_OK){
        if(title)
            titleString = [NSString stringWithUTF8String:(char*)title];
    }
    if(FREGetObjectAsUTF8(argv[1], &stringLength, &message)==FRE_OK){
        if(message)
            messageString =[NSString stringWithUTF8String:(char*)message];
    }
    
    FREGetObjectAsUTF8(argv[4], &stringLength, &style);
    
    double date;
    FREGetObjectAsDouble(argv[2], &date);
    
    
    [nativeDialogController showDatePickerWithTitle:titleString andMessage:messageString andDate:date andStyle:style andButtons:argv[3]];
    uint32_t cancelable;
    FREGetObjectAsBool(argv[6], &cancelable);
    [nativeDialogController setCancelable:cancelable];
    return nil;
}


FREObject setDate(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[] )
{
    NativeDialogControler *nativeDialogController = functionData;
    
    double timeStamp = 0;
    FREGetObjectAsDouble(argv[0], &timeStamp);

    [nativeDialogController updateDateWithTimestamp:timeStamp];
    return nil;
}



FREObject setCancelable(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[] ){
    NativeDialogControler *nativeDialogController = functionData;
    
    uint32_t cancelable = 0;
    FREGetObjectAsBool(argv[0], &cancelable);
    
    [nativeDialogController setCancelable:cancelable];
    return nil;
}

#pragma mark - Toast


FREObject showToast(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    if(argc<2 || !argv || !argv[0] || !argv[1])
        return nil;
    
    uint32_t messageLength;
    const uint8_t *message = nil;
    double dur;
    FREGetObjectAsDouble(argv[1], &dur);

    if(FREGetObjectAsUTF8(argv[0], &messageLength, &message)==FRE_OK){
        if(message){
            [WToast showWithText:[NSString stringWithUTF8String:(char*)message]];
        }
    }
    
    return nil;
}



#pragma mark - ANE setup

static const char * LIST_DIALOG_CONTEXT ="ListDialogContext";
static const char * ALERT_CONTEXT ="NativeAlertContext";
static const char * TEXT_INPUT_CONTEXT ="TextInputDialogContext";
static const char * PROGRESS_CONTEXT = "ProgressContext";
static const char * TOAST_CONTEXT = "ToastContext";
static const char * DATE_PICKER_CONTEX = "DatePickerDialogContext";

/* NativeDialogsContextInitializer()
 * The context initializer is called when the runtime creates the extension context instance.
 */
void NativeDialogsContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    #ifdef MYDEBUG
        NSLog(@"Entering NativeDialogsContextInitializer()");
        NSLog(@"context %s",ctxType);
    #endif
    *numFunctionsToTest = 0;

    if(strcmp((const char *)ctxType, LIST_DIALOG_CONTEXT)==0)
    {
        *numFunctionsToTest = 6;
    }
    else if(strcmp((const char *)ctxType, ALERT_CONTEXT)==0)
    {
        *numFunctionsToTest = 6;
    }
    else if(strcmp((const char *)ctxType, TEXT_INPUT_CONTEXT)==0)
    {
        *numFunctionsToTest = 5;
    }
    else if(strcmp((const char *)ctxType, PROGRESS_CONTEXT)==0)
    {
        *numFunctionsToTest = 7;
    }else if(strcmp((const char *)ctxType, TOAST_CONTEXT)==0)
    {
        *numFunctionsToTest = 1;
    }else if(strcmp((const char *)ctxType, DATE_PICKER_CONTEX)==0)
    {
        *numFunctionsToTest = 8;
    }

    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctionsToTest));

    NativeDialogControler* nativeDialogController = [[NativeDialogControler alloc]init];
    nativeDialogController.freContext = ctx;
    
    FRESetContextNativeData( ctx, nativeDialogController );
    
    if(strcmp((const char *)ctxType, LIST_DIALOG_CONTEXT)==0){
        
        func[0].name = (const uint8_t*) "isShowing";
        func[0].functionData = nativeDialogController;
        func[0].function = &isShowing;
        
        func[1].name = (const uint8_t *) "show";
        func[1].functionData = nativeDialogController;
        func[1].function = &showListDialog;
        
        func[2].name = (const uint8_t*) "updateTitle";
        func[2].functionData = nativeDialogController;
        func[2].function = &updateTitle;
        
        func[3].name = (const uint8_t*) "dismiss";
        func[3].functionData = nativeDialogController;
        func[3].function = &dismiss;
        
        func[4].name = (const uint8_t*) "shake";
        func[4].functionData = nativeDialogController;
        func[4].function = &shake;
        
        func[5].name = (const uint8_t*) "updateMessage";
        func[5].functionData = nativeDialogController;
        func[5].function = &updateMessage;
        
    }else if(strcmp((const char *)ctxType, ALERT_CONTEXT)==0){
        
        
        func[0].name = (const uint8_t *) "showAlertWithTitleAndMessage";
        func[0].functionData = nativeDialogController;
        func[0].function = &showAlertWithTitleAndMessage;
        
        func[1].name = (const uint8_t*) "isShowing";
        func[1].functionData = nativeDialogController;
        func[1].function = &isShowing;
        
        func[2].name = (const uint8_t*) "updateMessage";
        func[2].functionData = nativeDialogController;
        func[2].function = &updateMessage;
        
        func[3].name = (const uint8_t*) "updateTitle";
        func[3].functionData = nativeDialogController;
        func[3].function = &updateTitle;
        
        func[4].name = (const uint8_t*) "shake";
        func[4].functionData = nativeDialogController;
        func[4].function = &shake;
        
        func[5].name = (const uint8_t*) "dismiss";
        func[5].functionData = nativeDialogController;
        func[5].function = &dismiss;
    }
    else if(strcmp((const char *)ctxType, TEXT_INPUT_CONTEXT)==0){
        
        func[0].name = (const uint8_t*) "isShowing";
        func[0].functionData = nativeDialogController;
        func[0].function = &isShowing;
        
        func[1].name = (const uint8_t *) "show";
        func[1].functionData = nativeDialogController;
        func[1].function = &showTextInputDialog;
        
        func[2].name = (const uint8_t*) "updateTitle";
        func[2].functionData = nativeDialogController;
        func[2].function = &updateTitle;
        
        func[3].name = (const uint8_t*) "dismiss";
        func[3].functionData = nativeDialogController;
        func[3].function = &dismiss;
        
        func[4].name = (const uint8_t*) "shake";
        func[4].functionData = nativeDialogController;
        func[4].function = &shake;
        
    }
    else if(strcmp((const char *)ctxType, DATE_PICKER_CONTEX)==0){
        
        func[0].name = (const uint8_t*) "isShowing";
        func[0].functionData = nativeDialogController;
        func[0].function = &isShowing;
        
        func[1].name = (const uint8_t *) "show";
        func[1].functionData = nativeDialogController;
        func[1].function = &showDatePicker;
        
        func[2].name = (const uint8_t*) "setDate";
        func[2].functionData = nativeDialogController;
        func[2].function = &setDate;
        
        func[3].name = (const uint8_t*) "dismiss";
        func[3].functionData = nativeDialogController;
        func[3].function = &dismiss;
        
        func[4].name = (const uint8_t*) "updateMessage";
        func[4].functionData = nativeDialogController;
        func[4].function = &updateMessage;
        
        func[5].name = (const uint8_t*) "updateTitle";
        func[5].functionData = nativeDialogController;
        func[5].function = &updateTitle;
        
        func[6].name = (const uint8_t*) "shake";
        func[6].functionData = nativeDialogController;
        func[6].function = &shake;
        
        func[7].name = (const uint8_t*) "setCancelable";
        func[7].functionData = nativeDialogController;
        func[7].function = &setCancelable;
        
    }
    else if(strcmp((const char *)ctxType, PROGRESS_CONTEXT)==0){
        
        func[0].name = (const uint8_t*) "isShowing";
        func[0].functionData = nativeDialogController;
        func[0].function = &isShowing;
        
        func[1].name = (const uint8_t *) "showProgressPopup";
        func[1].functionData = nativeDialogController;
        func[1].function = &showProgressPopup;
        
        func[2].name = (const uint8_t*) "updateProgress";
        func[2].functionData = nativeDialogController;
        func[2].function = &updateProgress;
        
        func[3].name = (const uint8_t*) "dismiss";
        func[3].functionData = nativeDialogController;
        func[3].function = &dismiss;
        
        func[4].name = (const uint8_t*) "updateMessage";
        func[4].functionData = nativeDialogController;
        func[4].function = &updateMessage;
        
        func[5].name = (const uint8_t*) "updateTitle";
        func[5].functionData = nativeDialogController;
        func[5].function = &updateTitle;
        
        func[6].name = (const uint8_t*) "shake";
        func[6].functionData = nativeDialogController;
        func[6].function = &shake;
        
    }else if(strcmp((const char *)ctxType, TOAST_CONTEXT)==0){
        
        func[0].name = (const uint8_t *) "Toast";
        func[0].functionData = NULL;
        func[0].function = &showToast;
    }
    
    *functionsToSet = func;

    #ifdef MYDEBUG
        NSLog(@"Exiting NativeDialogsContextInitializer()");
    #endif
}

void NativeDialogsExtFinalizer(void* extData)
{
   
    return;
}



/* NativeDialogsContextFinalizer()
 * The context finalizer is called when the extension's ActionScript code
 * calls the ExtensionContext instance's dispose() method.
 * If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls ContextFinalizer().
 */
void NativeDialogsContextFinalizer(FREContext ctx) 
{
    NativeDialogControler* nativeDialogController;
    FREGetContextNativeData(ctx, (void**)&nativeDialogController);
    
    [nativeDialogController release];

    return;
}

/* NativeDialogsExtInitializer()
 * The extension initializer is called the first time the ActionScript side of the extension
 * calls ExtensionContext.createExtensionContext() for any context.
 *
 * Please note: this should be same as the <initializer> specified in the extension.xml
 */
void NativeDialogsExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    #ifdef MYDEBUG
        NSLog(@"Entering NativeDialogsExtInitializer()");
    #endif
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &NativeDialogsContextInitializer;
    *ctxFinalizerToSet = &NativeDialogsContextFinalizer;
    
    #ifdef MYDEBUG
        NSLog(@"Exiting NativeDialogsExtInitializer()");
    #endif
}

