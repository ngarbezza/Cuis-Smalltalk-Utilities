'From Cuis 5.0 of 7 November 2016 [latest update: #3724] on 4 May 2019 at 10:32:56 pm'!
'Description A Percentage class. Example usage: 10 percent of: 2000 returns 200'!
!provides: 'Utils-Percentage' 1 0!
SystemOrganization addCategory: #'Utils-Percentage'!


!classDefinition: #PercentageTest category: #'Utils-Percentage'!
TestCase subclass: #PercentageTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Utils-Percentage'!
!classDefinition: 'PercentageTest class' category: #'Utils-Percentage'!
PercentageTest class
	instanceVariableNames: ''!

!classDefinition: #Percentage category: #'Utils-Percentage'!
Object subclass: #Percentage
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Utils-Percentage'!
!classDefinition: 'Percentage class' category: #'Utils-Percentage'!
Percentage class
	instanceVariableNames: ''!


!PercentageTest methodsFor: 'as yet unclassified' stamp: 'RNG 5/4/2019 22:26:49'!
test01_100PercentOf100Is100

	self assert: (100 percent of: 100) equals: 100! !

!PercentageTest methodsFor: 'as yet unclassified' stamp: 'RNG 5/4/2019 22:26:53'!
test02_50PercentOf100Is50

	self assert: (50 percent of: 100) equals: 50! !

!PercentageTest methodsFor: 'as yet unclassified' stamp: 'RNG 5/4/2019 22:27:51'!
test03_10PercentOf50Is5

	self assert: (10 percent of: 50) equals: 5! !

!Percentage methodsFor: 'initialization' stamp: 'RNG 5/4/2019 22:25:52'!
value: aNumber

	value _ aNumber! !

!Percentage methodsFor: 'applying' stamp: 'RNG 5/4/2019 22:27:20'!
of: aNumber

	^ aNumber * (value / 100)! !

!Percentage class methodsFor: 'instance creation' stamp: 'RNG 5/4/2019 22:25:37'!
value: aNumber

	^ self new value: aNumber! !

!Number methodsFor: '*Utils-Percentage' stamp: 'RNG 5/4/2019 22:25:12'!
percent
	
	^ Percentage value: self! !
