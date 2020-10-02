Class {
	#name : #FlightTrackExamples,
	#superclass : #Object,
	#category : #'TrackAlong-TrackAlong'
}

{ #category : #examples }
FlightTrackExamples >> a10trackingStarts [
	<gtExample>
	<gtDescription: 'Tracker has just been picked up. No flight yet'>

	self assert: false.

]

{ #category : #examples }
FlightTrackExamples >> a20inMotionOnGround [
	<gtExample>
	<gtDescription: 'In motion on ground'>

	self assert: false.

]

{ #category : #examples }
FlightTrackExamples >> a30inAir [
	<gtExample>
	<gtDescription: ''>

	self assert: false.

]

{ #category : #examples }
FlightTrackExamples >> a40inMotionInAir [
	<gtExample>
	<gtDescription: ''>

	self assert: false.

]

{ #category : #examples }
FlightTrackExamples >> a50landed [
	<gtExample>
	<gtDescription: ''>

	self assert: false.

]

{ #category : #examples }
FlightTrackExamples >> aloftWhenTrackingStarts [
	<gtExample>
	<gtDescription: 'Handle case where our first telemetry is that pilot is aloft'>
	

	self assert: false.

]

{ #category : #examples }
FlightTrackExamples >> discoverAloft [
	<gtExample>
	<gtDescription:
		'The series of events should conclude user has taken off and should message as such'>
	| flightTrack tp1 tp2 x |
	flightTrack := FlightTrack new pilot: 'Kurt'.
	self assert: flightTrack takeoffPoint isNil.
	tp1 := TrackPoint new
		latitude: 38
		longitude: -122.4
		altitude: 1000.2
		elevation: 1000.9
		trackID: 1.
	self assert: tp1 aloft not.
	flightTrack add: tp1.
	self assert: flightTrack takeoffPoint isNil.
	tp2 := TrackPoint new
		latitude: 38.9
		longitude: -122.5
		altitude: 5000.2
		elevation: 1000.2
		trackID: nil.
	self assert: tp2 aloft.
	self assert: flightTrack takeoffPoint isNil.
	self
		assert: tp1 isTakeoff not
		description: 'has not added to track yet'.
	flightTrack add: tp2.
	x := flightTrack takeoffPoint.
	self assert: x equals: tp1.
	self assert: tp1 isTakeoff.
	^ flightTrack
]

{ #category : #examples }
FlightTrackExamples >> discoverLanded [
	<gtExample>
	<gtDescription:
		'The seriese of events should conclude user has landed and should message as such'>
	| flightTrack tp3 |
	flightTrack := self discoverAloft.
	self assert: flightTrack takeoffPoint isNotNil.
	tp3 := TrackPoint new
		latitude: 38
		longitude: -122.4
		altitude: 1000.5
		elevation: 1000.5
		trackID: 2.
	self assert: tp3 aloft not.
	flightTrack add: tp3.
	self assert: tp3 isLanding.
	^ self
]

{ #category : #examples }
FlightTrackExamples >> dontAddDuplicates [
	<gtExample>
	| flightTrack tp1 |
	flightTrack := FlightTrack new pilot: 'Kurt'.
	tp1 := TrackPoint new
		latitude: 38
		longitude: -122.4
		altitude: 1000.2
		elevation: 1000.9
		trackID: 1.
	flightTrack add: tp1.
	self assert: flightTrack size equals: 1.
	flightTrack add: tp1.
	self assert: flightTrack size equals: 1.
	self assert: (flightTrack trackLogger recordings first message beginsWith: 'Got duplicate trackpoint').
	^ flightTrack
]

{ #category : #examples }
FlightTrackExamples >> landedWrongPlace [
	<gtExample>
	<gtDescription: 'The series of events should conclude user landed at unexpected location'>
	
	self assert: false.
	^self

]

{ #category : #accessing }
FlightTrackExamples >> messageAloftNear [
	<gtExample>
	<gtDescription: 'user has taken off near Truckee Airport'>
	
	self assert: false.
]

{ #category : #examples }
FlightTrackExamples >> messageAloftNot [
	<gtExample>
	<gtDescription: 'The series of events should see user mobile but not conclude user has taken off'>
	
	self assert: false.

]

{ #category : #examples }
FlightTrackExamples >> messageLandedNot [
	<gtExample>
	<gtDescription: 'The seriese of events should conclude user has not landed'>
	
	self assert: false.
	^self

]

{ #category : #examples }
FlightTrackExamples >> messageLandedWrongPlace [
	<gtExample>
	<gtDescription: 'The series of events should message user landed at unexpected location '>
	
	self assert: false.
	^self

]

{ #category : #examples }
FlightTrackExamples >> messageOverdue [
	<gtExample>
	<gtDescription: 'The series of events should conclude user is overdue'>
	
	self assert: false.

]
