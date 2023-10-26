"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestXMLWriterTests,
	#superclass : #PackageManifest,
	#category : #'XML-Writer-Tests-Manifest'
}

{ #category : #'code-critics' }
ManifestXMLWriterTests class >> ruleDetectContainsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#XMLWriterRecordingFormatterProxy #receivedNextAll:with: #false)) #'2023-10-26T02:25:37.729304+02:00') )
]

{ #category : #'code-critics' }
ManifestXMLWriterTests class >> ruleLiteralArrayContainsSuspiciousTrueFalseOrNilRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMetaclassDefinition #(#'ManifestXMLWriterTests class' #ManifestXMLWriterTests)) #'2023-10-26T02:26:03.499966+02:00') )
]
