//
//  TRMetalImageView-Plugin-macOS.m
//  TRMetalImageView-XOJO-Plugin-macOS
//
//  Created by John Balestrieri on 9/15/24.
//

#import "TRMetalImageView-Plugin-macOS.h"
#import "TRMetalImageView.h"

static void TRMetalImageView_initializer(REALcontrolInstance);
static void TRMetalImageView_finalizer(REALcontrolInstance);

static void * TRMetalImageView_handle_getter(REALcontrolInstance);
static void * TRMetalImageView_image_getter(REALcontrolInstance, RBInteger param);
static void TRMetalImageView_image_setter(REALcontrolInstance, RBInteger param, void *);
static NSUInteger TRMetalImageView_contentMode_getter(REALcontrolInstance);
static void TRMetalImageView_contentMode_setter(REALcontrolInstance, void *, NSUInteger);
static BOOL TRMetalImageView_rasterizeBeforeDrawing_getter(REALcontrolInstance);
static void TRMetalImageView_rasterizeBeforeDrawing_setter(REALcontrolInstance, void *, BOOL);
static BOOL TRMetalImageView_clearBeforeDrawing_getter(REALcontrolInstance);
static void TRMetalImageView_clearBeforeDrawing_setter(REALcontrolInstance, void *, BOOL);
static void TRMetalImageView_configureForFasterDrawing(REALcontrolInstance);
static void TRMetalImageView_configureForVideo(REALcontrolInstance);

#pragma mark - Data Structures

struct TRMetalImageView_Data {
	TRMetalImageView *view;
};


static REALproperty TRMetalImageView_Properties[] = {
	{"", "CIImage", "Ptr", 0, (REALproc)TRMetalImageView_image_getter, (REALproc)TRMetalImageView_image_setter},
	{"", "ContentMode", "UInteger", 0, (REALproc)TRMetalImageView_contentMode_getter, (REALproc)TRMetalImageView_contentMode_setter},
	{"", "RasterizeBeforeDrawing", "Boolean", 0, (REALproc)TRMetalImageView_rasterizeBeforeDrawing_getter, (REALproc)TRMetalImageView_rasterizeBeforeDrawing_setter},
	{"", "ClearBeforeDrawing", "Boolean", 0, (REALproc)TRMetalImageView_clearBeforeDrawing_getter, (REALproc)TRMetalImageView_clearBeforeDrawing_setter},
};


static REALmethodDefinition TRMetalImageView_Methods[] = {
	{ (REALproc)TRMetalImageView_configureForFasterDrawing, REALnoImplementation, "ConfigureForFasterDrawing()" },
	{ (REALproc)TRMetalImageView_configureForVideo, REALnoImplementation, "ConfigureForVideo()" },
};


static REALcontrolBehaviour TRMetalImageView_Behaviour = {
	TRMetalImageView_initializer,
	TRMetalImageView_finalizer,
	NULL, // redrawFunction
	NULL, // clickFunction
	NULL, // mouseDragFunction
	NULL, // mouseUpFunction
	NULL, // gainedFocusFunction
	NULL, // lostFocusFunction
	NULL, // keyDownFunction
	NULL, // openFunction
	NULL, // closeFunction
	NULL, // backgroundIdleFunction
	NULL, // drawOffscreenFunction
	NULL, // setSpecialBackground
	NULL, // constantChanging
	NULL, // droppedNewInstance
	NULL, // mouseEnterFunction
	NULL, // mouseExitFunction
	NULL, // mouseMoveFunction
	NULL, // stateChangedFunction
	NULL, // actionEventFunction
	TRMetalImageView_handle_getter, // RatingControlHandle_getter
};


static REALcontrol TRMetalImageView_Struct = {
	kCurrentREALControlVersion,
	"DesktopTRMetalImageView",
	sizeof(TRMetalImageView_Data),
	REALdesktopControl, // flags
	0, 0, // toolbar icons
	200, 200, // width/height
	TRMetalImageView_Properties, _countof(TRMetalImageView_Properties),
	TRMetalImageView_Methods, _countof(TRMetalImageView_Methods),
	NULL, 0,
	&TRMetalImageView_Behaviour
};


#pragma mark - Properties

static void * TRMetalImageView_image_getter( REALcontrolInstance control, RBInteger ) {
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	return (__bridge void *)[data->view image];
}


static void TRMetalImageView_image_setter( REALcontrolInstance control, RBInteger, void * val ) {
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	[data->view setImage:(__bridge CIImage *)val];
}


static NSUInteger TRMetalImageView_contentMode_getter( REALcontrolInstance control ) {
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	return (kTRMetalImageViewContentMode)[data->view contentMode];
}


static void TRMetalImageView_contentMode_setter( REALcontrolInstance control, void *, NSUInteger val ) {
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	[data->view setContentMode:(kTRMetalImageViewContentMode)val];
}


static BOOL TRMetalImageView_rasterizeBeforeDrawing_getter( REALcontrolInstance control ) {
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	return [data->view rasterizeBeforeDrawing];
}


static void TRMetalImageView_rasterizeBeforeDrawing_setter( REALcontrolInstance control, void *, BOOL val ) {
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	[data->view setRasterizeBeforeDrawing:val];
}


static BOOL TRMetalImageView_clearBeforeDrawing_getter( REALcontrolInstance control ) {
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	return [data->view clearBeforeDrawing];
}


static void TRMetalImageView_clearBeforeDrawing_setter( REALcontrolInstance control, void *, BOOL val ) {
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	[data->view setClearBeforeDrawing:val];
}


#pragma mark - Methods

static void TRMetalImageView_configureForFasterDrawing(REALcontrolInstance control) {
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	[data->view configureForFasterDrawing];
}


static void TRMetalImageView_configureForVideo(REALcontrolInstance control) {
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	[data->view configureForVideo];
}


#pragma mark - Lifecycle

static void TRMetalImageView_initializer( REALcontrolInstance control ) {
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	// No need to calculate what frame to intialize the view with - the RB
	// framework will move it around as needed.
#if TARGET_OS_IPHONE
	TRMetalImageView *view = [[TRMetalImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
#else
	TRMetalImageView *view = [[TRMetalImageView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
#endif
	
	[view setTransparencyGrid:FALSE];
	
	data->view = view;
}


static void TRMetalImageView_finalizer( REALcontrolInstance control ) {
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	data->view = nil;
}


static void * TRMetalImageView_handle_getter( REALcontrolInstance control ) {
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	return (__bridge void *)data->view;
}


#pragma mark - Public

// Registration function
void RegisterTRMetalImageView() {
	REALRegisterControl(&TRMetalImageView_Struct);
}

