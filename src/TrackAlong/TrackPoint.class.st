"
I represent a track point that includes, lat/lon/altitude/velocity

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #TrackPoint,
	#superclass : #Object,
	#instVars : [
		'myRawXML',
		'myLatitude',
		'myLongitude',
		'myAltitudeMSL',
		'myElevation',
		'myTimeUTC',
		'amTakeoffPoint',
		'myPreviousPoint',
		'myDistance',
		'amLandingPoint',
		'myDirectoryEntry',
		'myTrack',
		'myTrackID',
		'myEvent'
	],
	#category : #TrackAlong
}

{ #category : #accessing }
TrackPoint class >> composeColumnedList: aColumnedList [	
		^ aColumnedList 
		column: 'Time' text: [ :tp | tp timeUTC asString ];
		column: 'Status'
			text: [ :tp | 
			tp statusText];
		column: 'Dist'
			text: [ :tp | 
			tp distance
				ifNil: [ '' ]
				ifNotNil: [ tp distance asInteger asString , ' away ' ] ];
		column: 'Dupe?' text: [ :tp | tp duplicatesPreviousPoint ];
		column: 'AGL' text: [ :tp | tp altitudeAGL asInteger asString ];
		column: 'Lat/Long/Alt'
			text: [ :tp | 

			tp latitude asString , '/' , tp longitude asString
				, tp altitude asString ]

]

{ #category : #accessing }
TrackPoint class >> distanceFromLat: lat1 long: long1 toLat: lat2 long: long2 [
	"Answer the distance in meters between two coordinates in float number representation."
	"From https://pastebin.com/ThKDXCKK"
	"From http://forum.world.st/Geo-coordinates-operations-td4732373.html#a4732441"

	| lat1Rad lon1Rad lat2Rad lon2Rad earthRadius dLat dLon dLatSinSqrd dLonSinSqrd cosLatLat a c distance |
	lat1Rad := lat1 degreesToRadians.
	lon1Rad := long1 degreesToRadians.
	lat2Rad := lat2 degreesToRadians.
	lon2Rad := long2 degreesToRadians.
	earthRadius := 6371.00.
	dLat := lat2Rad - lat1Rad.
	dLon := lon2Rad - lon1Rad.
	dLatSinSqrd := (dLat / 2) sin squared.
	dLonSinSqrd := (dLon / 2) sin squared.
	cosLatLat := lat2Rad cos * lat1Rad cos.
	a := dLatSinSqrd + (cosLatLat * dLonSinSqrd).
	c := 2 * a sqrt arcSin.
	distance := earthRadius * c.
	^ distance
]

{ #category : #'instance creation' }
TrackPoint class >> file: aFileReference [
	"TrackPoint file: ___"

	| aPoint xmlString |
	xmlString := aFileReference readStream contents.
	aPoint := self string: xmlString.
	aPoint fileReference: aFileReference.
	^ aPoint
]

{ #category : #'instance creation' }
TrackPoint class >> string: anXMLString [
	| aPoint xml |
	xml := XMLDOMParser parse: anXMLString.
	aPoint := self new xmlDocNode: xml.
	^ aPoint
]

{ #category : #'instance creation' }
TrackPoint class >> x_request: request [
	"TrackPoint request: 'someonesGarminID'"

	| aPoint urlString xml |
	
	urlString := 'https://share.garmin.com/Feed/Share/', request.
	"urlString := 'https://share.garmin.com/Feed/ShareLoader/', request."
	xml := ZnClient new beOneShot
		accept: ZnMimeType applicationXml;
		contentReader: [ :entity | XMLDOMParser parse: entity contents ];
		get: urlString.
	aPoint := self new with: xml.
	^ aPoint
]

{ #category : #accessing }
TrackPoint >> abbreviation [
	"TODO: consider making this not dependent on GT"
	^ (self timeUTC asString , ': ') asRopedText
		,
			(self statusText)
		,
			(myDistance
				ifNil: [ ' ' asRopedText ]
				ifNotNil: [ (myDistance asInteger asString , ' away ') asRopedText ])
		,
			(self altitudeAGL asInteger asString , ' AGL, {'
				, self latitude asString , '/' , self longitude asString , '}, '
				, self altitude asString) asRopedText
]

{ #category : #accessing }
TrackPoint >> aloft [
	"TODO: make this more sophisticated"
	"Need to introduce notion of uncertainty... can't say aloft if don't have recent data"
	^ self altitudeAGL > 200
]

{ #category : #accessing }
TrackPoint >> altitude [
	"Altitude above Mean Sea Level in meters"
	^ myAltitudeMSL
]

{ #category : #accessing }
TrackPoint >> altitudeAGL [
	^ self altitude - self elevation
]

{ #category : #accessing }
TrackPoint >> becomeLanding [
	| message |
	amLandingPoint := true.
	message := myTrack pilotName, ' landed, ' , self abbreviation asString , ' near '
		, self placeName.
	self emitNotification: message
]

{ #category : #accessing }
TrackPoint >> becomeMoving [
	| message |
	message := myTrack pilotName, ' is moving, ' , self abbreviation asString , ' near '
		, self placeName.
	self emitNotification: message
]

{ #category : #accessing }
TrackPoint >> becomeTakeoff [
	| message |
	amTakeoffPoint := true.
	message := myTrack pilotName, ' took off, ' , self abbreviation asString , ' near '
		, self placeName.
	self emitNotification: message
]

{ #category : #accessing }
TrackPoint >> comparedTo: aTrackPoint [
	"Describe how I differ from the argument"
	^ 'Dist: ', (self distanceFrom: aTrackPoint) asString ,
	'Higher Altitude: ', (self altitude - aTrackPoint altitude) asString,
	'Aloft: ', self aloft asString, '/', aTrackPoint aloft asString.
	
	
]

{ #category : #accessing }
TrackPoint >> deleteFile [
	"Delete the file that created me."

	myDirectoryEntry asFileReference delete
]

{ #category : #accessing }
TrackPoint >> differentDataPoint: aTrackPoint [
	"True if the argument is not the same, based on the ID and Timestamp"
	^ myTrackID ~= aTrackPoint trackID 
]

{ #category : #accessing }
TrackPoint >> differentPosition: aTrackPoint [
	"True if argument differes in location or altitude from receiver.
	TODO: what is behavior for trackers that do not report altitude?
	TODO: define tollerance. Is 1 inch different?"

	"^ (self distanceFrom: aTrackpoint) ~= 0"

	^ myAltitudeMSL ~= aTrackPoint altitude
		or: [ myLatitude ~= aTrackPoint latitude
				or: [ myLongitude ~= aTrackPoint longitude ] ]
]

{ #category : #accessing }
TrackPoint >> differentSample: aTrackpoint [
	"True if argument and receiver are different polling samples from Delorme"
	"of the form: KML Export 9/14/2020 1:19:14 AM"
	"Note that one sample can have multiple trackpoints"
	
	^ self docname ~= aTrackpoint docname

]

{ #category : #accessing }
TrackPoint >> directoryEntry: aDirectoryEntry [
	myDirectoryEntry := aDirectoryEntry
]

{ #category : #accessing }
TrackPoint >> distance [
	"Distande from previous point"
	^ myDistance 
]

{ #category : #accessing }
TrackPoint >> distanceFrom: aTrackPoint [
	"Distance in meters"
	^ self class distanceFromLat: self latitude long: self longitude toLat: aTrackPoint latitude long: aTrackPoint longitude
]

{ #category : #accessing }
TrackPoint >> docname [
	"the KML docname header; seems to reflect the timestamp of when the API query made to DeLoreme"
	^ (myRawXML xpath: '//kml/Document/name') first contentString trimBoth.
		
		

]

{ #category : #accessing }
TrackPoint >> duplicates: aTrackPoint [
	"True if this is the same point in space"
	^ myAltitudeMSL == aTrackPoint altitudeMSL and: [myLatitude == aTrackPoint latitude and: [myLongitude == aTrackPoint longitude]]
]

{ #category : #accessing }
TrackPoint >> duplicatesPreviousPoint [
	"Text indidating whether dupe of previous, or n/a"

	myPreviousPoint
		ifNil: [ ^ 'n/a' ]
		ifNotNil: [ ^ (self differentPosition: myPreviousPoint) ifTrue: [' '] ifFalse: ['dupe'] ]
]

{ #category : #accessing }
TrackPoint >> elevation [
	"The terrain elevation as calculated for the lat/long based on Google Maps"

	"maps.googleapis.com/maps/api/elevation/xml?locations=#{latitude},#{longitude}&sensor=true"

	myElevation
		ifNil: [ myElevation := ZnClient new
				systemPolicy;
				"TODO what does this do?"
					https;
				timeout: 10;
				"TODO what is a reasonable value?"
					host: 'maps.googleapis.com';
				path: 'maps/api/elevation/xml';
				contentReader: [ :entity | 
					| xml |
					xml := XMLDOMParser parse: entity contents.
					(xml xpath: '//ElevationResponse/result/elevation') first
						contentString trimBoth asNumber ];
				queryAt: 'key' put: TrackAlong googleAPIKey;
				queryAt: 'locations'
					put: self latitude asString , ',' , self longitude asString;
				queryAt: 'sensor' put: 'true';
				"ifFail: [ :exception | self inform: 'I am sorry: ', exception printString ];"
					get ].
	^ myElevation
]

{ #category : #accessing }
TrackPoint >> emitNotification: aMessage [
	AWSSNS new publishMessage: aMessage arn: TrackAlong snsARN.
	TrackLoggerSignal emit: aMessage
]

{ #category : #accessing }
TrackPoint >> fileReference: aDirectoryEntry [
	myDirectoryEntry := aDirectoryEntry
]

{ #category : #accessing }
TrackPoint >> googleMapLink: aView [
	"Link to a Google Map of location"

	<gtView>
	^ aView explicit
		title: 'Map Link' translated;
		priority: 15;
		stencil: [ | url |
			url := 'https://www.google.com/maps/search/' asZnUrl
				queryAt: 'query'
					put: self latitude asString , ',' , self longitude asString;
				queryAt: 'api' put: '1';
				yourself.
			BrButton new
				look: BrGlamorousButtonWithLabelLook;
				label: url;
				action: [ WebBrowser openOn: url ] ]
]

{ #category : #accessing }
TrackPoint >> googleMapView: aView [
	"Display a Google Map of location"
	"How to do pop-up description https://stackoverflow.com/questions/31299997/custom-description-in-google-map-marker"
	"Could use a label to indicate motion? |label:A"

	<gtView>
	^ aView explicit
		title: 'Map' translated;
		priority: 14;
		stencil: [ | client image pinColor markersString |
			pinColor := self aloft ifTrue: ['blue'] ifFalse: ['green'].
			markersString := 'color:', pinColor, '|', (self latitude asString , ',' , self longitude asString). 
			client := ZnClient new
				systemPolicy;
				https;
				accept: ZnMimeType imagePng;
				host: 'maps.googleapis.com';
				path: 'maps/api/staticmap';
				queryAt: 'key' put: TrackAlong googleAPIKey;
				queryAt: 'markers' put: markersString;
				queryAt: 'center'
					put: self latitude asString , ',' , self longitude asString;
				queryAt: 'zoom' put: '13';
				queryAt: 'size' put: '600x300';
				queryAt: 'maptype' put: 'roadmap';
				contentReader: [ :entity | ImageReadWriter formFromStream: entity readStream ].
			image := client get.
			image asElement asScrollableElement ]
]

{ #category : #accessing }
TrackPoint >> gtViewOn: aView [
	<gtView>
	
	"TODO: this should be a vertical view. Example: GtImage>>gtPreviewFor:"
	| cl |
	cl := aView columnedList
		title: 'TrackPoint' translated;
		priority: 5;
		items: [ Array with: self ].
	self class composeColumnedList: cl.
	^ cl

]

{ #category : #accessing }
TrackPoint >> gtViewXMLTree: aView [
	<gtView>
	"TODO: still needs work."
	myRawXML supportsTreeView
		ifFalse: [ ^ aView empty ].
	^ aView tree
		title: 'XML Tree';
		priority: 9;
		items: [ myRawXML treeViewChildren ];
		children: [ :each | each treeViewChildren ];
		itemText: [ :each | 
			| a tagWriter xmlWriter |
			"'<', each localName, '>', each attributeNodes first contents]"
			xmlWriter := XMLWriter new.
			tagWriter := xmlWriter tag: each name.	"localname ?"
			"tagWriter"
			"enablePrettyPrinting;"
			"xml."
			"tagWriter tag: each name.	"
			each hasAttributes
				ifTrue: [ tagWriter setAttributes: each attributeNodes ].
			"tagWriter with: each string."
			each
				nodesDo: [ :inner_each | 
					inner_each class == XMLString
						ifTrue: [ inner_each writeXMLOn: xmlWriter ] ].
			"(each class == XMLString  or: [each class == XMLElement]) 
				ifTrue: [ 
					each writeXMLOn: xmlWriter ]
				ifFalse: [ 
					each writeXMLOn: xmlWriter ]."
			a := tagWriter contents.
			a ]
	"			each hasChildren
				ifTrue: [ each
						nodesDo: [ :beach | 
							beach class == XMLString
								ifTrue: [ 'boo' writeOn: tagWriter.
									beach writeXMLOn: tagWriter ]
								ifFalse: [ 'foo' writeOn: tagWriter.
									tagWriter write	  ] ] ].
			a  := tagWriter contents.
			a]"
]

{ #category : #accessing }
TrackPoint >> gtXMLViewOn: aView [
	<gtView>
	^ aView forward
		title: 'XML' translated;
		priority: 10;
		object: [ myRawXML ];
		view: #gtItemsFor: 
]

{ #category : #accessing }
TrackPoint >> initialize [
	super initialize.
	myLatitude := 0.
	myLongitude := 0.
	myAltitudeMSL := 0.
	amTakeoffPoint := false.
	amLandingPoint := false
]

{ #category : #accessing }
TrackPoint >> isLanding [
	^ amLandingPoint
]

{ #category : #accessing }
TrackPoint >> isTakeoff [
	^ amTakeoffPoint
]

{ #category : #accessing }
TrackPoint >> latitude [
	^ myLatitude
]

{ #category : #'instance creation' }
TrackPoint >> latitude: aLatitude longitude: aLongitude altitude: anAltitude elevation: anElevation trackID: trackID [
	myLatitude := aLatitude.
	myLongitude := aLongitude.
	myAltitudeMSL := anAltitude.
	myElevation := anElevation.
	myTrackID := trackID
]

{ #category : #accessing }
TrackPoint >> longitude [
	^ myLongitude
]

{ #category : #accessing }
TrackPoint >> pilotName [
	^ (myRawXML xpath: '//kml/Document/Folder/name') first contentString trimBoth.
]

{ #category : #accessing }
TrackPoint >> placeName [
	"The place name for the lat/long based on Google Maps"

	"TODO: Cache result?"

	^ ZnClient new
		systemPolicy;
			https;
		timeout: 10;
		host: 'maps.googleapis.com';
		path: 'maps/api/geocode/xml';
		queryAt: 'key' put: TrackAlong googleAPIKey;
		queryAt: 'latlng'
			put: self latitude asString , ',' , self longitude asString;
		queryAt: 'sensor' put: 'true';
		contentReader: [ :entity | 
			| xml |
			xml := XMLDOMParser parse: entity contents.
			(xml xpath: '//GeocodeResponse/result/formatted_address') first
				contentString trimBoth ];
		"ifFail: [ :exception | self inform: 'I am sorry: ', exception printString ];"
			get
]

{ #category : #accessing }
TrackPoint >> previousPoint [
	^myPreviousPoint
]

{ #category : #accessing }
TrackPoint >> previousPoint: aTrackPoint [ 
	myPreviousPoint := aTrackPoint.
	myDistance := self distanceFrom: aTrackPoint 
	
]

{ #category : #printing }
TrackPoint >> printOn: aStream [
 
 	super printOn: aStream.
 	aStream
 		nextPut: $(;
 		nextPutAll: (self abbreviation);
 		nextPut: $)
		
]

{ #category : #accessing }
TrackPoint >> reify [
	"TODO: timestamp comes from /kml/Document/Folder/Placemark/TimeStamp/when but could also be drawn from /kml/Document/Folder/Placemark/ExtendedData/Data name=""Time UTC""  Unsure the difference"

	| altitudeString |
	"Use this form if myRawXML is a Placemark XMLElement"
	altitudeString := (myRawXML
		xpath: './ExtendedData/Data[@name="Elevation"]/value') first
		contentString trimBoth.
	altitudeString := (altitudeString splitOn: ' m from MSL') at: 1.
	myAltitudeMSL := altitudeString asNumber.
	myLatitude := (myRawXML xpath: '//Data[@name="Latitude"]/value')
		first contentString trimBoth asNumber.	"No first, make concrete"
	myLongitude := (myRawXML xpath: '//Data[@name="Longitude"]/value')
		first contentString trimBoth asNumber.
	myTimeUTC := DateAndTime
		fromString:
			(myRawXML xpath: '/kml/Document/Folder/Placemark/TimeStamp/when')
				first contentString trimBoth.
	"myTrackID serves as a track UID"
	myTrackID := (myRawXML xpath: 'TimeStamp/when') first contentString
		trimBoth
		,
			(myRawXML xpath: 'ExtendedData/Data[@name="Id"]/value') first
				contentString trimBoth.
	"Tracking turned off from device."
	"Tracking interval received."
	"Tracking turned on from device."
	myEvent := (myRawXML xpath: '//Data[@name="Event"]/value') first
		contentString trimBoth
]

{ #category : #accessing }
TrackPoint >> reportEvent [
	(#('Tracking turned on from device.', 'Tracking turned off from device.') includes: myEvent)  ifTrue:
	[self emitNotification: myEvent].
]

{ #category : #accessing }
TrackPoint >> statusText [
	self isTakeoff ifTrue: [ ^ 'Took off' asRopedText  ].
	self isLanding ifTrue: [ ^ 'Landed' asRopedText ].
	^ self aloft
		ifTrue: [ 'Aloft ' asRopedText foreground: Color blue ]
		ifFalse: [ '' asRopedText ]
]

{ #category : #accessing }
TrackPoint >> timeUTC [
	^ myTimeUTC 
]

{ #category : #accessing }
TrackPoint >> track: aFlightTrack [
	myTrack := aFlightTrack
	
]

{ #category : #accessing }
TrackPoint >> trackID [
	^ myTrackID
]

{ #category : #'instance creation' }
TrackPoint >> xmlDocNode: anXML [
	"Use the first point in the xmlDoc. "

	self xmlPlacemarkNode: (anXML xPath: 'kml/Document/Folder/Placemark') first
]

{ #category : #'instance creation' }
TrackPoint >> xmlPlacemarkNode: anXML [
	myRawXML := anXML.
	self reify.

]
