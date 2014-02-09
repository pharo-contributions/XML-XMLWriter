"
This class writes public and system IDs of external entities.
"
Class {
	#name : #XMLExternalIDWriter,
	#superclass : #Object,
	#instVars : [
		'publicId',
		'systemId'
	],
	#category : #'XML-Writer-Core'
}

{ #category : #testing }
XMLExternalIDWriter >> hasExternalID [
	^ self publicID notEmpty or: [self systemID notEmpty]
]

{ #category : #accessing }
XMLExternalIDWriter >> publicID [
	^ publicId ifNil: [publicId := '']
]

{ #category : #accessing }
XMLExternalIDWriter >> publicID: aPublicId [
	publicId := aPublicId
]

{ #category : #accessing }
XMLExternalIDWriter >> systemID [
	^ systemId ifNil: [systemId := '']
]

{ #category : #accessing }
XMLExternalIDWriter >> systemID: aSystemId [
	systemId := aSystemId
]

{ #category : #'writing markup' }
XMLExternalIDWriter >> writeOn: aWriter [
	self publicID
		ifNotEmpty: [:id |
			aWriter
				nextPutAll: 'PUBLIC';
				space;
				writeUnescapedString: id]
		ifEmpty: [
			self systemID
				ifNotEmpty: [aWriter nextPutAll: 'SYSTEM']].

	self systemID ifNotEmpty: [:id |
		aWriter
			space;
			writeUnescapedString: id].
]
