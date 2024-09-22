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


REALconstant NSValueTRC_Constants[] = {
//	{ "kNumberOfBones as UInt32 = 206" },
//	{ "kMagicColor as Color = &cFF00FF" },
//	{ "kDefaultCatName as String = \"Pixel\"" },
//	{ "kPi as Double = 3.14159265" },
};


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
	NSValueTRC_Properties, // The next field defines shared properties.
	_countof(NSValueTRC_Properties), // Count
	NSValueTRC_Methods, // The final field defined shared methods.
	_countof(NSValueTRC_Methods), // Count
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
//	SetClassConsoleSafe( &NSValueTRC_Definition );
	
	REALRegisterClass( &NSValueTRC_Definition ); // Register our class
}
