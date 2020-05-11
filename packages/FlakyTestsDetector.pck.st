'From Cuis 5.0 [latest update: #4133] on 10 May 2020 at 8:53:34 pm'!
'Description A simple class that helps to run a test several times and see if it is a flaky test or not.'!
!provides: 'FlakyTestsDetector' 1 1!
SystemOrganization addCategory: #FlakyTestsDetector!


!classDefinition: #FlakyTestReportWindow category: #FlakyTestsDetector!
SystemWindow subclass: #FlakyTestReportWindow
	instanceVariableNames: 'selection resultsSummary testDescription'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FlakyTestsDetector'!
!classDefinition: 'FlakyTestReportWindow class' category: #FlakyTestsDetector!
FlakyTestReportWindow class
	instanceVariableNames: ''!

!classDefinition: #FlakyTestAnalysis category: #FlakyTestsDetector!
Object subclass: #FlakyTestAnalysis
	instanceVariableNames: 'testMethod currentSampleNumber results sampleSize'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FlakyTestsDetector'!
!classDefinition: 'FlakyTestAnalysis class' category: #FlakyTestsDetector!
FlakyTestAnalysis class
	instanceVariableNames: ''!

!classDefinition: #FlakyTestAnalysisResult category: #FlakyTestsDetector!
Object subclass: #FlakyTestAnalysisResult
	instanceVariableNames: 'testExecutions testMethod'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FlakyTestsDetector'!
!classDefinition: 'FlakyTestAnalysisResult class' category: #FlakyTestsDetector!
FlakyTestAnalysisResult class
	instanceVariableNames: ''!


!FlakyTestReportWindow commentStamp: '<historical>' prior: 0!
I display the results of a FlakyTestAnalysis, in a simple view indicating the percentage of failures and a detail on how it was was each run!

!FlakyTestAnalysis commentStamp: '<historical>' prior: 0!
I run several times a test method in order to investigate if it is flaky or not. I report a FlakyTestAnalysisResult when I receive #value.

Usage:

methodToAnalyze _ ExtractMethodTest >> #test30ItIsPossibleToExtractAQuotedExpression.
flakyTestAnalysis _ FlakyTestAnalysis for: methodToAnalyze timesToRun: 100.
result _ flakyTestAnalysis value.
result isFlaky. "true/false"
result flakinessPercentage. "0..1"
result successCount. "0..100"
result failuresCount. "0..100"
result totalCount. "100"!

!FlakyTestAnalysisResult commentStamp: '<historical>' prior: 0!
I hold the results of a flaky test analysis performed by the FlakyTestAnalysis class. My public protocol is on "accessing" and "testing" categories.!

!FlakyTestReportWindow methodsFor: 'selection' stamp: 'RNG 5/10/2020 20:10:03'!
selectFirstResult

	^ selection := self resultSummaryAt: 1 with: self testResults first! !

!FlakyTestReportWindow methodsFor: 'selection' stamp: 'RNG 5/10/2020 16:42:56'!
selection

	^ selection
		ifNotNil: [ selection ]
		ifNil: [ self selectFirstResult ]! !

!FlakyTestReportWindow methodsFor: 'selection' stamp: 'RNG 5/10/2020 20:10:03'!
selectionIndex

	^ self testResults indexOf: self selection! !

!FlakyTestReportWindow methodsFor: 'selection' stamp: 'RNG 5/10/2020 20:10:03'!
selectionIndex: aSmallInteger 

	selection := self testResults at: aSmallInteger! !

!FlakyTestReportWindow methodsFor: 'private' stamp: 'RNG 5/10/2020 16:55:25'!
resultSummaryAt: index with: result

	^ '#' , (self withLeadingZeros: index) , ' - ' ,  result printString! !

!FlakyTestReportWindow methodsFor: 'private' stamp: 'RNG 5/10/2020 20:12:21'!
roundedFlakinessPercentage

	^ (model flakinessPercentage * 100) asFloat roundTo: 0.01! !

!FlakyTestReportWindow methodsFor: 'private' stamp: 'RNG 5/10/2020 20:10:03'!
testResults

	^ model testResults
		withIndexCollect: [ :result :index | self resultSummaryAt: index with: result ]! !

!FlakyTestReportWindow methodsFor: 'private' stamp: 'RNG 5/10/2020 16:55:25'!
withLeadingZeros: index

	^ index printString padded: #left to: (model testResults size numberOfDigitsInBase: 10) with: $0! !

!FlakyTestReportWindow methodsFor: 'GUI building' stamp: 'RNG 5/10/2020 17:07:53'!
buildFailureCountLabel

	^ StringMorph contents: model failuresCount printString , ' failures'! !

!FlakyTestReportWindow methodsFor: 'GUI building' stamp: 'RNG 5/10/2020 20:13:45'!
buildFlakinessPercentageLabel

	^ StringMorph contents: self roundedFlakinessPercentage printString , '% failures'! !

!FlakyTestReportWindow methodsFor: 'GUI building' stamp: 'RNG 5/10/2020 20:50:23'!
buildMorphicWindow
	
	self layoutMorph
		doAdoptWidgetsColor;
		addAdjusterAndMorph: self buildTestDescription proportionalHeight: 0.05;
		addAdjusterAndMorph: self buildResultsSummary proportionalHeight: 0.05;
		addAdjusterAndMorph: self buildTestExecutionsList proportionalHeight: 0.9.

	self setLabel: 'Flaky test report'! !

!FlakyTestReportWindow methodsFor: 'GUI building' stamp: 'RNG 5/10/2020 20:24:24'!
buildResultsSummary

	^ resultsSummary := LayoutMorph newRow
		separation: 10;
		doAdoptWidgetsColor;
		addMorph: self buildFlakinessPercentageLabel proportionalWidth: 0.25;
		addMorph: self buildTotalCountLabel proportionalWidth: 0.25;
		addMorph: self buildSuccessCountLabel proportionalWidth: 0.25;
		addMorph: self buildFailureCountLabel proportionalWidth: 0.25! !

!FlakyTestReportWindow methodsFor: 'GUI building' stamp: 'RNG 5/10/2020 17:07:42'!
buildSuccessCountLabel

	^ StringMorph contents: model successCount printString , ' successful'! !

!FlakyTestReportWindow methodsFor: 'GUI building' stamp: 'RNG 5/10/2020 19:41:18'!
buildTestClassLabel

	^ StringMorph contents: model testMethod methodClass printString! !

!FlakyTestReportWindow methodsFor: 'GUI building' stamp: 'RNG 5/10/2020 20:50:43'!
buildTestDescription

	^ testDescription := LayoutMorph newRow
		separation: 10;
		doAdoptWidgetsColor;
		addMorph: self buildTestClassLabel proportionalWidth: 0.5;
		addMorph: self buildTestMethodLabel proportionalWidth: 0.5! !

!FlakyTestReportWindow methodsFor: 'GUI building' stamp: 'RNG 5/10/2020 19:48:04'!
buildTestExecutionsList

	^ PluggableListMorph
		model: self
		listGetter: #testResults
		indexGetter: #selectionIndex
		indexSetter: #selectionIndex:! !

!FlakyTestReportWindow methodsFor: 'GUI building' stamp: 'RNG 5/10/2020 20:20:04'!
buildTestMethodLabel

	^ StringMorph contents: model testMethod selector printString! !

!FlakyTestReportWindow methodsFor: 'GUI building' stamp: 'RNG 5/10/2020 19:42:04'!
buildTotalCountLabel

	^ StringMorph contents: model totalCount printString , ' runs'! !

!FlakyTestReportWindow methodsFor: 'GUI building' stamp: 'RNG 5/10/2020 20:50:55'!
initialExtent

	^ 600@400! !

!FlakyTestReportWindow methodsFor: 'GUI building' stamp: 'RNG 5/10/2020 20:27:38'!
openInWorld

	super openInWorld.
	resultsSummary color: self resultsSummaryColor! !

!FlakyTestReportWindow methodsFor: 'GUI building' stamp: 'RNG 5/10/2020 20:28:12'!
resultsSummaryColor

	^ model isFlaky
		ifTrue: [ `Color lightRed` ]
		ifFalse: [ `Color lightGreen` ]! !

!FlakyTestReportWindow class methodsFor: 'as yet unclassified' stamp: 'RNG 5/10/2020 20:34:49'!
messageListMenuOptions

	^ `{
		{
			#itemGroup 		-> 60.
			#itemOrder 		-> 40.
			#label 			-> 'Analyze test flakiness...'.
			#selector 		-> #analyzeTestFlakiness.
			#icon 			-> #findIcon
		} asDictionary.
	}`! !

!FlakyTestAnalysis methodsFor: 'evaluating' stamp: 'RNG 3/7/2020 19:49:27'!
value

	self sampleSize timesRepeat: [
		self runCurrentSample.
		self advanceToNextSample.
	].
	^ self reportResults! !

!FlakyTestAnalysis methodsFor: 'initialization' stamp: 'RNG 3/7/2020 19:49:51'!
initializeFor: aTestMethod timesToRun: aNumber

	testMethod _ aTestMethod.
	sampleSize _ aNumber.
	self resetResults.! !

!FlakyTestAnalysis methodsFor: 'private - evaluating' stamp: 'RNG 5/10/2020 16:38:15'!
advanceToNextSample

	currentSampleNumber := currentSampleNumber + 1! !

!FlakyTestAnalysis methodsFor: 'private - evaluating' stamp: 'RNG 5/10/2020 16:38:27'!
createTestSuiteForCurrentSample

	^ TestSuite
		forTestMethod: testMethod
		named: self suiteTitleForCurrentSample! !

!FlakyTestAnalysis methodsFor: 'private - evaluating' stamp: 'RNG 5/10/2020 16:38:36'!
reportResults

	^ FlakyTestAnalysisResult
		of: testMethod
		withAll: results! !

!FlakyTestAnalysis methodsFor: 'private - evaluating' stamp: 'RNG 5/10/2020 16:38:43'!
resetResults

	currentSampleNumber := 1.
	results := Dictionary new! !

!FlakyTestAnalysis methodsFor: 'private - evaluating' stamp: 'RNG 5/10/2020 16:38:10'!
runCurrentSample

	| testSuite testResult |
	testSuite := self createTestSuiteForCurrentSample.
	testResult := testSuite run.
	results at: testSuite put: testResult.! !

!FlakyTestAnalysis methodsFor: 'private - evaluating' stamp: 'RNG 3/7/2020 19:45:39'!
sampleSize

	^ sampleSize! !

!FlakyTestAnalysis methodsFor: 'private - evaluating' stamp: 'RNG 3/7/2020 19:50:43'!
suiteTitleForCurrentSample

	^ 'Run #' , currentSampleNumber printString , ' of ' , testMethod printString! !

!FlakyTestAnalysis class methodsFor: 'instance creation' stamp: 'RNG 3/7/2020 20:10:05'!
for: aTestMethod

	^ self for: aTestMethod timesToRun: self defaultSampleSize! !

!FlakyTestAnalysis class methodsFor: 'instance creation' stamp: 'RNG 3/7/2020 19:44:45'!
for: aTestMethod timesToRun: aNumber

	^ self new initializeFor: aTestMethod timesToRun: aNumber! !

!FlakyTestAnalysis class methodsFor: 'default parameters' stamp: 'RNG 3/7/2020 19:45:06'!
defaultSampleSize

	^ 100! !

!FlakyTestAnalysisResult methodsFor: 'initialization' stamp: 'RNG 5/10/2020 16:28:18'!
initialize: aTestMethod withAll: collectionOfTestExecutions

	testMethod := aTestMethod.
	testExecutions := collectionOfTestExecutions! !

!FlakyTestAnalysisResult methodsFor: 'private' stamp: 'RNG 3/7/2020 19:58:44'!
testResults

	^ testExecutions values! !

!FlakyTestAnalysisResult methodsFor: 'accessing' stamp: 'RNG 3/7/2020 19:58:54'!
failuresCount

	^ self testResults count: [ :testResult | testResult hasPassed not ]! !

!FlakyTestAnalysisResult methodsFor: 'accessing' stamp: 'RNG 3/7/2020 19:57:53'!
flakinessPercentage

	^ self failuresCount / self totalCount! !

!FlakyTestAnalysisResult methodsFor: 'accessing' stamp: 'RNG 3/7/2020 19:58:44'!
successCount

	^ self testResults count: [ :testResult | testResult hasPassed ]! !

!FlakyTestAnalysisResult methodsFor: 'accessing' stamp: 'RNG 5/10/2020 16:30:16'!
testMethod

	^ testMethod! !

!FlakyTestAnalysisResult methodsFor: 'accessing' stamp: 'RNG 3/7/2020 19:57:53'!
totalCount

	^ testExecutions size! !

!FlakyTestAnalysisResult methodsFor: 'testing' stamp: 'RNG 3/6/2020 19:45:55'!
isFlaky

	^ self flakinessPercentage > 0! !

!FlakyTestAnalysisResult class methodsFor: 'instance creation' stamp: 'RNG 5/10/2020 16:27:57'!
of: aTestMethod withAll: testExecutions

	^ self new initialize: aTestMethod withAll: testExecutions! !

!BrowserWindow methodsFor: '*FlakyTestsDetector' stamp: 'RNG 5/10/2020 20:41:32'!
analyzeTestFlakiness

	(model currentCompiledMethod notNil and: [ model currentCompiledMethod isTestMethod ])
		ifTrue: [ FlakyTestReportWindow open: (FlakyTestAnalysis for: model currentCompiledMethod) value ]! !

!TestSuite class methodsFor: '*FlakyTestsDetector' stamp: 'RNG 3/6/2020 19:37:39'!
forTestMethod: aCompiledMethod named: aName
	
	| suite |
	
	suite _ self named: aName.
	suite addTest: (aCompiledMethod methodClass selector: aCompiledMethod selector).
	
	^suite
		! !
