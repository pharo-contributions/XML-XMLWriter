"
This class generates processing instructions.
"
Class {
	#name : #XMLPIWriter,
	#superclass : #XMLMarkupWriter,
	#instVars : [
		'target',
		'data'
	],
	#category : #'XML-Writer-Core'
}

{ #category : #accessing }
XMLPIWriter >> data [
	^ data ifNil: ['']
]

{ #category : #accessing }
XMLPIWriter >> data: aString [
	data := aString
]

{ #category : #accessing }
XMLPIWriter >> target [
	^ target ifNil: ['']
]

{ #category : #accessing }
XMLPIWriter >> target: aString [
	target := aString
]

{ #category : #private }
XMLPIWriter >> writeBody [
	self omitIfCanonicalInDTD: [
		self writer
			space;
			nextPutAll: self data]
]

{ #category : #private }
XMLPIWriter >> writeEpilogue [
	self omitIfCanonicalInDTD: [self writer nextPutAll: '?>']
]

{ #category : #private }
XMLPIWriter >> writePrologue [
	self omitIfCanonicalInDTD: [
		self writer
			formatBeforePI: self;
			nextPutAll: '<?';
			writeName: self target]
]
