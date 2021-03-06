Class {
	#name : #InvocationPrinter,
	#superclass : #Object,
	#instVars : [
		'file'
	],
	#category : #CIMPrinter
}

{ #category : #printing }
InvocationPrinter class >> printAll: aSymbol for: aFamixPWBBehaviors in: aFileReference [
	^ self new
		file: aFileReference;
		printAll: aSymbol for: aFamixPWBBehaviors
]

{ #category : #printing }
InvocationPrinter >> cimPrint: invoc on: stream [
	stream
		<< invoc source parentType library name;
		<< '.';
		<< invoc source parentType name;
		<< '.';
		<< invoc source name;
		<< ';';
		<<
			(invoc sourceAnchor startLine - invoc source sourceAnchor startLine)
				asString;
		<< ';';
		<<
			(invoc sourceAnchor startLine - invoc source sourceAnchor startLine)
				asString;
		<< ';'.
	self cimPrintArguments: invoc arguments on: stream.
	stream cr.
	^ stream
]

{ #category : #printing }
InvocationPrinter >> cimPrintArguments: aCollection on: stream [
	aCollection ifEmpty: [ ^ stream ].
	1 to: aCollection size - 1 do: [ :iter | 
		stream
			<< (aCollection at: iter) sourceText;
			<< '//' ].
	stream << aCollection last sourceText.
	^ stream
]

{ #category : #printing }
InvocationPrinter >> file [
	^ file
]

{ #category : #printing }
InvocationPrinter >> file: aString [
	file := aString
]

{ #category : #printing }
InvocationPrinter >> printAll: aSymbol for: aFamixPWBBehaviors [
	| invocations |
	invocations := aFamixPWBBehaviors
		flatCollectAsSet: [ :each | each queryAllLocal: aSymbol ].
	^ self file asFileReference
		writeStreamDo: [ :stream | 
			self printHeaderOn: stream.
			invocations do: [ :invoc | self cimPrint: invoc on: stream ] ]
]

{ #category : #printing }
InvocationPrinter >> printHeaderOn: stream [
	^ stream
		<<
			'Appellant;ligne_debut_relative;ligne_fin_relative;arguements';
		cr
]
