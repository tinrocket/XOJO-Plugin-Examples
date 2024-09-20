//
//  TRFoundation-Plugin.m
//  XOJO Tinrocket Common Plugin
//
//  Created by John Balestrieri on 9/15/24.
//
// Refer to XOJO SDK file CompleteClass.cpp in the CompleteClass example

#include <stdio.h>
#include "rb_plugin.h"
#import "TRFoundation-Plugin.h"
#import <Foundation/Foundation.h>



static void NSValueTRC_Initializer( REALobject instance );
static void NSValueTRC_Finalizer( REALobject instance );

REALproperty NSValueTRC_Properties[] = {
//	{ "", "CatName", "String", REALconsoleSafe, REALstandardGetter, REALstandardSetter, FieldOffset( TestClassData, mCatName ) },
//	{ "", "HumanName", "String", REALconsoleSafe, (REALproc)HumanNameGetter, nil },
//	{ "", "MooseName", "String", REALconsoleSafe, (REALproc)MooseNameGetter, (REALproc)MooseNameSetter },
//	{ "", "MooseWeight", "UInt32", REALconsoleSafe, REALstandardGetter, nil, FieldOffset( TestClassData, mMooseWeight ) },
};


REALmethodDefinition NSValueTRC_Methods[] = {
//	{ (REALproc)PlayWithCat, REALnoImplementation, "PlayWithCat( toyName as String )", REALconsoleSafe },
//	{ (REALproc)PlayWithMoose, REALnoImplementation, "PlayWithMoose() as String", REALconsoleSafe },
//	{ (REALproc)ThrowMonkey, REALnoImplementation, "ThrowMonkey( i as Integer )", REALconsoleSafe },
//	{ (REALproc)MyGetString, REALnoImplementation, "GetString() as String", REALconsoleSafe },
};


REALevent NSValueTRC_Events[] = {
};


#pragma mark - Structures

struct NSValueTRC_Data {
	NSValue *Handle;
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
	_countof(NSValueTRC_Properties),
	NSValueTRC_Methods, // Methods
	_countof(NSValueTRC_Methods),

	// Events which the user implements
	TestClassEvents,
	_countof( TestClassEvents ),

	// Event instances, which we are skipping over.  Whenever
	// you want to skip over a field within the structure, you
	// can replace it with nil values, like this:
	nil,
	0,

	// If the class implements any interfaces, then you can
	// list the interface names here (separate multiple names
	// with a comma, just like in REALbasic).
	nil,

	// The next two fields are for bindings, which are a mystery.
	nil,
	0,

	// Back to things which get used qith some frequency: Constants!
	TestClassConstants,
	_countof( TestClassConstants ),

	// The next field is for flags.  You don't have worry about
	// setting these.  There are helper methods for any flags
	// you'd like to set.
	0,

	// The next field defines shared properties.
	TestClassSharedProperties,
	_countof( TestClassSharedProperties ),

	// The final field defined shared methods.
	TestClassSharedMethods,
	_countof( TestClassSharedMethods ),
};


#pragma mark - Implementation

// Initializes the data for our TestClass object
static void NSValueTRC_Initializer( REALobject instance ) {
	// Get the TestClassData from our object
	ClassData(NSValueTRC_Definition, instance, NSValueTRC_Data, me);

	// We're going to initialize the cat's name
//	me->mCatName = REALBuildStringWithEncoding( "Pixel", 5, kREALTextEncodingASCII );
//	me->mMooseName = nil;
//	me->mMooseWeight = 4000;  // 4000 lbs is one big moose!
}


// Finalize the data for our TestClass object
static void NSValueTRC_Finalizer( REALobject instance ) {
	// Get the TestClassData from our object
	ClassData(NSValueTRC_Definition, instance, NSValueTRC_Data, me);

	// Be sure to clean up any object references which
	// we may have
//	REALUnlockString( me->mCatName );
//	REALUnlockString( me->mMooseName );
}


#pragma mark - Public

void RegisterTRFoundation() {
}
