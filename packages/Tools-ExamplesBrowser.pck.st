'From Cuis 5.0 [latest update: #4532] on 21 December 2021 at 3:37:39 am'!
'Description Small tool to define and browse examples for common methods'!
!provides: 'Tools-ExamplesBrowser' 1 0!
SystemOrganization addCategory: 'Tools-ExamplesBrowser'!


!classDefinition: #MethodExamples category: 'Tools-ExamplesBrowser'!
Object subclass: #MethodExamples
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Tools-ExamplesBrowser'!
!classDefinition: 'MethodExamples class' category: 'Tools-ExamplesBrowser'!
MethodExamples class
	instanceVariableNames: ''!

!classDefinition: #CollectionExamples category: 'Tools-ExamplesBrowser'!
MethodExamples subclass: #CollectionExamples
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Tools-ExamplesBrowser'!
!classDefinition: 'CollectionExamples class' category: 'Tools-ExamplesBrowser'!
CollectionExamples class
	instanceVariableNames: ''!


!MethodExamples commentStamp: '<historical>' prior: 0!
Base class for defining examples.

Examples are methods that contain the pragma <example: #methodToDescribe> and can be browsed using the 'examples' button in all code browsers.

It's recommended to add subclasses for each class to document.!

!CollectionExamples methodsFor: 'examples - any satisfy' stamp: 'RNG 12/21/2021 03:27:13'!
anySatisfy_example_one

	<example: #anySatisfy:>
	
	#(1 2 3 4) anySatisfy: [ :number | number < 2 ]! !

!CollectionExamples methodsFor: 'examples - any satisfy' stamp: 'RNG 12/21/2021 03:35:46'!
anySatisfy_example_three

	<example: #anySatisfy:>
	
	{} anySatisfy: [ :object | object isNil ]! !

!CollectionExamples methodsFor: 'examples - any satisfy' stamp: 'RNG 12/21/2021 03:10:59'!
anySatisfy_example_two

	<example: #anySatisfy:>
	
	(Set with: 'foo' with: 'bar') anySatisfy: [ :text | text beginsWith: 'f' ]! !

!Pragma methodsFor: '*Tools-ExamplesBrowser' stamp: 'RNG 12/21/2021 03:15:29'!
argumentAt: aPosition is: aValue

	^ (self argumentAt: aPosition) = aValue! !

!Pragma methodsFor: '*Tools-ExamplesBrowser' stamp: 'RNG 12/21/2021 03:00:23'!
methodReference

	^ method asMethodReference! !

!Pragma class methodsFor: '*Tools-ExamplesBrowser' stamp: 'RNG 12/21/2021 03:17:11'!
allNamed: aSymbol inHierarchyOf: aBaseClass matching: aCondition
	"Answer a collection of all pragmas found in methods of aBaseClass (and all its subclasses), whose keyword is aSymbol, and matches the given condition block."

	^ Array streamContents: [ :stream |
		aBaseClass withAllSubclassesDo: [ :class |
			self withPragmasIn: class do: [ :pragma |
				(pragma keyword = aSymbol and: [ aCondition value: pragma ])
					ifTrue: [ stream nextPut: pragma ] ] ] ]! !

!CodeWindow methodsFor: '*Tools-ExamplesBrowser' stamp: 'RNG 12/21/2021 03:20:20'!
browseExamples

	| referencesToBrowse |
	referencesToBrowse _ self examplesForSelectedMethod collect: [ :example | example methodReference ].
	
	Smalltalk
		browseMessageList: referencesToBrowse
		name: 'Examples of ', model selectedMessageName! !

!CodeWindow methodsFor: '*Tools-ExamplesBrowser' stamp: 'RNG 12/21/2021 03:20:07'!
examplesForSelectedMethod

	^ Pragma
		allNamed: #example:
		inHierarchyOf: MethodExamples
		matching: [ :example | example argumentAt: 1 is: model selectedMessageName ]! !

!CodeWindow methodsFor: '*Tools-ExamplesBrowser' stamp: 'RNG 12/21/2021 03:23:22'!
optionalButtonTuples
	"Answer a tuple buttons, in the format:
			button label
			selector to send
			help message"

	| aList |

	aList _ #(
	(10	'browse'			browseMethodFull				'view this method in a browser')
	(11	'senders' 			browseSendersOfMessages	'browse senders of...')
	(16	'implementors'		browseMessages				'browse implementors of...')
	(12	'versions'			browseVersions					'browse versions')), 

	(Preferences decorateBrowserButtons
		ifTrue:
			[{#(13	'inheritance'		methodHierarchy 	'browse method inheritance
green: sends to super
tan: has override(s)
mauve: both of the above
pink: is an override but doesn''t call super
pinkish tan: has override(s), also is an override but doesn''t call super' )}]
		ifFalse:
			[{#(13	'inheritance'		methodHierarchy	'browse method inheritance')}]),

	#(
	(12	'hierarchy'			browseHierarchy						'browse class hierarchy')
	(10	'inst vars'			browseInstVarRefs						'inst var refs...')
	(11	'class vars'			browseClassVarRefs						'class var refs...')
	(11  	'examples'  			browseExamples  						'browse examples of the current method')
	(10	'show...'			offerWhatToShowMenu						'menu of what to show in lower pane')).

	^ aList! !
