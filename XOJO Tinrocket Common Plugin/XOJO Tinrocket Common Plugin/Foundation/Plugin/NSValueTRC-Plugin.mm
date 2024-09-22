//
//  TRFoundation-Plugin.m
//  XOJO Tinrocket Common Plugin
//
//  Created by John Balestrieri on 9/15/24.
//
// Refer to XOJO SDK file CompleteClass.cpp in the CompleteClass example

#include <stdio.h>
#include "rb_plugin.h"
#import "NSValueTRC-Plugin.h"
#import <Foundation/Foundation.h>



// Instance
static void NSValueTRC_Initializer( REALobject instance );
static void NSValueTRC_Finalizer( REALobject instance );
static void * pointerValue(REALobject instance);

// Shared
static REALobject valueWithPointer(void* pointer);


#pragma mark - Structures

struct NSValueTRC_Data {
	NSValue *handle;
};


REALconstant NSValueTRC_Constants[] = {
};


REALproperty NSValueTRC_Properties[] = {
	{ "", "Handle", "Ptr", REALconsoleSafe, REALstandardGetter, REALstandardSetter, FieldOffset( NSValueTRC_Data, handle ) },
};


REALmethodDefinition NSValueTRC_Methods[] = {
	{ (REALproc)pointerValue, REALnoImplementation, "pointerValue() as Ptr", REALconsoleSafe },
};


REALevent NSValueTRC_Events[] = {
};


// Class (shared) methods
REALmethodDefinition NSValueTRC_SharedMethods[] = {
	{ (REALproc)valueWithPointer, REALnoImplementation, "valueWithPointer(value as Ptr) as NSValueTRC", REALconsoleSafe },
};


// Class (shared) properties
REALproperty NSValueTRC_SharedProperties[] = {
};


REALclassDefinition NSValueTRC_Definition = {
	kCurrentREALControlVersion, // This field specifies the current Plugin SDK version.  You should always set the value to kCurrentREALControlVersion.
	"NSValueTRC", // This field specifies the name of the class which will be exposed to the user
	nil, // If your class has a Super, you can set the super here.
	sizeof(NSValueTRC_Data), // This field specifies the size of the class instance storage
	0, // This field is reserved and should always be 0
	(REALproc)NSValueTRC_Initializer, // If your class needs to initialize any of its instance data, then you can specify an initializer method.
	(REALproc)NSValueTRC_Finalizer, 	// If your class needs to finalize any of its instance data, the you can specify a finalizer method.
	NSValueTRC_Properties, // Properties
	_countof(NSValueTRC_Properties), // Count
	NSValueTRC_Methods, // Methods
	_countof(NSValueTRC_Methods), // Count
	NSValueTRC_Events, // Events which the user implements
	_countof(NSValueTRC_Events), // Count
	nil, // Event instances, which we are skipping over
	0, // Count
	nil, // Class instances
	nil, // The next two fields are for bindings, which are a mystery.
	0,
	NSValueTRC_Constants, // Back to things which get used with some frequency: Constants!
	_countof(NSValueTRC_Constants),
	0, // The next field is for flags.  You don't have worry about setting these.  There are helper methods for any flags you'd like to set.
	NSValueTRC_SharedProperties, // The next field defines shared properties.
	_countof(NSValueTRC_SharedProperties), // Count
	NSValueTRC_SharedMethods, // The final field defined shared methods.
	_countof(NSValueTRC_SharedMethods), // Count
};



#pragma mark - Implementation
#pragma mark Shared

REALobject valueWithPointer(void *pointer) {
	// Create a new instance of your NSValueTRC class
	REALobject newInstance = REALnewInstanceOfClass(&NSValueTRC_Definition);

	// Create an NSValue object to wrap the pointer
	NSValue *value = [NSValue valueWithPointer:pointer];

	// Get the instance data using the ClassData macro
	ClassData(NSValueTRC_Definition, newInstance, NSValueTRC_Data, me);

	// Set the NSValue object to the handle field
	me->handle = value;
	
	NSLog(@"Original pointer: %p", pointer);
	NSLog(@"NSValue stored pointer: %p", [value pointerValue]);

	// Return the new instance
	return newInstance;
}



#pragma mark Instance

// Initializes the data for our TestClass object
static void NSValueTRC_Initializer( REALobject instance ) {
	// Get the TestClassData from our object
	ClassData(NSValueTRC_Definition, instance, NSValueTRC_Data, me);

	me->handle = [NSValue new];
}


// Finalize the data for our TestClass object
static void NSValueTRC_Finalizer( REALobject instance ) {
	// Get the TestClassData from our object
	ClassData(NSValueTRC_Definition, instance, NSValueTRC_Data, me);

	me->handle = nil;
}


static void * pointerValue(REALobject instance) {
	// Get the instance data using the ClassData macro
	ClassData(NSValueTRC_Definition, instance, NSValueTRC_Data, me);

	// Retrieve the NSValue object stored in 'handle'
	NSValue *value = (NSValue *)me->handle;

	// Log the pointer retrieved from NSValue
	NSLog(@"NSValue pointer retrieved: %p", [value pointerValue]);

	// Return the pointer value stored in NSValue
	return [value pointerValue];
}


#pragma mark - Public

void Register_NSValueTRC() {
	SetClassConsoleSafe( &NSValueTRC_Definition );
	
	REALRegisterClass( &NSValueTRC_Definition ); // Register our class
}
