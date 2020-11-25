Class {
	#name : #FlightTrack,
	#superclass : #Object,
	#instVars : [
		'myTrackpoints',
		'myPilot'
	],
	#category : #TrackAlong
}

{ #category : #accessing }
FlightTrack class >> fromDirectory: aFileReference [
	^ self fromDirectory: aFileReference limit: nil
]

{ #category : #'instance creation' }
FlightTrack class >> fromDirectory: aFileReference limit: anInteger [
	"TODO: Vestigial from early debugging; remove."
	"FlightTrack fromDirectory: (FileSystem home / '/projects/inreach/d2020-06-30') limit: 15"
	"TODO: fix the hack that selects items that begin with 20*"
	| points track files |
	files := (aFileReference entries
		select: [ :entry | '20*' match: entry name ])
		sort: [ :a :b | a name < b name ].
	anInteger ifNotNil: [files := files copyFrom: 1 to: anInteger].
	points := files collect: [ :file | TrackPoint file: file ].
	track := self new.
	points do: [ :point | track add: point ].
	^track
]

{ #category : #initialization }
FlightTrack >> add: newTrackPoint [
	"Takeoff is the point *before* becoming in the air, indicating the ground spot to which you would return."

	| last tookoff landed moved |				
				
	myTrackpoints
		detect: [ :aPoint | (aPoint differentDataPoint: newTrackPoint) not ]
		ifFound: [ TrackLoggerSignal
						emit: 'Got duplicate trackpoint ' , newTrackPoint trackID asString	"ContextStackSignal".
			^ false ].
	"ifNone:  [ :aPoint |  ]."
	newTrackPoint track: self.
	newTrackPoint reportEvent.
	myTrackpoints
		ifEmpty: [ newTrackPoint aloft
				ifTrue: [ newTrackPoint becomeTakeoff ].
			self privateAdd: newTrackPoint.
			^ self ].
	last := myTrackpoints last.
	moved := last differentPosition: newTrackPoint.
	moved ifTrue: [ newTrackPoint becomeMoving  ].
	tookoff := last aloft not and: [ newTrackPoint aloft ].
	landed := last aloft and: [ newTrackPoint aloft not ].
	self privateAdd: newTrackPoint.
	newTrackPoint previousPoint: last.
	self takeoffPoint
		ifNil: [ tookoff
				ifTrue: [ last becomeTakeoff ] ]
		ifNotNil: [ TrackLoggerSignal emit: 'Should not have multiple takeoff points' ].
	self landingPoint
		ifNil: [ landed
				ifTrue: [ newTrackPoint becomeLanding ] ]
		ifNotNil: [ TrackLoggerSignal emit: 'Should not have multiple landing points'  ].
	
]

{ #category : #accessing }
FlightTrack >> gtViewTrack: aView [
	"TODO: indicate if myLogger recordings size ~= 0"

	"^ aView forward
		title: 'XML' translated;
		priority: 10;
		object: [ myRawXML ];
		view: #gtItemsFor: "

	<gtView>
	| cl |
	cl := aView columnedList
		title: 'TrackPoint' translated;
		priority: 5;
		items: [ myTrackpoints ].
	TrackPoint composeColumnedList: cl.
	^ cl
]

{ #category : #accessing }
FlightTrack >> hasTrackpoint: aTrackpoint [
	"true if we already have seen this point from a previous pull"

	myTrackpoints detect: [ ]  ifNone:  [ :aPoint |  ].
	Exception signal
]

{ #category : #initialization }
FlightTrack >> initialize [
	super initialize.
	myTrackpoints := OrderedCollection new.
	
]

{ #category : #initialization }
FlightTrack >> landingPoint [
	^ myTrackpoints
		detect: [ :point | point isLanding ]
		ifNone: [ ^ nil ]
]

{ #category : #accessing }
FlightTrack >> pilot: aPilot [
	myPilot := aPilot
]

{ #category : #accessing }
FlightTrack >> pilotName [
	^ myPilot
]

{ #category : #initialization }
FlightTrack >> privateAdd: newTrackPoint [

	myTrackpoints add: newTrackPoint.
	TrackAlong systemLog: [ newTrackPoint asBeaconSignal emit ]
]

{ #category : #accessing }
FlightTrack >> size [
	^myTrackpoints size
]

{ #category : #accessing }
FlightTrack >> takeoffPoint [
	"the departure point or nil if none"
	"each track should have only one departure point. If there is a second departure, should be a new track"
		^ myTrackpoints detect: [:point | point isTakeoff] ifNone: [ ^nil ]
]
