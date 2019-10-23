"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestXMLWriterCore,
	#superclass : #PackageManifest,
	#category : #'XML-Writer-Core-Manifest'
}

{ #category : #'code-critics' }
ManifestXMLWriterCore class >> ruleRBLongMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#XMLElementDeclarationWriter #writeContentModel #false)) #'2019-10-24T00:29:11.918915+02:00') #(#(#RGMethodDefinition #(#XMLPIWriter #writeData #false)) #'2019-10-24T00:31:19.650756+02:00') )
]

{ #category : #'code-critics' }
ManifestXMLWriterCore class >> ruleRBSearchingLiteralRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#XMLPIWriter #writeData #false)) #'2019-10-24T00:31:34.250287+02:00') )
]

{ #category : #'code-critics' }
ManifestXMLWriterCore class >> ruleRBTempsReadBeforeWrittenRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#XMLElementDeclarationWriter #writeContentModel #false)) #'2019-10-24T00:28:43.157475+02:00') #(#(#RGMethodDefinition #(#XMLAttributeDeclarationWriter #writeType #false)) #'2019-10-24T00:29:33.688891+02:00') #(#(#RGMethodDefinition #(#XMLPIWriter #writeData #false)) #'2019-10-24T00:31:13.213623+02:00') #(#(#RGMethodDefinition #(#XMLWriter #activeMarkupWriterWhileChangingDo: #false)) #'2019-10-24T00:33:42.360429+02:00') )
]
