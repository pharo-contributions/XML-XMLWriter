"
This class writes public and system IDs of external entities.
"
Class {
	#name : #XMLExternalIDWriter,
	#superclass : #Object,
	#instVars : [
		'publicID',
		'systemID'
	],
	#category : #'XML-Writer-Core'
}

{ #category : #testing }
XMLExternalIDWriter >> hasExternalID [
	^ self publicID notEmpty or: [self systemID notEmpty]
]

{ #category : #accessing }
XMLExternalIDWriter >> publicID [
	^ publicID ifNil: [publicID := '']
]

{ #category : #accessing }
XMLExternalIDWriter >> publicID: aPublicID [
	publicID := aPublicID
]

{ #category : #accessing }
XMLExternalIDWriter >> systemID [
	^ systemID ifNil: [systemID := '']
]

{ #category : #accessing }
XMLExternalIDWriter >> systemID: aSystemID [
	systemID := aSystemID
]

{ #category : #writing }
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
