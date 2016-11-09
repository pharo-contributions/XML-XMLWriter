"
This class writes <?...?> processing instructions, but not in DTD internal subsets if canonical XML is enabled.
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

{ #category : #testing }
XMLPIWriter >> hasData [
	^ self data notEmpty
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
	(self hasData
		and: [self isCanonicalInDTD not])
		ifTrue: [
			self writer
				space;
				nextPutAll: self data]
]

{ #category : #private }
XMLPIWriter >> writeEpilogue [
	self isCanonicalInDTD
		ifFalse: [
			self writer
				nextPutAll: '?>';
				formatAfterPI: self]
]

{ #category : #private }
XMLPIWriter >> writePrologue [
	self isCanonicalInDTD
		ifFalse: [
			self writer
				formatBeforePI: self;
				nextPutAll: '<?';
				writeName: self target]
]
