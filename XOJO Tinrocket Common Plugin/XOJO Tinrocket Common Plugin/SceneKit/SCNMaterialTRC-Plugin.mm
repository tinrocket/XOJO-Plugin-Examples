//
//  TRFoundation-Plugin.m
//  XOJO Tinrocket Common Plugin
//
//  Created by John Balestrieri on 9/15/24.
//
// Refer to XOJO SDK file CompleteClass.cpp in the CompleteClass example

#include <stdio.h>
#include "rb_plugin.h"
#import "SCNMaterialTRC-Plugin.h"
#import <SceneKit/SceneKit.h>


// Lifecycle
static void SCNMaterialTRC_Initializer( REALobject instance );
static void SCNMaterialTRC_Finalizer( REALobject instance );

// Instance
static void setValueForKey(REALobject instance, REALstring key, id value);
static void * getValueForKey(REALobject instance, REALstring key);

// Shared
//static REALobject valueWithPointer(void* pointer);



#pragma mark - Structures

struct SCNMaterialTRC_Data {
	NSValue *handle;
};


REALconstant SCNMaterialTRC_Constants[] = {
};


REALproperty SCNMaterialTRC_Properties[] = {
	{ "", "Handle", "Ptr", REALconsoleSafe, REALstandardGetter, REALstandardSetter, FieldOffset( SCNMaterialTRC_Data, handle ) },
};


REALmethodDefinition SCNMaterialTRC_Methods[] = {
	{ (REALproc)setValueForKey, REALnoImplementation, "Value(key as Variant, Assigns value as Variant) as Ptr", REALconsoleSafe },
	{ (REALproc)getValueForKey, REALnoImplementation, "Value(key as Variant) as Variant", REALconsoleSafe },
};


REALevent SCNMaterialTRC_Events[] = {
};


// Class (shared) methods
REALmethodDefinition SCNMaterialTRC_SharedMethods[] = {
};


// Class (shared) properties
REALproperty SCNMaterialTRC_SharedProperties[] = {
};


REALclassDefinition SCNMaterialTRC_Definition = {
	kCurrentREALControlVersion, // This field specifies the current Plugin SDK version.  You should always set the value to kCurrentREALControlVersion.
	"SCNMaterialTRC", // This field specifies the name of the class which will be exposed to the user
	nil, // If your class has a Super, you can set the super here.
	sizeof(SCNMaterialTRC_Data), // This field specifies the size of the class instance storage
	0, // This field is reserved and should always be 0
	(REALproc)SCNMaterialTRC_Initializer, // If your class needs to initialize any of its instance data, then you can specify an initializer method.
	(REALproc)SCNMaterialTRC_Finalizer, 	// If your class needs to finalize any of its instance data, the you can specify a finalizer method.
	SCNMaterialTRC_Properties, // Properties
	_countof(SCNMaterialTRC_Properties), // Count
	SCNMaterialTRC_Methods, // Methods
	_countof(SCNMaterialTRC_Methods), // Count
	SCNMaterialTRC_Events, // Events which the user implements
	_countof(SCNMaterialTRC_Events), // Count
	nil, // Event instances, which we are skipping over
	0, // Count
	nil, // Class instances
	nil, // The next two fields are for bindings, which are a mystery.
	0,
	SCNMaterialTRC_Constants, // Back to things which get used with some frequency: Constants!
	_countof(SCNMaterialTRC_Constants),
	0, // The next field is for flags.  You don't have worry about setting these.  There are helper methods for any flags you'd like to set.
	SCNMaterialTRC_SharedProperties, // The next field defines shared properties.
	_countof(SCNMaterialTRC_SharedProperties), // Count
	SCNMaterialTRC_SharedMethods, // The final field defined shared methods.
	_countof(SCNMaterialTRC_SharedMethods), // Count
};



#pragma mark - Implementation
#pragma mark Shared

REALobject valueWithPointer(void *pointer) {
	// Create a new instance of the SCNMaterialTRC class
	REALobject newInstance = REALnewInstanceOfClass(&SCNMaterialTRC_Definition);

	// Get the instance data using the ClassData macro
	ClassData(SCNMaterialTRC_Definition, newInstance, SCNMaterialTRC_Data, me);

	NSValue *value = [NSValue valueWithPointer:pointer];
	me->handle = value;
	
	return newInstance;
}



#pragma mark Lifecycle

static void SCNMaterialTRC_Initializer( REALobject instance ) {
	ClassData(SCNMaterialTRC_Definition, instance, SCNMaterialTRC_Data, me);

	me->handle = [NSValue new];
}


static void SCNMaterialTRC_Finalizer( REALobject instance ) {
	ClassData(SCNMaterialTRC_Definition, instance, SCNMaterialTRC_Data, me);

	me->handle = nil;
}


#pragma mark Instance

static void setValueForKey(REALobject instance, REALstring key, id value) {
	ClassData(SCNMaterialTRC_Definition, instance, SCNMaterialTRC_Data, me);
	SCNMaterial *material = (SCNMaterial *)me->handle;

	REALstringData stringData;

#if TARGET_CARBON
	NSLog(@"Hello");
#endif
	
//	NSString *keyNS = (NSString *)REALCopyStringCFString(key);
	
//	[material setValue:value forKey:key];
}


static void * getValueForKey(REALobject instance, REALstring key) {
	ClassData(SCNMaterialTRC_Definition, instance, SCNMaterialTRC_Data, me);
	SCNMaterial *material = (SCNMaterial *)me->handle;

//	return [material valueForKey:key];
	return nil;
}


#pragma mark - Public

void Register_SCNMaterialTRC() {
	SetClassConsoleSafe( &SCNMaterialTRC_Definition );
	
	REALRegisterClass( &SCNMaterialTRC_Definition ); // Register our class
}
