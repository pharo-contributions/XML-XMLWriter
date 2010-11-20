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
			package: 'XML-Writer' with: [spec requires: 'Collections-CharacterMap'];
			package: 'XML-Tests-Writer' with: [spec requires: 'XML-Writer'].

		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('XML-Writer');
			group: 'Tests' with: #('XML-Tests-Writer')].
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
			package: 'XML-Writer' with: [spec requires: 'Collections-CharacterMap'];
			package: 'XML-Tests-Writer' with: [spec requires: 'XML-Writer'].

		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('XML-Writer');
			group: 'Tests' with: #('XML-Tests-Writer')].
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
