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
			spec
				baseline: 'AWS'
				with:
					[ "Use envvariable branch; that feature not accepted into master at upstream"
					  spec repository: 'github://thams/aws-sdk-smalltalk:envvariable/pharo-repository' ] ]
]
