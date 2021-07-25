'From Cuis 5.0 [latest update: #4689] on 25 July 2021 at 4:08:44 pm'!
'Description Small tool to count the number of collaborations (message sends) in a method. It displays the results in the Browser''s annotation pane.

To enable it, evaluate "Preferences enableAnnotationInfo: #collaborationsCount".
To disable it, evaluate "Preferences disableAnnotationInfo: #collaborationsCount".'!
!provides: 'CollaborationCounter' 1 0!
SystemOrganization addCategory: 'CollaborationCounter'!


!classDefinition: #CollaborationCounter category: 'CollaborationCounter'!
ParseNodeVisitor subclass: #CollaborationCounter
	instanceVariableNames: 'methodToAnalyze numberOfCollaborations'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CollaborationCounter'!
!classDefinition: 'CollaborationCounter class' category: 'CollaborationCounter'!
CollaborationCounter class
	instanceVariableNames: ''!

!classDefinition: #CollaborationCounterTest category: 'CollaborationCounter'!
TestCase subclass: #CollaborationCounterTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CollaborationCounter'!
!classDefinition: 'CollaborationCounterTest class' category: 'CollaborationCounter'!
CollaborationCounterTest class
	instanceVariableNames: ''!


!CollaborationCounter methodsFor: 'evaluating' stamp: 'RNG 7/25/2021 14:53:50'!
value

	methodToAnalyze methodNode accept: self.

	^ numberOfCollaborations! !

!CollaborationCounter methodsFor: 'initialization' stamp: 'RNG 7/25/2021 14:53:03'!
initialize

	numberOfCollaborations := 0! !

!CollaborationCounter methodsFor: 'initialization' stamp: 'RNG 7/25/2021 14:49:22'!
initializeFor: aMethodToAnalyze

	methodToAnalyze := aMethodToAnalyze! !

!CollaborationCounter methodsFor: 'visiting' stamp: 'RNG 7/25/2021 15:09:40'!
visitMessageNode: aMessageNode

	super visitMessageNode: aMessageNode.
	self countOneCollaboration! !

!CollaborationCounter methodsFor: 'visiting' stamp: 'RNG 7/25/2021 15:09:49'!
visitMessageNodeInCascade: aMessageNode

	super visitMessageNodeInCascade: aMessageNode.
	self countOneCollaboration! !

!CollaborationCounter methodsFor: 'private' stamp: 'RNG 7/25/2021 15:10:18'!
countOneCollaboration

	numberOfCollaborations := numberOfCollaborations + 1! !

!CollaborationCounter class methodsFor: 'instance creation' stamp: 'RNG 7/25/2021 14:48:56'!
for: aMethodToAnalyze

	^ self new initializeFor: aMethodToAnalyze! !

!CollaborationCounterTest methodsFor: 'tests' stamp: 'RNG 7/25/2021 14:48:13'!
test01ItCountsZeroCollaborationsInAnEmptyMethod

	| counter |
	counter := CollaborationCounter for: self class >> #emptyMethod.

	self assert: 0 equals: counter value! !

!CollaborationCounterTest methodsFor: 'tests' stamp: 'RNG 7/25/2021 14:50:20'!
test02ItCountsOneCollaborationInAMethodWithOnlyOneMessageSend

	| counter |
	counter := CollaborationCounter for: self class >> #methodWithOneMessageSend.

	self assert: 1 equals: counter value! !

!CollaborationCounterTest methodsFor: 'tests' stamp: 'RNG 7/25/2021 15:03:06'!
test03ItCountsTwoCollaborationsThatArePlacedInDifferentsStatements

	| counter |
	counter := CollaborationCounter for: self class >> #methodWithTwoMessageSendsInTwoStatements.

	self assert: 2 equals: counter value! !

!CollaborationCounterTest methodsFor: 'tests' stamp: 'RNG 7/25/2021 15:03:13'!
test04ItCountsTwoCollaborationsThatArePlacedInTheSameMessageSend

	| counter |
	counter := CollaborationCounter for: self class >> #methodWithTwoMessageSendsInOneExpression.

	self assert: 2 equals: counter value! !

!CollaborationCounterTest methodsFor: 'tests' stamp: 'RNG 7/25/2021 15:05:01'!
test05ItCountsThreeCollaborationsFromACascadeMessage

	| counter |
	counter := CollaborationCounter for: self class >> #methodWithThreeMessageSendsInACascade.

	self assert: 3 equals: counter value! !

!CollaborationCounterTest methodsFor: 'tests' stamp: 'RNG 7/25/2021 15:08:14'!
test05ItCountsThreeCollaborationsInsideBlocks

	| counter |
	counter := CollaborationCounter for: self class >> #methodWithThreeMessageSendsInsideBlocks.

	self assert: 3 equals: counter value! !

!CollaborationCounterTest methodsFor: 'test helpers' stamp: 'RNG 7/25/2021 14:46:46'!
emptyMethod! !

!CollaborationCounterTest methodsFor: 'test helpers' stamp: 'RNG 7/25/2021 14:50:40'!
methodWithOneMessageSend

	self emptyMethod! !

!CollaborationCounterTest methodsFor: 'test helpers' stamp: 'RNG 7/25/2021 15:05:37'!
methodWithThreeMessageSendsInACascade

	self
		emptyMethod;
		methodWithOneMessageSend;
		methodWithTwoMessageSendsInOneExpression! !

!CollaborationCounterTest methodsFor: 'test helpers' stamp: 'RNG 7/25/2021 15:08:53'!
methodWithThreeMessageSendsInsideBlocks

	^ [ self emptyMethod + [ self methodWithOneMessageSend ] ]! !

!CollaborationCounterTest methodsFor: 'test helpers' stamp: 'RNG 7/25/2021 15:02:50'!
methodWithTwoMessageSendsInOneExpression

	self emptyMethod + 2! !

!CollaborationCounterTest methodsFor: 'test helpers' stamp: 'RNG 7/25/2021 14:55:21'!
methodWithTwoMessageSendsInTwoStatements

	self methodWithOneMessageSend.
	self emptyMethod.! !

!CodeProvider methodsFor: '*CollaborationCounter' stamp: 'RNG 7/25/2021 16:06:24'!
annotationForSelector: aSelector ofClass: aClass 
	"Provide a line of content for an annotation pane, representing  
	information about the given selector and class"
	| stamp sendersCount implementorsCount aCategory separator aString aList aComment stream requestList |
	aSelector == #Comment
		ifTrue: [^ self annotationForClassCommentFor: aClass].
	aSelector == #Definition
		ifTrue: [^ self annotationForClassDefinitionFor: aClass].
	aSelector == #Hierarchy
		ifTrue: [^ self annotationForHierarchyFor: aClass].
	stream _ WriteStream on: String new.
	requestList _ self annotationRequests.
	separator _ self annotationSeparator.
	requestList
		do: [:aRequest | 
			aRequest == #firstComment
				ifTrue: [
					aComment _ aClass firstCommentAt: aSelector.
					aComment isEmptyOrNil
						ifFalse: [stream position = 0 ifFalse: [stream nextPutAll: separator].
								stream nextPutAll: aComment]].
			aRequest == #masterComment
				ifTrue: [
					aComment _ aClass supermostPrecodeCommentFor: aSelector.
					aComment isEmptyOrNil
						ifFalse: [stream position = 0 ifFalse: [stream nextPutAll: separator].
								stream nextPutAll: aComment]].
			aRequest == #documentation
				ifTrue: [
					aComment _ aClass precodeCommentOrInheritedCommentFor: aSelector.
					aComment isEmptyOrNil
						ifFalse: [stream isEmpty ifFalse: [stream nextPutAll: separator].
								stream nextPutAll: aComment]].
			aRequest == #timeStamp
				ifTrue: [
					stamp _ self timeStamp.
					stream isEmpty ifFalse: [stream nextPutAll: separator].
					stream nextPutAll: (stamp size > 0 ifTrue: [stamp] ifFalse: ['no timestamp'])].
			aRequest == #messageCategory
				ifTrue: [
					aCategory _ aClass organization categoryOfElement: aSelector.
					aCategory
						ifNotNil: ["woud be nil for a method no longer present,  
							e.g. in a recent-submissions browser"
							stream isEmpty ifFalse: [stream nextPutAll: separator].
							stream nextPutAll: aCategory]].
			aRequest == #sendersCount
				ifTrue: [
					sendersCount _ Smalltalk numberOfSendersOf: aSelector.
					sendersCount _ self pluralize: sendersCount singularWord: 'sender' pluralWord: 'senders'.
					stream isEmpty ifFalse: [stream nextPutAll: separator].
					stream nextPutAll: sendersCount].
			aRequest == #implementorsCount
				ifTrue: [
					implementorsCount _ Smalltalk numberOfImplementorsOf: aSelector.
					implementorsCount _ self pluralize: implementorsCount singularWord: 'implementor' pluralWord: 'implementors'.
					stream isEmpty ifFalse: [stream nextPutAll: separator].
					stream nextPutAll: implementorsCount].
			aRequest == #priorVersionsCount
				ifTrue: [
					stream isEmpty ifFalse: [stream nextPutAll: separator].
					self
						addPriorVersionsCountForSelector: aSelector
						ofClass: aClass
						to: stream].
			aRequest == #priorTimeStamp
				ifTrue: [
					stamp _ VersionsBrowser
								timeStampFor: aSelector
								class: aClass
								reverseOrdinal: 2.
					stamp
						ifNotNil: [stream isEmpty ifFalse: [stream nextPutAll: separator].
							stream nextPutAll: 'prior timestamp: ' , stamp]].
			aRequest == #packages
				ifTrue: [
					(aClass compiledMethodAt: aSelector ifAbsent: nil) ifNotNil: [ :cm |
						stream isEmpty ifFalse: [stream nextPutAll: separator].
						(CodePackage packageOfMethod: cm methodReference ifNone: nil)
							ifNil: [ stream nextPutAll: 'in no package' ]
							ifNotNil: [ :codePackage |
								stream nextPutAll: 'in package '; nextPutAll: codePackage packageName ]]].
			aRequest == #changeSets
				ifTrue: [
					stream isEmpty ifFalse: [stream nextPutAll: separator].
					aList _ ChangeSet allChangeSetsWithClass: aClass selector: aSelector.
					aList size > 0
						ifTrue: [aList size = 1
								ifTrue: [stream nextPutAll: 'only in change set']
								ifFalse: [stream nextPutAll: 'in change sets:'].
							aList
								do: [:aChangeSet | stream nextPut: Character space; nextPutAll: aChangeSet name ]
								separatedBy: [ stream nextPut: $, ]]
						ifFalse: [stream nextPutAll: 'in no change set']].
			aRequest == #allChangeSets
				ifTrue: [
					stream isEmpty ifFalse: [stream nextPutAll: separator].
					aList _ ChangeSet allChangeSetsWithClass: aClass selector: aSelector.
					aList size > 0
						ifTrue: [aList size = 1
								ifTrue: [stream nextPutAll: 'only in change set']
								ifFalse: [stream nextPutAll: 'in change sets:'].
							aList
								do: [:aChangeSet | stream nextPut: Character space; nextPutAll: aChangeSet name ]
								separatedBy: [ stream nextPut: $, ]]
						ifFalse: [stream nextPutAll: 'in no change set']].
			aRequest == #allBaseSystemChangeSets
				ifTrue: [
					stream isEmpty ifFalse: [stream nextPutAll: separator].
					aList _ (ChangeSet allChangeSetsWithClass: aClass selector: aSelector) select: [ :it | it isForBaseSystem ].
					aList size > 0
						ifTrue: [
							aList size = 1
								ifTrue: [stream nextPutAll: 'only in base system change set']
								ifFalse: [stream nextPutAll: 'in base system change sets:'].
							aList
								do: [:aChangeSet | stream nextPut: Character space; nextPutAll: aChangeSet name ]
								separatedBy: [ stream nextPut: $, ]]
						ifFalse: [stream nextPutAll: 'in no base system change set']].
			aRequest == #closuresInfo
				ifTrue: [
					aString _ aClass closuresInfoAt: aSelector.
					aString size > 0
						ifTrue: [stream isEmpty ifFalse: [stream nextPutAll: separator].
								stream nextPutAll: aString]].
			aRequest == #collaborationsCount
				ifTrue: [
					self currentCompiledMethod ifNotNil: [ :method |
						|collaborations|
						collaborations := (CollaborationCounter for: method) value.
						collaborations := self pluralize: collaborations singularWord: 'collaboration' pluralWord: 'collaborations'.
						stream isEmpty ifFalse: [stream nextPutAll: separator].
						stream nextPutAll: collaborations ] ]
		].
	^ stream contents! !

!CodeProvider methodsFor: '*CollaborationCounter' stamp: 'RNG 7/25/2021 16:04:19'!
pluralize: aNumber singularWord: singularWord pluralWord: pluralWord

	^ aNumber = 1
		ifTrue: [ '1 ' , singularWord ]
		ifFalse: [ aNumber printString , ' ' , pluralWord ]! !

!Preferences class methodsFor: '*CollaborationCounter' stamp: 'RNG 7/25/2021 15:53:42'!
disableAnnotationInfo: annotationInfo
	"
	Example:
	Preferences disableAnnotationInfo: #collaborationsCount
	"
	| currentAnnotations |
	currentAnnotations _ self parameters at: #MethodAnnotations.
	^ (currentAnnotations includes: annotationInfo) ifTrue: [
		| withAnnotationRemoved |
		withAnnotationRemoved := currentAnnotations asOrderedCollection remove: annotationInfo; yourself.
		self parameters at: #MethodAnnotations put: withAnnotationRemoved asArray ]! !

!Preferences class methodsFor: '*CollaborationCounter' stamp: 'RNG 7/25/2021 15:54:37'!
enableAnnotationInfo: annotationInfo
	"
	Example:
	Preferences enableAnnotationInfo: #collaborationsCount
	"
	| currentAnnotations |
	currentAnnotations _ self parameters at: #MethodAnnotations.
	^ (currentAnnotations includes: annotationInfo) ifFalse: [
		self parameters at: #MethodAnnotations put: currentAnnotations , (Array with: annotationInfo) ]! !
