Class {
	#name : #TrackPointExamples,
	#superclass : #Object,
	#instVars : [
		'tp1'
	],
	#category : #'TrackAlong-TrackAlong'
}

{ #category : #examples }
TrackPointExamples >> aloft [
	<gtExample>
	| tp |
	tp := TrackPoint new
		latitude: 38
		longitude: -122.4
		altitude: 5000.2
		elevation: 5010.2
		trackID: 1.
	self assert: tp aloft not.
	self assert: tp statusText isEmpty.
	tp := TrackPoint new
		latitude: 38
		longitude: -122.4
		altitude: 5000.2
		elevation: 1000.2
		trackID: 1.
	self assert: tp aloft.
	self assert: (tp statusText asString) equals: 'Aloft '.


	"Case where there tracking data is halted"
	"	tp := TrackPoint new.
	tp becomeNotCurrent.
	self should: [tp aloft] raise: Error.
"
	^ tp
]

{ #category : #examples }
TrackPointExamples >> altitudeAGL [
	<gtExample>

	| a |
	a := TrackPoint new xmlDocNode: self sampleXML.
	self assert: (a altitudeAGL) equals: -2.423701200000096.
	^a

]

{ #category : #examples }
TrackPointExamples >> altitudeMSL [
	<gtExample>

	| a |
	a := TrackPoint new xmlDocNode: self sampleXML.
	self assert: (a altitude) equals: 1948.37. "TODO: add units"
	^a

]

{ #category : #examples }
TrackPointExamples >> differentLocation [
	<gtExample>
	| a b |
	a := TrackPoint string: self sampleXMLString.
	b := TrackPoint string: self sampleXMLString2.
	self assert: [a differentPosition: b].

]

{ #category : #examples }
TrackPointExamples >> distance [
	<gtExample>
	| a b |
	a := TrackPoint string: self sampleXMLString.
	b := TrackPoint string: self sampleXMLString2.
	self assert: (a distanceFrom: b ) equals: 26.48206145502906.

]

{ #category : #accessing }
TrackPointExamples >> distinguishMultiplePlacemarks [
	self assert: false
]

{ #category : #accessing }
TrackPointExamples >> elevation [
	<gtExample>
	| a |
	a := TrackPoint new xmlDocNode: self sampleXML.
	self assert: (a elevation) equals: 1950.7937012.
	^ a
]

{ #category : #examples }
TrackPointExamples >> exampleRequest [
	<gtExample>
	| a |
	a := TrackPoint new xmlDocNode: self sampleXML.
	self assert: (a latitude) equals: 39.250598. 
	self assert: (a longitude) equals: -114.883240.
	^a

]

{ #category : #accessing }
TrackPointExamples >> sampleUnmoved1 [
	^ '<?xml version="1.0" encoding="utf-8"?>
<kml xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>KML Export 6/30/2020 4:11:44 PM</name>
    <Style id="style_emergency">
      <IconStyle>
        <colorMode>normal</colorMode>
        <Icon>
          <href>http://maps.google.com/mapfiles/kml/shapes/caution.png</href>
        </Icon>
      </IconStyle>
      <BalloonStyle>
        <text>&lt;table&gt;&lt;tr&gt;&lt;td&gt;Id&lt;/td&gt;&lt;td&gt; $[Id] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Time&lt;/td&gt;&lt;td&gt; $[Time] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Time UTC&lt;/td&gt;&lt;td&gt; $[Time UTC] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Name&lt;/td&gt;&lt;td&gt; $[Name] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Map Display Name&lt;/td&gt;&lt;td&gt; $[Map Display Name] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Device Type&lt;/td&gt;&lt;td&gt; $[Device Type] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;IMEI&lt;/td&gt;&lt;td&gt; $[IMEI] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Incident Id&lt;/td&gt;&lt;td&gt; $[Incident Id] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Latitude&lt;/td&gt;&lt;td&gt; $[Latitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Longitude&lt;/td&gt;&lt;td&gt; $[Longitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Elevation&lt;/td&gt;&lt;td&gt; $[Elevation] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Velocity&lt;/td&gt;&lt;td&gt; $[Velocity] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Course&lt;/td&gt;&lt;td&gt; $[Course] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Valid GPS Fix&lt;/td&gt;&lt;td&gt; $[Valid GPS Fix] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;In Emergency&lt;/td&gt;&lt;td&gt; $[In Emergency] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Text&lt;/td&gt;&lt;td&gt; $[Text] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Event&lt;/td&gt;&lt;td&gt; $[Event] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;SpatialRefSystem&lt;/td&gt;&lt;td&gt; $[SpatialRefSystem] &lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;</text>
      </BalloonStyle>
    </Style>
    <Style id="style_18475">
      <IconStyle>
        <color>ffc6964f</color>
        <colorMode>normal</colorMode>
        <Icon>
          <href>http://maps.google.com/mapfiles/kml/paddle/wht-blank.png</href>
        </Icon>
      </IconStyle>
      <BalloonStyle>
        <text>&lt;table&gt;&lt;tr&gt;&lt;td&gt;Id&lt;/td&gt;&lt;td&gt; $[Id] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Time&lt;/td&gt;&lt;td&gt; $[Time] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Time UTC&lt;/td&gt;&lt;td&gt; $[Time UTC] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Name&lt;/td&gt;&lt;td&gt; $[Name] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Map Display Name&lt;/td&gt;&lt;td&gt; $[Map Display Name] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Device Type&lt;/td&gt;&lt;td&gt; $[Device Type] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;IMEI&lt;/td&gt;&lt;td&gt; $[IMEI] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Incident Id&lt;/td&gt;&lt;td&gt; $[Incident Id] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Latitude&lt;/td&gt;&lt;td&gt; $[Latitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Longitude&lt;/td&gt;&lt;td&gt; $[Longitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Elevation&lt;/td&gt;&lt;td&gt; $[Elevation] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Velocity&lt;/td&gt;&lt;td&gt; $[Velocity] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Course&lt;/td&gt;&lt;td&gt; $[Course] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Valid GPS Fix&lt;/td&gt;&lt;td&gt; $[Valid GPS Fix] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;In Emergency&lt;/td&gt;&lt;td&gt; $[In Emergency] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Text&lt;/td&gt;&lt;td&gt; $[Text] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Event&lt;/td&gt;&lt;td&gt; $[Event] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;SpatialRefSystem&lt;/td&gt;&lt;td&gt; $[SpatialRefSystem] &lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;</text>
      </BalloonStyle>
    </Style>
    <Style id="waypointstyle_18475">
      <IconStyle>
        <color>ffc6964f</color>
        <colorMode>normal</colorMode>
        <Icon>
          <href>http://maps.google.com/mapfiles/kml/paddle/wht-blank.png</href>
        </Icon>
      </IconStyle>
      <BalloonStyle>
        <text>&lt;table&gt;&lt;tr&gt;&lt;td&gt;Time&lt;/td&gt;&lt;td&gt; $[Time] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Time UTC&lt;/td&gt;&lt;td&gt; $[Time UTC] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Latitude&lt;/td&gt;&lt;td&gt; $[Latitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Longitude&lt;/td&gt;&lt;td&gt; $[Longitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Text&lt;/td&gt;&lt;td&gt; $[Text] &lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;</text>
      </BalloonStyle>
    </Style>
    <Style id="linestyle_18475">
      <LineStyle>
        <color>ffc6964f</color>
        <colorMode>normal</colorMode>
        <width>1</width>
        <labelVisibility xmlns="http://www.google.com/kml/ext/2.2">false</labelVisibility>
      </LineStyle>
    </Style>
    <Folder>
      <name>Kurt Thams</name>
      <Placemark>
        <name>Kurt Thams</name>
        <visibility>true</visibility>
        <description />
        <TimeStamp>
          <when>2020-06-30T01:15:30Z</when>
        </TimeStamp>
        <styleUrl>#style_18475</styleUrl>
        <ExtendedData>
          <Data name="Id">
            <value>408724649</value>
          </Data>
          <Data name="Time UTC">
            <value>6/30/2020 1:15:30 AM</value>
          </Data>
          <Data name="Time">
            <value>6/29/2020 6:15:30 PM</value>
          </Data>
          <Data name="Name">
            <value>Kurt Thams</value>
          </Data>
          <Data name="Map Display Name">
            <value>Kurt Thams</value>
          </Data>
          <Data name="Device Type">
            <value>inReach SE</value>
          </Data>
          <Data name="IMEI">
            <value>300434060605400</value>
          </Data>
          <Data name="Incident Id">
            <value />
          </Data>
          <Data name="Latitude">
            <value>39.298728</value>
          </Data>
          <Data name="Longitude">
            <value>-114.835388</value>
          </Data>
          <Data name="Elevation">
            <value>1859.24 m from MSL</value>
          </Data>
          <Data name="Velocity">
            <value>0.0 km/h</value>
          </Data>
          <Data name="Course">
            <value>0.00 ° True</value>
          </Data>
          <Data name="Valid GPS Fix">
            <value>True</value>
          </Data>
          <Data name="In Emergency">
            <value>False</value>
          </Data>
          <Data name="Text">
            <value />
          </Data>
          <Data name="Event">
            <value>Tracking interval received.</value>
          </Data>
          <Data name="SpatialRefSystem">
            <value>WGS84</value>
          </Data>
        </ExtendedData>
        <Point>
          <extrude>false</extrude>
          <altitudeMode>absolute</altitudeMode>
          <coordinates>-114.835388,39.298728,1859.24</coordinates>
        </Point>
      </Placemark>
      <Placemark>
        <name>Kurt Thams</name>
        <visibility>true</visibility>
        <description>Kurt Thams''s track log</description>
        <styleUrl>#linestyle_18475</styleUrl>
        <LineString>
          <tessellate>true</tessellate>
          <coordinates>-114.835388,39.298728,1859.24</coordinates>
        </LineString>
      </Placemark>
    </Folder>
  </Document>
</kml>'
]

{ #category : #accessing }
TrackPointExamples >> sampleUnmoved2 [
	^ '<?xml version="1.0" encoding="utf-8"?>
<kml xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>KML Export 6/30/2020 4:20:44 PM</name>
    <Style id="style_emergency">
      <IconStyle>
        <colorMode>normal</colorMode>
        <Icon>
          <href>http://maps.google.com/mapfiles/kml/shapes/caution.png</href>
        </Icon>
      </IconStyle>
      <BalloonStyle>
        <text>&lt;table&gt;&lt;tr&gt;&lt;td&gt;Id&lt;/td&gt;&lt;td&gt; $[Id] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Time&lt;/td&gt;&lt;td&gt; $[Time] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Time UTC&lt;/td&gt;&lt;td&gt; $[Time UTC] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Name&lt;/td&gt;&lt;td&gt; $[Name] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Map Display Name&lt;/td&gt;&lt;td&gt; $[Map Display Name] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Device Type&lt;/td&gt;&lt;td&gt; $[Device Type] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;IMEI&lt;/td&gt;&lt;td&gt; $[IMEI] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Incident Id&lt;/td&gt;&lt;td&gt; $[Incident Id] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Latitude&lt;/td&gt;&lt;td&gt; $[Latitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Longitude&lt;/td&gt;&lt;td&gt; $[Longitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Elevation&lt;/td&gt;&lt;td&gt; $[Elevation] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Velocity&lt;/td&gt;&lt;td&gt; $[Velocity] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Course&lt;/td&gt;&lt;td&gt; $[Course] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Valid GPS Fix&lt;/td&gt;&lt;td&gt; $[Valid GPS Fix] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;In Emergency&lt;/td&gt;&lt;td&gt; $[In Emergency] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Text&lt;/td&gt;&lt;td&gt; $[Text] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Event&lt;/td&gt;&lt;td&gt; $[Event] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;SpatialRefSystem&lt;/td&gt;&lt;td&gt; $[SpatialRefSystem] &lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;</text>
      </BalloonStyle>
    </Style>
    <Style id="style_18475">
      <IconStyle>
        <color>ffc6964f</color>
        <colorMode>normal</colorMode>
        <Icon>
          <href>http://maps.google.com/mapfiles/kml/paddle/wht-blank.png</href>
        </Icon>
      </IconStyle>
      <BalloonStyle>
        <text>&lt;table&gt;&lt;tr&gt;&lt;td&gt;Id&lt;/td&gt;&lt;td&gt; $[Id] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Time&lt;/td&gt;&lt;td&gt; $[Time] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Time UTC&lt;/td&gt;&lt;td&gt; $[Time UTC] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Name&lt;/td&gt;&lt;td&gt; $[Name] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Map Display Name&lt;/td&gt;&lt;td&gt; $[Map Display Name] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Device Type&lt;/td&gt;&lt;td&gt; $[Device Type] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;IMEI&lt;/td&gt;&lt;td&gt; $[IMEI] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Incident Id&lt;/td&gt;&lt;td&gt; $[Incident Id] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Latitude&lt;/td&gt;&lt;td&gt; $[Latitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Longitude&lt;/td&gt;&lt;td&gt; $[Longitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Elevation&lt;/td&gt;&lt;td&gt; $[Elevation] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Velocity&lt;/td&gt;&lt;td&gt; $[Velocity] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Course&lt;/td&gt;&lt;td&gt; $[Course] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Valid GPS Fix&lt;/td&gt;&lt;td&gt; $[Valid GPS Fix] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;In Emergency&lt;/td&gt;&lt;td&gt; $[In Emergency] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Text&lt;/td&gt;&lt;td&gt; $[Text] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Event&lt;/td&gt;&lt;td&gt; $[Event] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;SpatialRefSystem&lt;/td&gt;&lt;td&gt; $[SpatialRefSystem] &lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;</text>
      </BalloonStyle>
    </Style>
    <Style id="waypointstyle_18475">
      <IconStyle>
        <color>ffc6964f</color>
        <colorMode>normal</colorMode>
        <Icon>
          <href>http://maps.google.com/mapfiles/kml/paddle/wht-blank.png</href>
        </Icon>
      </IconStyle>
      <BalloonStyle>
        <text>&lt;table&gt;&lt;tr&gt;&lt;td&gt;Time&lt;/td&gt;&lt;td&gt; $[Time] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Time UTC&lt;/td&gt;&lt;td&gt; $[Time UTC] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Latitude&lt;/td&gt;&lt;td&gt; $[Latitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Longitude&lt;/td&gt;&lt;td&gt; $[Longitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Text&lt;/td&gt;&lt;td&gt; $[Text] &lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;</text>
      </BalloonStyle>
    </Style>
    <Style id="linestyle_18475">
      <LineStyle>
        <color>ffc6964f</color>
        <colorMode>normal</colorMode>
        <width>1</width>
        <labelVisibility xmlns="http://www.google.com/kml/ext/2.2">false</labelVisibility>
      </LineStyle>
    </Style>
    <Folder>
      <name>Kurt Thams</name>
      <Placemark>
        <name>Kurt Thams</name>
        <visibility>true</visibility>
        <description />
        <TimeStamp>
          <when>2020-06-30T01:15:30Z</when>
        </TimeStamp>
        <styleUrl>#style_18475</styleUrl>
        <ExtendedData>
          <Data name="Id">
            <value>408724649</value>
          </Data>
          <Data name="Time UTC">
            <value>6/30/2020 1:15:30 AM</value>
          </Data>
          <Data name="Time">
            <value>6/29/2020 6:15:30 PM</value>
          </Data>
          <Data name="Name">
            <value>Kurt Thams</value>
          </Data>
          <Data name="Map Display Name">
            <value>Kurt Thams</value>
          </Data>
          <Data name="Device Type">
            <value>inReach SE</value>
          </Data>
          <Data name="IMEI">
            <value>300434060605400</value>
          </Data>
          <Data name="Incident Id">
            <value />
          </Data>
          <Data name="Latitude">
            <value>39.298728</value>
          </Data>
          <Data name="Longitude">
            <value>-114.835388</value>
          </Data>
          <Data name="Elevation">
            <value>1859.24 m from MSL</value>
          </Data>
          <Data name="Velocity">
            <value>0.0 km/h</value>
          </Data>
          <Data name="Course">
            <value>0.00 ° True</value>
          </Data>
          <Data name="Valid GPS Fix">
            <value>True</value>
          </Data>
          <Data name="In Emergency">
            <value>False</value>
          </Data>
          <Data name="Text">
            <value />
          </Data>
          <Data name="Event">
            <value>Tracking interval received.</value>
          </Data>
          <Data name="SpatialRefSystem">
            <value>WGS84</value>
          </Data>
        </ExtendedData>
        <Point>
          <extrude>false</extrude>
          <altitudeMode>absolute</altitudeMode>
          <coordinates>-114.835388,39.298728,1859.24</coordinates>
        </Point>
      </Placemark>
      <Placemark>
        <name>Kurt Thams</name>
        <visibility>true</visibility>
        <description>Kurt Thams''s track log</description>
        <styleUrl>#linestyle_18475</styleUrl>
        <LineString>
          <tessellate>true</tessellate>
          <coordinates>-114.835388,39.298728,1859.24</coordinates>
        </LineString>
      </Placemark>
    </Folder>
  </Document>
</kml>'
]

{ #category : #accessing }
TrackPointExamples >> sampleXML [
	^ XMLDOMParser parse: self sampleXMLString.
]

{ #category : #accessing }
TrackPointExamples >> sampleXMLString [
	"on ground, not moving"

	"XMLDOMParser parse: TrackPointExamples new sampleXMLString"

	^ '<?xml version="1.0" encoding="utf-8"?>
<kml xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>KML Export 7/1/2020 10:58:04 PM</name>
    <Style id="style_emergency">
      <IconStyle>
        <colorMode>normal</colorMode>
        <Icon>
          <href>http://maps.google.com/mapfiles/kml/shapes/caution.png</href>
        </Icon>
      </IconStyle>
      <BalloonStyle>
        <text>&lt;table&gt;&lt;tr&gt;&lt;td&gt;Id&lt;/td&gt;&lt;td&gt; $[Id] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Time&lt;/td&gt;&lt;td&gt; $[Time] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Time UTC&lt;/td&gt;&lt;td&gt; $[Time UTC] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Name&lt;/td&gt;&lt;td&gt; $[Name] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Map Display Name&lt;/td&gt;&lt;td&gt; $[Map Display Name] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Device Type&lt;/td&gt;&lt;td&gt; $[Device Type] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;IMEI&lt;/td&gt;&lt;td&gt; $[IMEI] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Incident Id&lt;/td&gt;&lt;td&gt; $[Incident Id] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Latitude&lt;/td&gt;&lt;td&gt; $[Latitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Longitude&lt;/td&gt;&lt;td&gt; $[Longitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Elevation&lt;/td&gt;&lt;td&gt; $[Elevation] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Velocity&lt;/td&gt;&lt;td&gt; $[Velocity] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Course&lt;/td&gt;&lt;td&gt; $[Course] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Valid GPS Fix&lt;/td&gt;&lt;td&gt; $[Valid GPS Fix] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;In Emergency&lt;/td&gt;&lt;td&gt; $[In Emergency] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Text&lt;/td&gt;&lt;td&gt; $[Text] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Event&lt;/td&gt;&lt;td&gt; $[Event] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;SpatialRefSystem&lt;/td&gt;&lt;td&gt; $[SpatialRefSystem] &lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;</text>
      </BalloonStyle>
    </Style>
    <Style id="style_18475">
      <IconStyle>
        <color>ffc6964f</color>
        <colorMode>normal</colorMode>
        <Icon>
          <href>http://maps.google.com/mapfiles/kml/paddle/wht-blank.png</href>
        </Icon>
      </IconStyle>
      <BalloonStyle>
        <text>&lt;table&gt;&lt;tr&gt;&lt;td&gt;Id&lt;/td&gt;&lt;td&gt; $[Id] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Time&lt;/td&gt;&lt;td&gt; $[Time] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Time UTC&lt;/td&gt;&lt;td&gt; $[Time UTC] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Name&lt;/td&gt;&lt;td&gt; $[Name] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Map Display Name&lt;/td&gt;&lt;td&gt; $[Map Display Name] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Device Type&lt;/td&gt;&lt;td&gt; $[Device Type] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;IMEI&lt;/td&gt;&lt;td&gt; $[IMEI] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Incident Id&lt;/td&gt;&lt;td&gt; $[Incident Id] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Latitude&lt;/td&gt;&lt;td&gt; $[Latitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Longitude&lt;/td&gt;&lt;td&gt; $[Longitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Elevation&lt;/td&gt;&lt;td&gt; $[Elevation] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Velocity&lt;/td&gt;&lt;td&gt; $[Velocity] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Course&lt;/td&gt;&lt;td&gt; $[Course] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Valid GPS Fix&lt;/td&gt;&lt;td&gt; $[Valid GPS Fix] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;In Emergency&lt;/td&gt;&lt;td&gt; $[In Emergency] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Text&lt;/td&gt;&lt;td&gt; $[Text] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Event&lt;/td&gt;&lt;td&gt; $[Event] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;SpatialRefSystem&lt;/td&gt;&lt;td&gt; $[SpatialRefSystem] &lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;</text>
      </BalloonStyle>
    </Style>
    <Style id="waypointstyle_18475">
      <IconStyle>
        <color>ffc6964f</color>
        <colorMode>normal</colorMode>
        <Icon>
          <href>http://maps.google.com/mapfiles/kml/paddle/wht-blank.png</href>
        </Icon>
      </IconStyle>
      <BalloonStyle>
        <text>&lt;table&gt;&lt;tr&gt;&lt;td&gt;Time&lt;/td&gt;&lt;td&gt; $[Time] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Time UTC&lt;/td&gt;&lt;td&gt; $[Time UTC] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Latitude&lt;/td&gt;&lt;td&gt; $[Latitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Longitude&lt;/td&gt;&lt;td&gt; $[Longitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Text&lt;/td&gt;&lt;td&gt; $[Text] &lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;</text>
      </BalloonStyle>
    </Style>
    <Style id="linestyle_18475">
      <LineStyle>
        <color>ffc6964f</color>
        <colorMode>normal</colorMode>
        <width>1</width>
        <labelVisibility xmlns="http://www.google.com/kml/ext/2.2">false</labelVisibility>
      </LineStyle>
    </Style>
    <Folder>
      <name>Kurt Thams</name>
      <Placemark>
        <name>Kurt Thams</name>
        <visibility>true</visibility>
        <description/>
        <TimeStamp>
          <when>2020-07-01T01:25:45Z</when>
        </TimeStamp>
        <styleUrl>#style_18475</styleUrl>
        <ExtendedData>
          <Data name="Id">
            <value>408963418</value>
          </Data>
          <Data name="Time UTC">
            <value>7/1/2020 1:25:45 AM</value>
          </Data>
          <Data name="Time">
            <value>6/30/2020 6:25:45 PM</value>
          </Data>
          <Data name="Name">
            <value>Kurt Thams</value>
          </Data>
          <Data name="Map Display Name">
            <value>Kurt Thams</value>
          </Data>
          <Data name="Device Type">
            <value>inReach SE</value>
          </Data>
          <Data name="IMEI">
            <value>300434060605400</value>
          </Data>
          <Data name="Incident Id">
            <value/>
          </Data>
          <Data name="Latitude">
            <value>39.250598</value>
          </Data>
          <Data name="Longitude">
            <value>-114.883240</value>
          </Data>
          <Data name="Elevation">
            <value>1948.37 m from MSL</value>
          </Data>
          <Data name="Velocity">
            <value>0.0 km/h</value>
          </Data>
          <Data name="Course">
            <value>0.00 ° True</value>
          </Data>
          <Data name="Valid GPS Fix">
            <value>True</value>
          </Data>
          <Data name="In Emergency">
            <value>False</value>
          </Data>
          <Data name="Text">
            <value/>
          </Data>
          <Data name="Event">
            <value>Tracking interval received.</value>
          </Data>
          <Data name="SpatialRefSystem">
            <value>WGS84</value>
          </Data>
        </ExtendedData>
        <Point>
          <extrude>false</extrude>
          <altitudeMode>absolute</altitudeMode>
          <coordinates>-114.88324,39.250598,1948.37</coordinates>
        </Point>
      </Placemark>
      <Placemark>
        <name>Kurt Thams</name>
        <visibility>true</visibility>
        <description>Kurt Thams''s track log</description>
        <styleUrl>#linestyle_18475</styleUrl>
        <LineString>
          <tessellate>true</tessellate>
          <coordinates>-114.88324,39.250598,1948.37</coordinates>
        </LineString>
      </Placemark>
    </Folder>
  </Document>
</kml>'
]

{ #category : #accessing }
TrackPointExamples >> sampleXMLString2 [
	"somewhere else, on ground ?"
	^ '<?xml version="1.0" encoding="utf-8"?>
<kml xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>KML Export 7/2/2020 6:08:52 PM</name>
    <Style id="style_emergency">
      <IconStyle>
        <colorMode>normal</colorMode>
        <Icon>
          <href>http://maps.google.com/mapfiles/kml/shapes/caution.png</href>
        </Icon>
      </IconStyle>
      <BalloonStyle>
        <text>&lt;table&gt;&lt;tr&gt;&lt;td&gt;Id&lt;/td&gt;&lt;td&gt; $[Id] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Time&lt;/td&gt;&lt;td&gt; $[Time] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Time UTC&lt;/td&gt;&lt;td&gt; $[Time UTC] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Name&lt;/td&gt;&lt;td&gt; $[Name] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Map Display Name&lt;/td&gt;&lt;td&gt; $[Map Display Name] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Device Type&lt;/td&gt;&lt;td&gt; $[Device Type] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;IMEI&lt;/td&gt;&lt;td&gt; $[IMEI] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Incident Id&lt;/td&gt;&lt;td&gt; $[Incident Id] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Latitude&lt;/td&gt;&lt;td&gt; $[Latitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Longitude&lt;/td&gt;&lt;td&gt; $[Longitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Elevation&lt;/td&gt;&lt;td&gt; $[Elevation] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Velocity&lt;/td&gt;&lt;td&gt; $[Velocity] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Course&lt;/td&gt;&lt;td&gt; $[Course] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Valid GPS Fix&lt;/td&gt;&lt;td&gt; $[Valid GPS Fix] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;In Emergency&lt;/td&gt;&lt;td&gt; $[In Emergency] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Text&lt;/td&gt;&lt;td&gt; $[Text] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Event&lt;/td&gt;&lt;td&gt; $[Event] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;SpatialRefSystem&lt;/td&gt;&lt;td&gt; $[SpatialRefSystem] &lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;</text>
      </BalloonStyle>
    </Style>
    <Style id="style_18475">
      <IconStyle>
        <color>ffc6964f</color>
        <colorMode>normal</colorMode>
        <Icon>
          <href>http://maps.google.com/mapfiles/kml/paddle/wht-blank.png</href>
        </Icon>
      </IconStyle>
      <BalloonStyle>
        <text>&lt;table&gt;&lt;tr&gt;&lt;td&gt;Id&lt;/td&gt;&lt;td&gt; $[Id] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Time&lt;/td&gt;&lt;td&gt; $[Time] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Time UTC&lt;/td&gt;&lt;td&gt; $[Time UTC] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Name&lt;/td&gt;&lt;td&gt; $[Name] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Map Display Name&lt;/td&gt;&lt;td&gt; $[Map Display Name] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Device Type&lt;/td&gt;&lt;td&gt; $[Device Type] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;IMEI&lt;/td&gt;&lt;td&gt; $[IMEI] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Incident Id&lt;/td&gt;&lt;td&gt; $[Incident Id] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Latitude&lt;/td&gt;&lt;td&gt; $[Latitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Longitude&lt;/td&gt;&lt;td&gt; $[Longitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Elevation&lt;/td&gt;&lt;td&gt; $[Elevation] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Velocity&lt;/td&gt;&lt;td&gt; $[Velocity] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Course&lt;/td&gt;&lt;td&gt; $[Course] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Valid GPS Fix&lt;/td&gt;&lt;td&gt; $[Valid GPS Fix] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;In Emergency&lt;/td&gt;&lt;td&gt; $[In Emergency] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Text&lt;/td&gt;&lt;td&gt; $[Text] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Event&lt;/td&gt;&lt;td&gt; $[Event] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;SpatialRefSystem&lt;/td&gt;&lt;td&gt; $[SpatialRefSystem] &lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;</text>
      </BalloonStyle>
    </Style>
    <Style id="waypointstyle_18475">
      <IconStyle>
        <color>ffc6964f</color>
        <colorMode>normal</colorMode>
        <Icon>
          <href>http://maps.google.com/mapfiles/kml/paddle/wht-blank.png</href>
        </Icon>
      </IconStyle>
      <BalloonStyle>
        <text>&lt;table&gt;&lt;tr&gt;&lt;td&gt;Time&lt;/td&gt;&lt;td&gt; $[Time] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Time UTC&lt;/td&gt;&lt;td&gt; $[Time UTC] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Latitude&lt;/td&gt;&lt;td&gt; $[Latitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Longitude&lt;/td&gt;&lt;td&gt; $[Longitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Text&lt;/td&gt;&lt;td&gt; $[Text] &lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;</text>
      </BalloonStyle>
    </Style>
    <Style id="linestyle_18475">
      <LineStyle>
        <color>ffc6964f</color>
        <colorMode>normal</colorMode>
        <width>1</width>
        <labelVisibility xmlns="http://www.google.com/kml/ext/2.2">false</labelVisibility>
      </LineStyle>
    </Style>
    <Folder>
      <name>Kurt Thams</name>
      <Placemark>
        <name>Kurt Thams</name>
        <visibility>true</visibility>
        <description/>
        <TimeStamp>
          <when>2020-07-02T18:07:30Z</when>
        </TimeStamp>
        <styleUrl>#style_18475</styleUrl>
        <ExtendedData>
          <Data name="Id">
            <value>409358915</value>
          </Data>
          <Data name="Time UTC">
            <value>7/2/2020 6:07:30 PM</value>
          </Data>
          <Data name="Time">
            <value>7/2/2020 11:07:30 AM</value>
          </Data>
          <Data name="Name">
            <value>Kurt Thams</value>
          </Data>
          <Data name="Map Display Name">
            <value>Kurt Thams</value>
          </Data>
          <Data name="Device Type">
            <value>inReach SE</value>
          </Data>
          <Data name="IMEI">
            <value>300434060605400</value>
          </Data>
          <Data name="Incident Id">
            <value/>
          </Data>
          <Data name="Latitude">
            <value>39.478961</value>
          </Data>
          <Data name="Longitude">
            <value>-114.970680</value>
          </Data>
          <Data name="Elevation">
            <value>2979.65 m from MSL</value>
          </Data>
          <Data name="Velocity">
            <value>126.5 km/h</value>
          </Data>
          <Data name="Course">
            <value>292.50 ° True</value>
          </Data>
          <Data name="Valid GPS Fix">
            <value>True</value>
          </Data>
          <Data name="In Emergency">
            <value>False</value>
          </Data>
          <Data name="Text">
            <value/>
          </Data>
          <Data name="Event">
            <value>Tracking message received.</value>
          </Data>
          <Data name="SpatialRefSystem">
            <value>WGS84</value>
          </Data>
        </ExtendedData>
        <Point>
          <extrude>false</extrude>
          <altitudeMode>absolute</altitudeMode>
          <coordinates>-114.97068,39.478961,2979.65</coordinates>
        </Point>
      </Placemark>
      <Placemark>
        <name>Kurt Thams</name>
        <visibility>true</visibility>
        <description>Kurt Thams''s track log</description>
        <styleUrl>#linestyle_18475</styleUrl>
        <LineString>
          <tessellate>true</tessellate>
          <coordinates>-114.97068,39.478961,2979.65</coordinates>
        </LineString>
      </Placemark>
    </Folder>
  </Document>
</kml>'
]

{ #category : #accessing }
TrackPointExamples >> sampleXMLStringAloft [
	"somewhere up high"
	^ '<?xml version="1.0" encoding="utf-8"?>
<kml xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>KML Export 7/2/2020 9:26:23 PM</name>
    <Style id="style_emergency">
      <IconStyle>
        <colorMode>normal</colorMode>
        <Icon>
          <href>http://maps.google.com/mapfiles/kml/shapes/caution.png</href>
        </Icon>
      </IconStyle>
      <BalloonStyle>
        <text>&lt;table&gt;&lt;tr&gt;&lt;td&gt;Id&lt;/td&gt;&lt;td&gt; $[Id] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Time&lt;/td&gt;&lt;td&gt; $[Time] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Time UTC&lt;/td&gt;&lt;td&gt; $[Time UTC] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Name&lt;/td&gt;&lt;td&gt; $[Name] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Map Display Name&lt;/td&gt;&lt;td&gt; $[Map Display Name] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Device Type&lt;/td&gt;&lt;td&gt; $[Device Type] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;IMEI&lt;/td&gt;&lt;td&gt; $[IMEI] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Incident Id&lt;/td&gt;&lt;td&gt; $[Incident Id] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Latitude&lt;/td&gt;&lt;td&gt; $[Latitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Longitude&lt;/td&gt;&lt;td&gt; $[Longitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Elevation&lt;/td&gt;&lt;td&gt; $[Elevation] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Velocity&lt;/td&gt;&lt;td&gt; $[Velocity] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Course&lt;/td&gt;&lt;td&gt; $[Course] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Valid GPS Fix&lt;/td&gt;&lt;td&gt; $[Valid GPS Fix] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;In Emergency&lt;/td&gt;&lt;td&gt; $[In Emergency] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Text&lt;/td&gt;&lt;td&gt; $[Text] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Event&lt;/td&gt;&lt;td&gt; $[Event] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;SpatialRefSystem&lt;/td&gt;&lt;td&gt; $[SpatialRefSystem] &lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;</text>
      </BalloonStyle>
    </Style>
    <Style id="style_18475">
      <IconStyle>
        <color>ffc6964f</color>
        <colorMode>normal</colorMode>
        <Icon>
          <href>http://maps.google.com/mapfiles/kml/paddle/wht-blank.png</href>
        </Icon>
      </IconStyle>
      <BalloonStyle>
        <text>&lt;table&gt;&lt;tr&gt;&lt;td&gt;Id&lt;/td&gt;&lt;td&gt; $[Id] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Time&lt;/td&gt;&lt;td&gt; $[Time] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Time UTC&lt;/td&gt;&lt;td&gt; $[Time UTC] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Name&lt;/td&gt;&lt;td&gt; $[Name] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Map Display Name&lt;/td&gt;&lt;td&gt; $[Map Display Name] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Device Type&lt;/td&gt;&lt;td&gt; $[Device Type] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;IMEI&lt;/td&gt;&lt;td&gt; $[IMEI] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Incident Id&lt;/td&gt;&lt;td&gt; $[Incident Id] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Latitude&lt;/td&gt;&lt;td&gt; $[Latitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Longitude&lt;/td&gt;&lt;td&gt; $[Longitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Elevation&lt;/td&gt;&lt;td&gt; $[Elevation] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Velocity&lt;/td&gt;&lt;td&gt; $[Velocity] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Course&lt;/td&gt;&lt;td&gt; $[Course] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Valid GPS Fix&lt;/td&gt;&lt;td&gt; $[Valid GPS Fix] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;In Emergency&lt;/td&gt;&lt;td&gt; $[In Emergency] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Text&lt;/td&gt;&lt;td&gt; $[Text] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Event&lt;/td&gt;&lt;td&gt; $[Event] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;SpatialRefSystem&lt;/td&gt;&lt;td&gt; $[SpatialRefSystem] &lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;</text>
      </BalloonStyle>
    </Style>
    <Style id="waypointstyle_18475">
      <IconStyle>
        <color>ffc6964f</color>
        <colorMode>normal</colorMode>
        <Icon>
          <href>http://maps.google.com/mapfiles/kml/paddle/wht-blank.png</href>
        </Icon>
      </IconStyle>
      <BalloonStyle>
        <text>&lt;table&gt;&lt;tr&gt;&lt;td&gt;Time&lt;/td&gt;&lt;td&gt; $[Time] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Time UTC&lt;/td&gt;&lt;td&gt; $[Time UTC] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Latitude&lt;/td&gt;&lt;td&gt; $[Latitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Longitude&lt;/td&gt;&lt;td&gt; $[Longitude] &lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Text&lt;/td&gt;&lt;td&gt; $[Text] &lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;</text>
      </BalloonStyle>
    </Style>
    <Style id="linestyle_18475">
      <LineStyle>
        <color>ffc6964f</color>
        <colorMode>normal</colorMode>
        <width>1</width>
        <labelVisibility xmlns="http://www.google.com/kml/ext/2.2">false</labelVisibility>
      </LineStyle>
    </Style>
    <Folder>
      <name>Kurt Thams</name>
      <Placemark>
        <name>Kurt Thams</name>
        <visibility>true</visibility>
        <description/>
        <TimeStamp>
          <when>2020-07-02T21:25:45Z</when>
        </TimeStamp>
        <styleUrl>#style_18475</styleUrl>
        <ExtendedData>
          <Data name="Id">
            <value>409409840</value>
          </Data>
          <Data name="Time UTC">
            <value>7/2/2020 9:25:45 PM</value>
          </Data>
          <Data name="Time">
            <value>7/2/2020 2:25:45 PM</value>
          </Data>
          <Data name="Name">
            <value>Kurt Thams</value>
          </Data>
          <Data name="Map Display Name">
            <value>Kurt Thams</value>
          </Data>
          <Data name="Device Type">
            <value>inReach SE</value>
          </Data>
          <Data name="IMEI">
            <value>300434060605400</value>
          </Data>
          <Data name="Incident Id">
            <value/>
          </Data>
          <Data name="Latitude">
            <value>39.313556</value>
          </Data>
          <Data name="Longitude">
            <value>-116.702613</value>
          </Data>
          <Data name="Elevation">
            <value>5007.15 m from MSL</value>
          </Data>
          <Data name="Velocity">
            <value>177.7 km/h</value>
          </Data>
          <Data name="Course">
            <value>180.00 ° True</value>
          </Data>
          <Data name="Valid GPS Fix">
            <value>True</value>
          </Data>
          <Data name="In Emergency">
            <value>False</value>
          </Data>
          <Data name="Text">
            <value/>
          </Data>
          <Data name="Event">
            <value>Tracking message received.</value>
          </Data>
          <Data name="SpatialRefSystem">
            <value>WGS84</value>
          </Data>
        </ExtendedData>
        <Point>
          <extrude>false</extrude>
          <altitudeMode>absolute</altitudeMode>
          <coordinates>-116.702613,39.313556,5007.15</coordinates>
        </Point>
      </Placemark>
      <Placemark>
        <name>Kurt Thams</name>
        <visibility>true</visibility>
        <description>Kurt Thams''s track log</description>
        <styleUrl>#linestyle_18475</styleUrl>
        <LineString>
          <tessellate>true</tessellate>
          <coordinates>-116.702613,39.313556,5007.15</coordinates>
        </LineString>
      </Placemark>
    </Folder>
  </Document>
</kml>'
]

{ #category : #accessing }
TrackPointExamples >> timeUTC [
	<gtExample>

	| a |
	a := TrackPoint new xmlDocNode: self sampleXML.
	self assert: (a timeUTC) equals: (DateAndTime year: 2020 month: 7 day: 1 hour: 1 minute: 25 second: 45 offset: ((TimeZone abbreviated: 'UTC') offset)).
	^self
]

{ #category : #examples }
TrackPointExamples >> unmovedDifferentDatapoint [
	<gtExample>
	<description: 'Two data points taken at different times should show same location'>
	| a b |
	a := TrackPoint string: self sampleUnmoved1.
	b := TrackPoint string: self sampleUnmoved2.

	self assert: (a differentPosition: b) not.
	self assert: (a differentSample: b).
	^self

]
