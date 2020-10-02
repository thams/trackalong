Class {
	#name : #BaselineOfTrackAlong,
	#superclass : #BaselineOf,
	#category : #BaselineOfTrackAlong
}

{ #category : #baselines }
BaselineOfTrackAlong >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec package: 'TrackAlong'.
			" spec
				baseline: 'AWS'
				with:
					[ spec repository: 'github://thams/aws-sdk-smalltalk/pharo-repository' ]" ]
]
