"
A baseline for XML writer for Pharo (https://github.com/pharo-contributions/XML-XMLWriter)
"
Class {
	#name : #BaselineOfXMLWriter,
	#superclass : #BaselineOf,
	#category : #BaselineOfXMLWriter
}

{ #category : #baselines }
BaselineOfXMLWriter >> baseline: spec [
	<baseline>
	
	spec 
		for: #common
		do: [ 
			spec blessing: #baseline.
			
			"Projects"			
			spec
				baseline: 'OrderPreservingDictionary'
				with: [ spec
						repository: 'github://pharo-contributions/OrderPreservingDictionary';
						loads: 'Core' ].
								
			"Packages"
			spec 
				package: 'XML-Writer-Core' with: [ spec requires: 'OrderPreservingDictionary' ];
				package: 'XML-Writer-Tests' with: [ spec requires: 'XML-Writer-Core' ].
			
			
			"Groups"
			spec
				group: 'Core' with: #('XML-Writer-Core');
				group: 'Tests' with: #('XML-Writer-Tests'); 
				group: 'default' with: #('Core' 'Tests');
				group: 'all' with: #('all')	].


	"load gemstone compatibility methods"
	spec
		for: #'gemstone'
		do: [
			spec
				package: 'XML-Writer-Core'
				with: [ spec includes: 'XML-Writer-GemstoneCompatibility' ].
			spec
				package: 'XML-Writer-GemstoneCompatibility'
				with: [ spec requires: 'XML-Writer-Core' ].].
]
