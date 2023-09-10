"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestBaselineOfXMLWriter,
	#superclass : #PackageManifest,
	#category : #'BaselineOfXMLWriter-Manifest'
}

{ #category : #'code-critics' }
ManifestBaselineOfXMLWriter class >> ruleClassNotReferencedRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGClassDefinition #(#BaselineOfXMLWriter)) #'2023-09-10T12:19:48.812+02:00') )
]
