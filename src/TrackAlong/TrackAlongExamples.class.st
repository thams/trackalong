Class {
	#name : #TrackAlongExamples,
	#superclass : #Object,
	#category : #'TrackAlong-TrackAlong'
}

{ #category : #accessing }
TrackAlongExamples >> doSomethingWithTrackingTurnedOnFromDevice [
	"          <Data name=""Event"">
            <value>Tracking turned on from device.</value>
          </Data>"

	<gtExample>
	self assert: false
]

{ #category : #accessing }
TrackAlongExamples >> pullFromDeLorme [
	<gtExample>
	<gtDescription: 'should get latest events'>
	"TODO: make this pull from stored archive."
	| points flightTrack pilotName |
	
"https://share.delorme.com/feed/Share/KurtThams?d1=2020-08-22T03:07Z&d2=2020-08-25T20:04Z"
	points := TrackAlong
		poll: 'KurtThams'
		oldest: '2020-08-25T00:47:45Z'
		newest: '2020-08-25T00:49:45Z'.
	self assert: points size equals: 2.
	self assert: (points first differentDataPoint: points last).
	pilotName := points first pilotName.
	self assert: pilotName equals: 'Kurt Thams'.
	flightTrack := FlightTrack new pilot: (pilotName).
	self assert: flightTrack trackLogger recordings size equals: 0.
	points do: [ :point | flightTrack add: point ].
	self assert: flightTrack size equals: 2.
	self assert: (flightTrack trackLogger recordings size) > 10.
	^ flightTrack
]

{ #category : #accessing }
TrackAlongExamples >> rePullFromDeLorme [
	<gtExample>
	<gtDescription: 'should ignore duplicate events'>
	"TODO: Make this pull from archived event data"
	| points flightTrack |
	flightTrack := self pullFromDeLorme.
	self assert: flightTrack size equals: 2.

	"Do it again for same period; should be no duplicates"
	points := TrackAlong
		poll: 'KurtThams'
		oldest: '2020-08-25T00:47:45Z'
		newest: '2020-08-25T00:49:45Z'.
	self assert: points size equals: 2.
	points do: [ :point | flightTrack add: point ].
	self assert: flightTrack size equals: 2.
	self
		assert:
			(flightTrack trackLogger recordings last message
				beginsWith: 'Got duplicate trackpoint').
	^ flightTrack
]

{ #category : #accessing }
TrackAlongExamples >> startDaemon [
	<gtExample>
	|aThread|
	aThread := TrackAlong startDaemon: 'KurtThams'.
	aThread suspend.
	^aThread.
]

{ #category : #accessing }
TrackAlongExamples >> trackOneLoop [
	<gtExample>
	"TODO: Make this a better test case"
	| track | 
	track := TrackAlong trackPilot: 'KurtThams'.
	self assert: track class equals: FlightTrack.
	^ track

]
