"
'!!! Current loading expressions and key development history

- Version 2.3 - 2013-11-22 Monty's Enhancements
[[[ 
	(ConfigurationOfXMLWriter project version: ''2.3'') load
]]]

- Version 2.2.1 - 2013-07-10 Merged fix of Camillo for fileSystem interaction.
[[[ 
	(ConfigurationOfXMLWriter project version: ''2.2.1'') load
]]]

- Version 2.2.0 - Migrated to PharoExtras
[[[ 	
	(ConfigurationOfXMLWriter project version: ''2.2.0'') load
]]]
	
- Version 2.1.0 Introduced tests and symbolic configurations

[[[ 
	(ConfigurationOfXMLWriter project version: ''2.1.0'') load
	(ConfigurationOfXMLWriter project version: ''2.1.0'') record loadDirective
]]]

- Version 2.0.0 After SmalltalkHub Migration and the introduction of configuration in other projects

- Pre-smalltalkhub migration
[[[
(ConfigurationOfXMLWriter project version: ''1.0.5'') load
]]]
'
"
Class {
	#name : #ConfigurationOfXMLWriter,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#classVars : [
		'LastVersionLoad'
	],
	#category : #ConfigurationOfXMLWriter
}

{ #category : #private }
ConfigurationOfXMLWriter class >> bootstrapPackage: aString from: aPath [ 
	| repository version |
	repository := MCHttpRepository
				location: aPath
				user: ''
				password: ''.
	repository
		versionReaderForFileNamed: aString , '.mcz'
		do: [:reader | 
			version := reader version.
			version load.
			version workingCopy repositoryGroup addRepository: repository]
]

{ #category : #catalog }
ConfigurationOfXMLWriter class >> catalogChangeLog [

^ '
- Version 2.3 - 2013-11-22 Monty''s Enhancements
[[[ 
	(ConfigurationOfXMLWriter project version: ''2.3'') load
]]]

- Version 2.2.1 - 2013-07-10 Merged fix of Camillo for fileSystem interaction.
[[[ 
	(ConfigurationOfXMLWriter project version: ''2.2.1'') load
]]]

- Version 2.2.0 - Migrated to PharoExtras
[[[ 	
	(ConfigurationOfXMLWriter project version: ''2.2.0'') load
]]]
	
- Version 2.1.0 Introduced tests and symbolic configurations
[[[ 
	(ConfigurationOfXMLWriter project version: ''2.1.0'') load
	(ConfigurationOfXMLWriter project version: ''2.1.0'') record loadDirective
]]]

- Version 2.0.0 After SmalltalkHub Migration and the introduction of configuration in other projects
- Pre-smalltalkhub migration
[[[
	(ConfigurationOfXMLWriter project version: ''1.0.5'') load
]]]
'
]

{ #category : #catalog }
ConfigurationOfXMLWriter class >> catalogDescription [

	^ 'XMLWriter allows you to generate well-formed XML documents using an API based on Seaside''s canvas and tag brushes so all tags will be nested properly and not left unclosed.'

]

{ #category : #catalog }
ConfigurationOfXMLWriter class >> catalogKeyClassesAndExample [

^ 'The main entry point is the class ==XMLWriter==.

Here are examples of the API 
[[[ 
	| writer |
	writer := XMLWriter new.
	writer tag
		name: ''emptyTag'';
		attributeAt: ''a'' put: ''one'';
		write.
]]]
	
[[[
	| writer |
	writer := XMLWriter new.
	writer
		enablePrettyPrinting;
		xml;
		comment: ''an example''.
	writer tag
		name: ''example:user'';
		xmlnsAt: ''example'' put: ''urn://example'';
		with: [
			writer
				tag: ''username'' with: ''jsmith'';
				tag: ''real-name'' with: ''John Smith'';
				tag: ''age'' with: ''25'';
				tag: ''id'' with: ''101''] 
]]]
'
]

{ #category : #catalog }
ConfigurationOfXMLWriter class >> catalogKeywords [

	^ #( XML HTML XHTML writer web markup document )
					

]

{ #category : #catalog }
ConfigurationOfXMLWriter class >> catalogLicense [
	^ 'The MIT License (MIT)

Copyright (c) 2018 PharoExtras Team.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.'
]

{ #category : #private }
ConfigurationOfXMLWriter class >> ensureMetacello [
	"Bootstrap Gofer (if necessary), load latest mcz file for ConfigurationOfMetacello (using old 
	 Gofer API), then load the latest version of Metacello itself."

	Smalltalk at: #MetacelloProject ifAbsent: [ | error |
		"list of repositories to try, in case primary repository is not accessible"
		(Array 
			with: 'http://www.squeaksource.com/MetacelloRepository' 
			with: 'http://seaside.gemstone.com/ss/metacello') do: [:repositoryUrl |
				([
					Smalltalk at: #Gofer ifAbsent: [
					"Current version of Gofer from which to bootstrap - as of 1.0-beta.21"
						self bootstrapPackage: 'Gofer-Core-lr.115' from: repositoryUrl ].
					Smalltalk at: #Gofer ifPresent: [:goferClass | | gofer |
						gofer := goferClass new
							url: repositoryUrl;
							yourself.
						[ gofer addPackage: 'ConfigurationOfMetacello' ] on: Warning do: [:ex | ex resume ].
						gofer load ]]
							on: Error
							do: [ :ex |
								error := ex.
								Transcript 
									cr; 
									show: 'failed ensureMetacello: ';
									show: ex description printString;
									show: '...retrying'.
								"try again"
								ex return: nil ]) ~~ nil
					ifTrue: [
						"load 'default' group of Metacello"
						(Smalltalk at: #ConfigurationOfMetacello) perform: #load.
						^self ]].
		"shouldn't get here unless the load failed ... throw an error"
		self error: 'retry with alternate repository failed: ', error description printString ]
]

{ #category : #'metacello tool support' }
ConfigurationOfXMLWriter class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #'metacello tool support' }
ConfigurationOfXMLWriter class >> lastMetacelloVersionLoad [
	"Answer the last version loaded and the list of packages loaded for that version."

	LastVersionLoad == nil ifTrue: [ LastVersionLoad := nil -> 'default' ].
	^LastVersionLoad
]

{ #category : #loading }
ConfigurationOfXMLWriter class >> load [
	"self load"

	^self project latestVersion load
]

{ #category : #'metacello tool support' }
ConfigurationOfXMLWriter class >> metacelloVersion: versionString loads: anArrayOrString [
	"Stash the last version loaded and the list of packages loaded for that version. The list
	 of packages will be used by the tools when doing 'Load Package Version'"

	LastVersionLoad := versionString -> anArrayOrString
]

{ #category : #accessing }
ConfigurationOfXMLWriter class >> project [

	^self new project
]

{ #category : #'unloading Metacello' }
ConfigurationOfXMLWriter class >> unloadMetacello [

	Smalltalk at: #ConfigurationOfMetacello ifPresent: [:cls | cls unloadMetacello ]
]

{ #category : #'development support' }
ConfigurationOfXMLWriter class >> validate [
	"Check the configuration for Errors, Critical Warnings, and Warnings (see class comment for MetacelloMCVersionValidator for more information). 
	Errors identify specification issues that will result in unexpected behaviour when you load the configuration. 
	Critical Warnings identify specification issues that may result in unexpected behavior when you load the configuration.
	Warnings identify specification issues that are technically correct, but are worth take a look at."

	"self validate"

	<apiDocumentation>
	self ensureMetacello.
	^ ((Smalltalk at: #MetacelloToolBox) validateConfiguration: self debug: #() recurse: false) explore
]

{ #category : #baselines }
ConfigurationOfXMLWriter >> baseline100: spec [ 
	<version: '1.0-baseline'>
	
	spec for: #common do: [
		spec
			blessing: #baseline;
			repository: 'http://www.squeaksource.com/XMLWriter'.

		spec 
			package: 'Collections-CharacterMap' with: [
				spec repository: 'http://www.squeaksource.com/CharacterMap'];
			package: 'XML-Writer' with: [spec requires: 'Collections-CharacterMap'].

		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('XML-Writer');
			group: 'Tests' with: #()].
]

{ #category : #baselines }
ConfigurationOfXMLWriter >> baseline101: spec [ 
	<version: '1.0.1-baseline'>
	
	spec for: #common do: [
		spec
			blessing: #baseline;
			repository: 'http://www.squeaksource.com/XMLWriter'.

		spec
			package: 'Collections-OrderPreservingDictionary' with: [
				spec repository: 'http://www.squeaksource.com/OrderPreservingDict'];
			package: 'Collections-CharacterMap' with: [
				spec repository: 'http://www.squeaksource.com/CharacterMap'];
			package: 'XML-Writer' with: [
				spec requires: #('Collections-OrderPreservingDictionary' 'Collections-CharacterMap')].

		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('XML-Writer')].
]

{ #category : #baselines }
ConfigurationOfXMLWriter >> baseline104: spec [ 
	<version: '1.0.4-baseline'>
	
	spec for: #common do: [
		spec
			blessing: #baseline;
			repository: 'http://www.squeaksource.com/XMLWriter'.

		spec
			package: 'Collections-OrderPreservingDictionary' with: [
				spec repository: 'http://www.squeaksource.com/OrderPreservingDict'];
			package: 'XML-Writer' with: [
				spec requires: #('Collections-OrderPreservingDictionary')].

		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('XML-Writer')].
		
	spec for: #gemstone do: [
		spec
			package: 'Collections-CharacterSet'.
		spec 
			package: 'XML-Writer' with:[spec requires: #('Collections-CharacterSet')]]
]

{ #category : #baselines }
ConfigurationOfXMLWriter >> baseline105: spec [
	<version: '1.0.5-baseline'>
	spec for: #common do: [ 
		spec
			blessing: #baseline;
			repository: 'http://www.squeaksource.com/XMLWriter'.
		spec
			package: 'Collections-OrderPreservingDictionary' with: [ 
				spec repository: 'http://www.squeaksource.com/OrderPreservingDict' ];
			package: 'Collections-Support';
			package: 'XML-Writer' with: [ 
				spec requires: #('Collections-Support' 'Collections-OrderPreservingDictionary') ].
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('XML-Writer');
			group: 'Tests' with: #() ].
		
	spec for: #squeakCommon do: [ 
		spec package: 'Collections-Support' with: [ 
			spec repository: 'http://www.squeaksource.com/Pharo' ] ].
	
	spec for: #gemstone do: [ 
		spec
			package: 'Collections-Support' with: [ 
				spec
					file: 'Collections-Support.g';
					repository: 'http://seaside.gemstone.com/ss/XMLSupport' ];
			package: 'Collections-Tests-Support' with: [ 
				spec
					file: 'Collections-Tests-Support.g';
					requires: 'Collections-Support';
					repository: 'http://seaside.gemstone.com/ss/XMLSupport' ].
		spec
			group: 'Tests' with: #('Collections-Tests-Support') ]
]

{ #category : #baselines }
ConfigurationOfXMLWriter >> baseline200: spec [
	<version: '2.0.0-baseline'>

	spec for: #common do: [ 
		spec
			blessing: #baseline;
			description: 'Migrated to SmalltalkHub and taking into account new configurations of subcomponents';
			repository: 'http://smalltalkhub.com/mc/Pharo/XMLWriter/main'.
				
		"Does not work without a className: specification
		
		spec project: 'OrderPreservingDictionary' with: [
			spec 
				versionString: #stable; 
				loads: #('Core'); 
				repository: 'http://smalltalkhub.com/mc/Pharo/OrderPreservingDictionary/main'].
		spec package: 'XML-Writer' with: [ spec requires: #('OrderPreservingDictionary') ]."
			
		spec project: 'OrderPreservingDictionary' with: [
			spec 
				className: 'ConfigurationOfOrderPreservingDictionary';
				versionString: #stable; 
				loads: #('Core'); 
				repository: 'http://smalltalkhub.com/mc/Pharo/OrderPreservingDictionary/main'].	
				
		spec package: 'XML-Writer' with: [spec requires: 'OrderPreservingDictionary']. 
			
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('XML-Writer');
			group: 'Tests' with: #() ].
	
	
	
	"I removed it because it loads an old version of the pckage and this is a nonsense"	
	spec for: #squeakCommon do: [ 
		spec package: 'Collections-Support' with: [ 
			spec repository: 'http://ss3.gemstone.com/ss/Pharo20' ] ].
	
	
	
	
	spec for: #gemstone do: [ 
		spec
			package: 'Collections-Support' with: [ 
				spec
					file: 'Collections-Support.g';
					repository: 'http://seaside.gemstone.com/ss/XMLSupport' ];
			package: 'Collections-Tests-Support' with: [ 
				spec
					file: 'Collections-Tests-Support.g';
					requires: 'Collections-Support';
					repository: 'http://seaside.gemstone.com/ss/XMLSupport' ].
		spec
			group: 'Tests' with: #('Collections-Tests-Support') ]
]

{ #category : #baselines }
ConfigurationOfXMLWriter >> baseline210: spec [
	<version: '2.1.0-baseline'>

	spec for: #common do: [ 
		spec
			blessing: #baseline;
			description: 'Adding a test package';
			repository: 'http://smalltalkhub.com/mc/Pharo/XMLWriter/main'.
				
		spec project: 'OrderPreservingDictionary' with: [
			spec 
				className: 'ConfigurationOfOrderPreservingDictionary';
				versionString: #stable; 
				loads: #('Core'); 
				repository: 'http://smalltalkhub.com/mc/Pharo/OrderPreservingDictionary/main'].	
				
		spec package: 'XML-Writer-Core' with: [spec requires: 'OrderPreservingDictionary']. 
		spec package: 'XML-Writer-Tests' with: [spec requires: 'XML-Writer-Core']. 
		
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('XML-Writer-Core');
			group: 'Tests' with: #('XML-Writer-Tests')].
	
	
	"Can only work for Pharo1.4 and 2.0.
	To be changed when pharo will be managed on SmalltalkHub"
		
	spec for: #squeakCommon do: [ 
		spec package: 'Collections-Support' with: [ 
			spec repository: 'http://ss3.gemstone.com/ss/Pharo20' ] ].
	
	
	"I did not touch this part because Ido not know it. On Pharo XMLWriter has its own repository"
	spec for: #gemstone do: [ 
		spec
			package: 'Collections-Support' with: [ 
				spec
					file: 'Collections-Support.g';
					repository: 'http://seaside.gemstone.com/ss/XMLSupport' ];
			package: 'Collections-Tests-Support' with: [ 
				spec
					file: 'Collections-Tests-Support.g';
					requires: 'Collections-Support';
					repository: 'http://seaside.gemstone.com/ss/XMLSupport' ].
		spec
			group: 'Tests' with: #('Collections-Tests-Support') ]
]

{ #category : #baselines }
ConfigurationOfXMLWriter >> baseline220: spec [
	<version: '2.2.0-baseline'>
	spec
		for: #common
		do: [ 
			spec
				blessing: #baseline;
				description: 'Moving to PharoExtras';
				repository: 'http://smalltalkhub.com/mc/PharoExtras/XMLWriter/main'.
			spec
				project: 'OrderPreservingDictionary'
				with: [ 
					spec
						className: 'ConfigurationOfOrderPreservingDictionary';
						versionString: #stable;
						loads: #('Core');
						repository: 'http://smalltalkhub.com/mc/PharoExtras/OrderPreservingDictionary/main' ].
			spec package: 'XML-Writer-Core' with: [ spec requires: 'OrderPreservingDictionary' ].
			spec package: 'XML-Writer-Tests' with: [ spec requires: 'XML-Writer-Core' ].
			spec
				group: 'default' with: #('Core' 'Tests');
				group: 'Core' with: #('XML-Writer-Core');
				group: 'Tests' with: #('XML-Writer-Tests')	"default by default is equivalent to loading 'ALL' the packages still we added explicitly Tests to be loaded" ].	"Can only work for Pharo1.4 and 2.0.
	To be changed when pharo will be managed on SmalltalkHub"
	spec
		for: #squeakCommon
		do: [ spec package: 'Collections-Support' with: [ spec repository: 'http://ss3.gemtalksystems.com/ss/Pharo20' ] ].	"I did not touch this part because Ido not know it. On Pharo XMLWriter has its own repository"
	spec
		for: #gemstone
		do: [ 
			spec
				package: 'Collections-Support'
					with: [ 
							spec
								file: 'Collections-Support.g';
								repository: 'http://seaside.gemtalksystems.com/ss/XMLSupport' ];
				package: 'Collections-Tests-Support'
					with: [ 
							spec
								file: 'Collections-Tests-Support.g';
								requires: 'Collections-Support';
								repository: 'http://seaside.gemtalksystems.com/ss/XMLSupport' ].
			spec group: 'Tests' with: #('Collections-Tests-Support') ]
]

{ #category : #baselines }
ConfigurationOfXMLWriter >> baseline231: spec [
	<version: '2.3.1-baseline'>
	spec
		for: #common
		do: [ 
			spec
				blessing: #baseline;
				description: 'Moving to PharoExtras';
				repository: 'http://smalltalkhub.com/mc/PharoExtras/XMLWriter/main'.
			spec
				project: 'OrderPreservingDictionary'
				with: [ 
					spec
						className: 'ConfigurationOfOrderPreservingDictionary';
						versionString: #stable;
						loads: #('Core');
						repository: 'http://smalltalkhub.com/mc/PharoExtras/OrderPreservingDictionary/main' ].
			spec package: 'XML-Writer-Core' with: [ spec requires: 'OrderPreservingDictionary' ].
			spec package: 'XML-Writer-Tests' with: [ spec requires: 'XML-Writer-Core' ].
			spec
				group: 'default' with: #('Core' 'Tests');
				group: 'Core' with: #('XML-Writer-Core');
				group: 'Tests' with: #('XML-Writer-Tests')	"default by default is equivalent to loading 'ALL' the packages still we added explicitly Tests to be loaded" ].	"Can only work for Pharo1.4 and 2.0.
	To be changed when pharo will be managed on SmalltalkHub"
	spec
		for: #squeak
		do: [ spec package: 'Collections-Support' with: [ spec repository: 'http://ss3.gemtalksystems.com/ss/Pharo20' ] ].	"I did not touch this part because Ido not know it. On Pharo XMLWriter has its own repository"
	spec
		for: #gemstone
		do: [ 
			spec
				package: 'Collections-Support'
					with: [ 
							spec
								file: 'Collections-Support.g';
								repository: 'http://seaside.gemtalksystems.com/ss/XMLSupport' ];
				package: 'Collections-Tests-Support'
					with: [ 
							spec
								file: 'Collections-Tests-Support.g';
								requires: 'Collections-Support';
								repository: 'http://seaside.gemtalksystems.com/ss/XMLSupport' ].
			spec group: 'Tests' with: #('Collections-Tests-Support') ]
]

{ #category : #baselines }
ConfigurationOfXMLWriter >> baseline243: spec [
	<version: '2.4.3-baseline'>
	spec
		for: #common
		do: [ 
			spec
				blessing: #baseline;
				description: 'Moving to PharoExtras';
				repository: 'http://smalltalkhub.com/mc/PharoExtras/XMLWriter/main'.
			spec
				project: 'OrderPreservingDictionary'
				with: [ 
					spec
						className: 'ConfigurationOfOrderPreservingDictionary';
						versionString: #stable;
						loads: #('Core');
						repository: 'http://smalltalkhub.com/mc/PharoExtras/OrderPreservingDictionary/main' ].
			spec package: 'XML-Writer-Core' with: [ spec requires: 'OrderPreservingDictionary' ].
			spec package: 'XML-Writer-Tests' with: [ spec requires: 'XML-Writer-Core' ].
			spec
				group: 'default' with: #('Core' 'Tests');
				group: 'Core' with: #('XML-Writer-Core');
				group: 'Tests' with: #('XML-Writer-Tests')].	
	spec
		for: #gemstone
		do: [ 
			spec
				package: 'Collections-Support'
					with: [ 
							spec
								file: 'Collections-Support.g';
								repository: 'http://seaside.gemtalksystems.com/ss/XMLSupport' ];
				package: 'Collections-Tests-Support'
					with: [ 
							spec
								file: 'Collections-Tests-Support.g';
								requires: 'Collections-Support';
								repository: 'http://seaside.gemtalksystems.com/ss/XMLSupport' ].
			spec group: 'Tests' with: #('Collections-Tests-Support').
			"moved from version methods"
			spec
				package: 'Collections-Support' with: 'Collections-Support.g-OttoBehrens.45';
				package: 'Collections-Tests-Support' with: 'Collections-Tests-Support.g-OttoBehrens.3' ] 
]

{ #category : #baselines }
ConfigurationOfXMLWriter >> baseline250: spec [
	<version: '2.5.0-baseline'>

	"this is the new default baseline others inherit from"
	spec
		for: #common
		do: [ 
			spec
				blessing: #baseline;
				description: 'new standard baseline';
				repository: 'http://smalltalkhub.com/mc/PharoExtras/XMLWriter/main'.
			spec
				project: 'OrderPreservingDictionary'
				with: [ 
					spec
						className: 'ConfigurationOfOrderPreservingDictionary';
						versionString: #stable;
						loads: #('Core');
						repository: 'http://smalltalkhub.com/mc/PharoExtras/OrderPreservingDictionary/main' ].
			spec package: 'XML-Writer-Core' with: [ spec requires: 'OrderPreservingDictionary' ].
			spec package: 'XML-Writer-Tests' with: [ spec requires: 'XML-Writer-Core' ].
			spec
				group: 'default' with: #('Core' 'Tests');
				group: 'Core' with: #('XML-Writer-Core');
				group: 'Tests' with: #('XML-Writer-Tests') ].

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

{ #category : #baselines }
ConfigurationOfXMLWriter >> baseline251: spec [ 
		<version: '2.5.1-baseline' imports: #('2.5.0-baseline')>

		spec for: #gemstone do: [
			spec blessing: #baseline.
			spec
				package: 'XML-Writer-GemstoneCompatibility'
				with: 'XML-Writer-GemstoneCompatibility-monty.2'. ].
]

{ #category : #baselines }
ConfigurationOfXMLWriter >> baseline267: spec [ 
		<version: '2.6.7-baseline' imports: #('2.5.0-baseline')>

		spec for: #gemstone do: [
			spec blessing: #baseline.
			spec
				package: 'XML-Writer-GemstoneCompatibility'
				with: 'XML-Writer-GemstoneCompatibility-monty.3'. ].
]

{ #category : #baselines }
ConfigurationOfXMLWriter >> baseline270: spec [ 
		<version: '2.7.0-baseline' imports: #('2.5.0-baseline')>

		spec for: #gemstone do: [
			spec blessing: #baseline.
			spec
				package: 'XML-Writer-GemstoneCompatibility'
				with: 'XML-Writer-GemstoneCompatibility-monty.4'. ].
]

{ #category : #baselines }
ConfigurationOfXMLWriter >> baseline274: spec [ 
		<version: '2.7.4-baseline' imports: #('2.5.0-baseline')>

		spec for: #gemstone do: [
			spec blessing: #baseline.
			spec
				package: 'XML-Writer-GemstoneCompatibility'
				with: 'XML-Writer-GemstoneCompatibility-monty.5'. ].
]

{ #category : #baselines }
ConfigurationOfXMLWriter >> baseline281: spec [ 
		<version: '2.8.1-baseline' imports: #('2.5.0-baseline')>

		spec for: #gemstone do: [
			spec blessing: #baseline.
			spec
				package: 'XML-Writer-GemstoneCompatibility'
				with: 'XML-Writer-GemstoneCompatibility-monty.7'. ].
]

{ #category : #symbolic }
ConfigurationOfXMLWriter >> development: spec [
	<symbolicVersion: #'development'>

	spec for: #'common' version: '2.8.1-baseline'.

]

{ #category : #accessing }
ConfigurationOfXMLWriter >> project [

	^ project ifNil: [ | constructor |
		"Bootstrap Metacello if it is not already loaded"
		self class ensureMetacello.
		"Construct Metacello project"
		constructor := (Smalltalk at: #MetacelloVersionConstructor) on: self.
		project := constructor project.
		project loadType: #linear. "change to #atomic if desired"
		project ]
]

{ #category : #symbolic }
ConfigurationOfXMLWriter >> stable: spec [
	<symbolicVersion: #'stable'>

	spec for: #'common' version: '2.8.4'.


]

{ #category : #versions }
ConfigurationOfXMLWriter >> version100: spec [ 
	<version: '1.0' imports: #('1.0-baseline') >
	
	spec for: #common do: [
		spec blessing: #release.

		spec
			package: 'Collections-CharacterMap' with: 'Collections-CharacterMap-JAAyer.1';
			package: 'XML-Writer' with: 'XML-Writer-JAAyer.1'].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version101: spec [ 
	<version: '1.0.1' imports: #('1.0.1-baseline') >
	
	spec for: #common do: [
		spec blessing: #release.

		spec
			package: 'Collections-OrderPreservingDictionary'
			with: 'Collections-OrderPreservingDictionary-JAAyer.1';
			package: 'Collections-CharacterMap' with: 'Collections-CharacterMap-JAAyer.1';
			package: 'XML-Writer' with: 'XML-Writer-JAAyer.2'].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version102: spec [ 
	<version: '1.0.2' imports: #('1.0.1-baseline') >
	
	spec for: #common do: [
		spec blessing: #release.

		spec
			package: 'Collections-OrderPreservingDictionary'
			with: 'Collections-OrderPreservingDictionary-JAAyer.1';
			package: 'Collections-CharacterMap' with: 'Collections-CharacterMap-JAAyer.1';
			package: 'XML-Writer' with: 'XML-Writer-JAAyer.3'].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version103: spec [ 
	<version: '1.0.3' imports: #('1.0.1-baseline') >
	
	spec for: #common do: [
		spec blessing: #release.

		spec
			package: 'Collections-OrderPreservingDictionary'
			with: 'Collections-OrderPreservingDictionary-JAAyer.5';
			package: 'Collections-CharacterMap' with: 'Collections-CharacterMap-JAAyer.1';
			package: 'XML-Writer' with: 'XML-Writer-JAAyer.4'].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version104: spec [ 
	<version: '1.0.4' imports: #('1.0.4-baseline') >
	
	spec for: #common do: [
		spec blessing: #release.

		spec
			package: 'Collections-OrderPreservingDictionary'
			with: 'Collections-OrderPreservingDictionary-JAAyer.6';
			package: 'XML-Writer' with: 'XML-Writer-JAAyer.5'].

	spec for: #gemstone do: [
		spec 
			package: 'Collections-CharacterSet' with: 'Collections-CharacterSet-JohanBrichau.1']
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version105: spec [
	<version: '1.0.5' imports: #('1.0.5-baseline')>
	spec
		for: #common
			do: [ 
					spec
						blessing: #release;
						package: 'Collections-OrderPreservingDictionary' with: 'Collections-OrderPreservingDictionary-JAAyer.6';
						package: 'XML-Writer' with: 'XML-Writer-JAAyer.5' ];
		for: #squeakCommon do: [ spec package: 'Collections-Support' with: 'Collections-Support-StephaneDucasse.35' ];
		for: #gemstone
			do: [ 
					spec
						package: 'Collections-Support' with: 'Collections-Support.g-OttoBehrens.45';
						package: 'Collections-Tests-Support' with: 'Collections-Tests-Support.g-OttoBehrens.3' ]
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version200: spec [
	<version: '2.0.0' imports: #('2.0.0-baseline')>
	spec
		for: #common
			do: [ spec
					blessing: #release;
					package: 'XML-Writer' with: 'XML-Writer-JAAyer.5' ];
		
		" I do not understand the following line because it means that we would load an older version than the one currently in Pharo. Clearly the best way to introduce bugs and losing hours trying to understand why.
		for: #squeakCommon do: [ spec package: 'Collections-Support' with: 'Collections-Support-StephaneDucasse.35' ];"
		for: #gemstone
			do: [ 
					spec
						package: 'Collections-Support' with: 'Collections-Support.g-OttoBehrens.45';
						package: 'Collections-Tests-Support' with: 'Collections-Tests-Support.g-OttoBehrens.3' ]
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version210: spec [
	<version: '2.1.0' imports: #('2.1.0-baseline')>
	spec
		for: #common
			do: [ spec
					blessing: #release;
					package: 'XML-Writer-Core' with: 'XML-Writer-Core-StephaneDucasse.1' ;
					package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-StephaneDucasse.1' ];
		
		" I do not understand the following line because it means that we would load an older version than the one currently in Pharo. Clearly the best way to introduce bugs and losing hours trying to understand why.
		for: #squeakCommon do: [ spec package: 'Collections-Support' with: 'Collections-Support-StephaneDucasse.35' ];"
		for: #gemstone
			do: [ 
					spec
						package: 'Collections-Support' with: 'Collections-Support.g-OttoBehrens.45';
						package: 'Collections-Tests-Support' with: 'Collections-Tests-Support.g-OttoBehrens.3' ]
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version220: spec [
	<version: '2.2.0' imports: #('2.1.0-baseline')>
	spec
		for: #common
			do: [ spec
					blessing: #release;
					package: 'XML-Writer-Core' with: 'XML-Writer-Core-StephaneDucasse.1' ;
					package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-StephaneDucasse.1' ];
		
	
		for: #gemstone
			do: [ 
					spec
						package: 'Collections-Support' with: 'Collections-Support.g-OttoBehrens.45';
						package: 'Collections-Tests-Support' with: 'Collections-Tests-Support.g-OttoBehrens.3' ]
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version221: spec [
	<version: '2.2.1' imports: #('2.1.0-baseline')>
	spec
		for: #common
			do: [ spec
					blessing: #release;
					package: 'XML-Writer-Core' with: 'XML-Writer-Core-CamilloBruni.2' ;
					package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-StephaneDucasse.1' ];
		
	
		for: #gemstone
			do: [ 
					spec
						package: 'Collections-Support' with: 'Collections-Support.g-OttoBehrens.45';
						package: 'Collections-Tests-Support' with: 'Collections-Tests-Support.g-OttoBehrens.3' ]
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version230: spec [
	<version: '2.3' imports: #('2.2.0-baseline')>
	spec
		for: #common
			do: [ spec
					description: 'Enhancements made by monty to support Entity% and others';
					blessing: #release;
					package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.5' ;
					package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-StephaneDucasse.1' ];
		
	
		for: #gemstone
			do: [ 
					spec
						package: 'Collections-Support' with: 'Collections-Support.g-OttoBehrens.45';
						package: 'Collections-Tests-Support' with: 'Collections-Tests-Support.g-OttoBehrens.3' ]
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version2310: spec [
	<version: '2.3.10' imports: #('2.3.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #release.
		spec description: 'version 2.3.10'.
		spec author: 'GuillaumeLarcheveque'.
		spec timestamp: '6/27/2014 16:09'.
		spec project: 'OrderPreservingDictionary' with: '1.2'.
		spec 
			package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.15';
			package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.2'. ].

	spec for: #gemstone
			do: [ 
					spec
						package: 'Collections-Support' with: 'Collections-Support.g-OttoBehrens.45';
						package: 'Collections-Tests-Support' with: 'Collections-Tests-Support.g-OttoBehrens.3' ]

]

{ #category : #versions }
ConfigurationOfXMLWriter >> version231: spec [
	<version: '2.3.1' imports: #('2.3.1-baseline')>
	spec
		for: #common
			do: [ spec
					description: 'Enhancements made by monty to support Entity% and others';
					blessing: #release;
					package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.5' ;
					package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-StephaneDucasse.1' ];
		
	
		for: #gemstone
			do: [ 
					spec
						package: 'Collections-Support' with: 'Collections-Support.g-OttoBehrens.45';
						package: 'Collections-Tests-Support' with: 'Collections-Tests-Support.g-OttoBehrens.3' ]
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version232: spec [
	<version: '2.3.2' imports: #('2.3.1-baseline')>
	spec
		for: #common
			do: [ spec
					blessing: #release;
					package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.6' ;
					package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-StephaneDucasse.1' ];
		
	
		for: #gemstone
			do: [ 
					spec
						package: 'Collections-Support' with: 'Collections-Support.g-OttoBehrens.45';
						package: 'Collections-Tests-Support' with: 'Collections-Tests-Support.g-OttoBehrens.3' ]
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version233: spec [
	<version: '2.3.3' imports: #('2.3.1-baseline')>
	spec
		for: #common
			do: [ spec
					blessing: #release;
					package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.7' ;
					package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-StephaneDucasse.1' ];
		
	
		for: #gemstone
			do: [ 
					spec
						package: 'Collections-Support' with: 'Collections-Support.g-OttoBehrens.45';
						package: 'Collections-Tests-Support' with: 'Collections-Tests-Support.g-OttoBehrens.3' ]
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version234: spec [
	<version: '2.3.4' imports: #('2.3.1-baseline')>
	spec
		for: #common
			do: [ spec
					blessing: #release;
					package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.8' ;
					package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-StephaneDucasse.1' ];
		
	
		for: #gemstone
			do: [ 
					spec
						package: 'Collections-Support' with: 'Collections-Support.g-OttoBehrens.45';
						package: 'Collections-Tests-Support' with: 'Collections-Tests-Support.g-OttoBehrens.3' ]
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version235: spec [
	<version: '2.3.5' imports: #('2.3.1-baseline')>
	spec
		for: #common
			do: [ spec
					blessing: #release;
					package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.9' ;
					package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-StephaneDucasse.1' ];
		
	
		for: #gemstone
			do: [ 
					spec
						package: 'Collections-Support' with: 'Collections-Support.g-OttoBehrens.45';
						package: 'Collections-Tests-Support' with: 'Collections-Tests-Support.g-OttoBehrens.3' ]
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version236: spec [
	<version: '2.3.6' imports: #('2.3.1-baseline')>
	spec
		for: #common
			do: [ spec
					blessing: #release;
					package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.11' ;
					package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-StephaneDucasse.1' ];
		
	
		for: #gemstone
			do: [ 
					spec
						package: 'Collections-Support' with: 'Collections-Support.g-OttoBehrens.45';
						package: 'Collections-Tests-Support' with: 'Collections-Tests-Support.g-OttoBehrens.3' ]
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version237: spec [
	<version: '2.3.7' imports: #('2.3.1-baseline')>
	spec
		for: #common
			do: [ spec
					blessing: #release;
					package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.13' ;
					package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-StephaneDucasse.1' ];
		
	
		for: #gemstone
			do: [ 
					spec
						package: 'Collections-Support' with: 'Collections-Support.g-OttoBehrens.45';
						package: 'Collections-Tests-Support' with: 'Collections-Tests-Support.g-OttoBehrens.3' ]
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version238: spec [
	<version: '2.3.8' imports: #('2.3.1-baseline')>
	spec
		for: #common
			do: [ spec
					blessing: #release;
					package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.14' ;
					package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.2' ];
		
	
		for: #gemstone
			do: [ 
					spec
						package: 'Collections-Support' with: 'Collections-Support.g-OttoBehrens.45';
						package: 'Collections-Tests-Support' with: 'Collections-Tests-Support.g-OttoBehrens.3' ]
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version239: spec [
	<version: '2.3.9' imports: #('2.3.1-baseline')>
	spec
		for: #common
			do: [ spec
					blessing: #release;
					package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.15' ;
					package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.2' ];
		
	
		for: #gemstone
			do: [ 
					spec
						package: 'Collections-Support' with: 'Collections-Support.g-OttoBehrens.45';
						package: 'Collections-Tests-Support' with: 'Collections-Tests-Support.g-OttoBehrens.3' ]
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version240: spec [
	<version: '2.4.0' imports: #('2.3.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #release.
		spec description: 'version 2.4.0'.
		spec project: 'OrderPreservingDictionary' with: '1.2'.
		spec 
			package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.17';
			package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.3'. ].

	spec for: #gemstone
			do: [ 
					spec
						package: 'Collections-Support' with: 'Collections-Support.g-OttoBehrens.45';
						package: 'Collections-Tests-Support' with: 'Collections-Tests-Support.g-OttoBehrens.3' ]

]

{ #category : #versions }
ConfigurationOfXMLWriter >> version241: spec [
	<version: '2.4.1' imports: #('2.3.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #release.
		spec
			package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.18';
			package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.4'. ].

	spec for: #gemstone
			do: [ 
					spec
						package: 'Collections-Support' with: 'Collections-Support.g-OttoBehrens.45';
						package: 'Collections-Tests-Support' with: 'Collections-Tests-Support.g-OttoBehrens.3' ]

]

{ #category : #versions }
ConfigurationOfXMLWriter >> version242: spec [
	<version: '2.4.2' imports: #('2.3.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #release.
		spec
			package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.20';
			package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.6'. ].

	spec for: #gemstone
			do: [ 
					spec
						package: 'Collections-Support' with: 'Collections-Support.g-OttoBehrens.45';
						package: 'Collections-Tests-Support' with: 'Collections-Tests-Support.g-OttoBehrens.3' ]

]

{ #category : #versions }
ConfigurationOfXMLWriter >> version243: spec [
	<version: '2.4.3' imports: #('2.4.3-baseline' )>

	spec for: #'common' do: [
		spec blessing: #release.
		spec
			package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.21';
			package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.7'. ].

]

{ #category : #versions }
ConfigurationOfXMLWriter >> version244: spec [ 
        <version: '2.4.4' imports: #('2.4.3-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.22'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.8'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version245: spec [ 
        <version: '2.4.5' imports: #('2.4.3-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.23'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.8'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version246: spec [ 
        <version: '2.4.6' imports: #('2.4.3-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.24'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.8'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version247: spec [ 
        <version: '2.4.7' imports: #('2.4.3-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.25'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.9'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version248: spec [ 
        <version: '2.4.8' imports: #('2.4.3-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.26'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.10'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version249: spec [ 
        <version: '2.4.9' imports: #('2.4.3-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.27'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.10'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version251: spec [ 
        <version: '2.5.1' imports: #('2.5.1-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.28'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.11'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version252: spec [ 
        <version: '2.5.2' imports: #('2.5.1-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.29'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.12'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version253: spec [ 
        <version: '2.5.3' imports: #('2.5.1-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.30'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.13'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version254: spec [ 
        <version: '2.5.4' imports: #('2.5.1-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.31'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.14'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version255: spec [ 
        <version: '2.5.5' imports: #('2.5.1-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.32'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.14'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version256: spec [ 
        <version: '2.5.6' imports: #('2.5.1-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.33'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.15'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version257: spec [ 
        <version: '2.5.7' imports: #('2.5.1-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.34'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.16'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version258: spec [ 
        <version: '2.5.8' imports: #('2.5.1-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.35'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.17'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version259: spec [ 
        <version: '2.5.9' imports: #('2.5.1-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.36'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.17'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version260: spec [ 
        <version: '2.6.0' imports: #('2.5.1-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.37'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.18'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version261: spec [ 
        <version: '2.6.1' imports: #('2.5.1-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.38'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.18'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version262: spec [ 
        <version: '2.6.2' imports: #('2.5.1-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.39'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.19'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version263: spec [ 
        <version: '2.6.3' imports: #('2.5.1-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.40'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.20'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version264: spec [ 
        <version: '2.6.4' imports: #('2.5.1-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.41'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.21'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version265: spec [ 
        <version: '2.6.5' imports: #('2.5.1-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.42'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.23'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version266: spec [ 
        <version: '2.6.6' imports: #('2.5.1-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.44'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.24'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version267: spec [ 
        <version: '2.6.7' imports: #('2.6.7-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.45'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.25'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version268: spec [ 
        <version: '2.6.8' imports: #('2.6.7-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.46'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.26'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version269: spec [ 
        <version: '2.6.9' imports: #('2.6.7-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.47'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.27'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version270: spec [ 
        <version: '2.7.0' imports: #('2.7.0-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.48'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.27'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version271: spec [ 
        <version: '2.7.1' imports: #('2.7.0-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.49'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.28'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version272: spec [ 
        <version: '2.7.2' imports: #('2.7.0-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.52'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.28'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version273: spec [ 
        <version: '2.7.3' imports: #('2.7.0-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.53'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.29'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version274: spec [ 
        <version: '2.7.4' imports: #('2.7.4-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.55'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.30'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version275: spec [ 
        <version: '2.7.5' imports: #('2.7.4-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.59'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.31'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version276: spec [ 
        <version: '2.7.6' imports: #('2.7.4-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.60'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.32'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version277: spec [ 
        <version: '2.7.7' imports: #('2.7.4-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.62'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.32'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version278: spec [ 
        <version: '2.7.8' imports: #('2.7.4-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.65'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.35'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version279: spec [ 
        <version: '2.7.9' imports: #('2.7.4-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.66'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.36'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version280: spec [ 
        <version: '2.8.0' imports: #('2.7.4-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.67'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.37'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version281: spec [ 
        <version: '2.8.1' imports: #('2.8.1-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.70'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.37'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version282: spec [ 
        <version: '2.8.2' imports: #('2.8.1-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.72'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.37'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version283: spec [ 
        <version: '2.8.3' imports: #('2.8.1-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.73'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.37'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLWriter >> version284: spec [ 
        <version: '2.8.4' imports: #('2.8.1-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Writer-Core' with: 'XML-Writer-Core-monty.74'.
			spec package: 'XML-Writer-Tests' with: 'XML-Writer-Tests-monty.38'.
                ].
]
