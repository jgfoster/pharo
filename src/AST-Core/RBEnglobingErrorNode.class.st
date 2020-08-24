"
I am a node representing a source code segment that parsed but never used in a node because of an unexpected error at the end. I am mainly used for source-code coloring and icon styling where all the code parsed should be colored normaly but underlined as part of the error.
This node also propose a reparation research.

Parsing faulty code without raising a syntax error is done by 
RBParser parseFaultyExpression:
or
RBParser parseFaultyMethod: 

Accessing to the parsed nodes contained inside the node is the method 'content'.


"
Class {
	#name : #RBEnglobingErrorNode,
	#superclass : #RBParseErrorNode,
	#instVars : [
		'content'
	],
	#category : #'AST-Core-Nodes'
}

{ #category : #'as yet unclassified' }
RBEnglobingErrorNode class >> content: aCollection start: aStart stop: aStop errorMessage: message [
	^self new 
		content: aCollection; 
		start: aStart; 
		stop: aStop; 
		errorMessage: message;
		createValue.
]

{ #category : #construction }
RBEnglobingErrorNode class >> error: aToken withNodes: aCollection [
	"Realise a selection between the different englobing error node classes possible according to the 
	 received token. If the value of the token is not recognised, we create an undetermined one."
	('()' includes: aToken value)
		ifTrue: [ ^RBParenthesesErrorNode error: aToken withNodes: aCollection ].
	('[]' includes: aToken value)
		ifTrue: [ ^RBBlockErrorNode error: aToken withNodes: aCollection ].
	('#(' = aToken value asString)
		ifTrue: [ ^RBLiteralArrayErrorNode error: aToken withNodes: aCollection ].
	('#[' = aToken value asString)
		ifTrue: [ ^RBLiteralByteArrayErrorNode error: aToken withNodes: aCollection ].
	('{}' includes: aToken value)
		ifTrue: [ ^RBArrayErrorNode error: aToken withNodes: aCollection ].
	('|' = aToken value asString)
		ifTrue: [ ^RBTemporariesErrorNode error: aToken withNodes: aCollection ].
	('<' = aToken value asString)
		ifTrue: [ ^RBPragmaErrorNode error: aToken withNodes: aCollection ].
	^self new content: aCollection; start: aCollection first start; stop: aToken stop; errorMessage: 'complementary of''',aToken value,''' expected'
]

{ #category : #visiting }
RBEnglobingErrorNode >> acceptVisitor: aVisitor [
	[ aVisitor visitEnglobingErrorNode: self ] on: Error do: [super acceptVisitor: aVisitor ].
]

{ #category : #accessing }
RBEnglobingErrorNode >> children [
	^self content.
]

{ #category : #accessing }
RBEnglobingErrorNode >> content [
	^content 
]

{ #category : #accessing }
RBEnglobingErrorNode >> content: aCollection [
	content := aCollection
]

{ #category : #'as yet unclassified' }
RBEnglobingErrorNode >> createValue [
	self value: (String streamContents: [ :s |
			content do: [ :each | s nextPutAll: each formattedCode. s nextPutAll: String space. ]])
]

{ #category : #initialization }
RBEnglobingErrorNode >> initialize [ 
	super initialize.
	content := OrderedCollection new.
	value := ''.
]

{ #category : #testing }
RBEnglobingErrorNode >> isEnglobingError [
	^true
]

{ #category : #accessing }
RBEnglobingErrorNode >> stop: anInterger [
	stop := anInterger.
]