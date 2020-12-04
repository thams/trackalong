Class {
	#name : #TrackAlong,
	#superclass : #Object,
	#classInstVars : [
		'googleMapApiKey',
		'snsARN',
		'ourLogger',
		'ourProcesses',
		'ourSystemLogger',
		'ourTrackLogger'
	],
	#category : #TrackAlong
}

{ #category : #accessing }
TrackAlong class >> daemons [ 
	^ourProcesses
]

{ #category : #accessing }
TrackAlong class >> flushKeys [
	"TrackAlong flushKeys"

	googleMapApiKey := nil.
	snsARN := nil.
]

{ #category : #accessing }
TrackAlong class >> googleAPIKey [
	"get from environment variable GOOGLE_API_KEY
	if absent, from ~/.ssh/api-keys/google-api-key"

	googleMapApiKey
		ifNil: [ googleMapApiKey := OSPlatform current environment
				at: 'GOOGLE_API_KEY'
				ifAbsent:
					[ (FileLocator home / '.ssh/api-keys/google-api-key') contents trim ] ].
	^ googleMapApiKey
]

{ #category : #accessing }
TrackAlong class >> poll: userID [ 

	self trackLogger.
	self systemLogger.
	^ self poll: userID oldest: nil newest: nil
	"TrackPoint request: 'someonesGarminID'"

	"| aPoint urlString xml |
	
	urlString := 'https://share.garmin.com/Feed/Share/', userID.
	xml := ZnClient new beOneShot
		accept: ZnMimeType applicationXml;
		contentReader: [ :entity | XMLDOMParser parse: entity contents ];
		get: urlString.
	aPoint := self new with: xml.
	^ aPoint"
]

{ #category : #accessing }
TrackAlong class >> poll: userID oldest: timeString1 newest: timeString2 [
	"TrackAlong poll: 'someone' oldest: '2020-08-22T03:07Z' newest: '2020-08-25T20:04Z' "

	"Return collection of TrackPoints or empty collection if something fail, logging to TrackAlong system logger"

	| client |
	client := ZnClient new.
	client
		systemPolicy;
		https;
		timeout: 10;
		host: 'share.garmin.com';
		path: 'feed/Share';
		addPath: userID.
	timeString1 ifNotNil: [ client queryAt: 'd1' put: timeString1 ].
	timeString2 ifNotNil: [ client queryAt: 'd2' put: timeString2 ].
	^ client
		contentReader: [ :entity | 
			| xml extendedDatas |
			xml := XMLDOMParser parse: entity contents.
			"Only grab trackpoints with an ExtendedData node; ignore summary node"
			extendedDatas := xml
				xpath: 'kml/Document/Folder/Placemark/ExtendedData'.
			extendedDatas
				collect: [ :placemark | TrackPoint new xmlPlacemarkNode: placemark parent ] ];
		ifFail: [ :exception | 
			TrackAlong
				systemLog: [ 'Problem polling Garmin' asBeaconSignal emit.
					exception emit ].
			"Return empty collection for sake of caller that is expecting collection of trackpoints"
			OrderedCollection new. ];
		get
]

{ #category : #accessing }
TrackAlong class >> prove [
	"Just prove that code is loaded"
	Transcript crShow: 'TrackAlong at ', Time now asString.
	Transcript crShow: 'TrackAlong sending message to SNS'.
	AWSSNS new publishMessage: ('Proving Trackalong at', Time now asString) arn: TrackAlong snsARN.
]

{ #category : #accessing }
TrackAlong class >> reset [
	"TrackAlong reset"
	ourLogger := nil.
	ourTrackLogger := nil.
	ourProcesses do: [ :process | process terminate ]
]

{ #category : #accessing }
TrackAlong class >> snsARN [
	"get from environment variable SNS_ARN
	if absent, from ~/.ssh/api-keys/sns_arn"

	snsARN
		ifNil: [ snsARN := OSPlatform current environment
				at: 'SNS_ARN'
				ifAbsent: [ (FileLocator home / '.ssh/api-keys/sns_arn') contents trim ] ].
	^ snsARN
]

{ #category : #accessing }
TrackAlong class >> startDaemon: aPilotIdentifier [
	"aPilotIdentifier is the string that indicates which pilot on Garmin's system"
	| process track |
	track := self trackPilot: aPilotIdentifier.
	process := [ [ true ]
		whileTrue: [ | points |
			points := TrackAlong
				poll: aPilotIdentifier
				oldest: DateAndTime now - 20 minutes
				newest: DateAndTime now.
			points do: [ :point | track add: point ].
			(Delay forSeconds: 10) wait ] ] fork.
	ourProcesses ifNil: [ ourProcesses := Dictionary new ].
	ourProcesses at: track put: process.
	^ process
]

{ #category : #accessing }
TrackAlong class >> systemLog: aBlock [
	self systemLogger runDuring: aBlock.
	
]

{ #category : #accessing }
TrackAlong class >> systemLogger [
		^ ourSystemLogger ifNil: [ourSystemLogger := MemoryLogger named: 'TrackAlongSystemLogger'].
]

{ #category : #accessing }
TrackAlong class >> trackLogger [
	^ ourTrackLogger ifNil: [ourTrackLogger := FlightTrackLogger startFor: TrackLoggerSignal]
]

{ #category : #accessing }
TrackAlong class >> trackPilot: aPilot [
	| flightTrack points |
	flightTrack := FlightTrack new pilot: aPilot.
	points := TrackAlong poll: aPilot oldest: (DateAndTime now - (10 minutes)) newest: DateAndTime now.
	points do: [ :point | flightTrack add: point ].
	^ flightTrack
]
