"
This class writes public and system IDs of external entities.
"
Class {
	#name : #XMLExternalIDWriter,
	#superclass : #XMLMarkupWriter,
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

{ #category : #private }
XMLExternalIDWriter >> writeBody [
	self publicID
		ifNotEmpty: [:id |
			self writer
				nextPutAll: 'PUBLIC';
				space;
				writeXmlEncodedString: id]
		ifEmpty: [
			self systemID
				ifNotEmpty: [self writer nextPutAll: 'SYSTEM']].

	self systemID ifNotEmpty: [:id |
		self writer
			space
			writeXmlEncodedString: id].
]
