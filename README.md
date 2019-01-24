# Chordal API

A simple musical API focusing on enumerating named chords and scales. 

For chords, a list of the available chords is found from the first API call below. 
It includes most major and minor chords, including sevenths, diminished/augmented, and suspended chords. 
A variety of alternative names are also catered for, e.g. maj7 = major7 = maj7th = major7th

Similarly, for scales, a list of known scales and modes can be requested, and then a
specific one requested with a given root note and optional transposition.

This is a reimplementation in PureScript of the [original version](https://github.com/alphajuliet/chordal/) in JavaScript. 

## API 

### List available notes

`GET /api/notes`

Return the available note names in the octave, including alternates, e.g. C# == Db.

### List available chords

`GET /api/chords` 

Return the available chords names, their constituent semitones, and descriptions.

### Return chord notes

`GET /api/chord/<note>/<chord>`

Return the notes in the requested chord. The handling of accidentals (# or b) is
based on the root note.


#### Arguments

* `note`: the name of a note, e.g C, F#, Ab, E
* `chord`: a named chord, e.g. min, maj7, sus4

#### Examples

| Request | Response |
| ------- | -------- |
|`GET /api/chord/E/min` | `{"chord":"E_min","transpose":0,"inversion":0,"notes":[["E","G","B"]}`|
|`GET /api/chord/Gb/maj7` | `{"chord":"Gb_maj7","transpose":0,"inversion":0,"notes":["Gb","Bb","Db","F"]}`|

#### Notes

* Doesn't handle Cb, B#, E#, and Fb.
* Double sharps and flats (e.g. Cx, Abb), and naturals are not handled.
* Unicode characters not handled (♯, 𝄪, ♭, 𝄫, ♮).

### Transpose a chord

`GET /api/chord/<note>/<chord>?transpose=<n>`

Transpose the notes in the requested chord up/down by `n`.

### Invert a chord

`GET /api/chord/<note>/<chord>?inversion=<n>`

Provide the `n`th inversion of the chord. This can be combined with
transposition in the same request.

#### Examples

| Request | Response |
| ------- | -------- |
|`GET /api/chord/F/maj?transpose=3` | `{"chord":"F_maj","transpose":3,"inversion":0,"notes":["G#","C","D#"]}`|
|`GET /api/chord/F/maj?inversion=1` | `{"chord":"F_maj","transpose":0,"inversion":1,"notes":[["A","C","F"]}`|

### Transpose a list of notes

`GET /api/note/<lst>&transpose=<n>`

Transpose a list of notes by `n` semitones. The list of notes is separated by
commas, and '#" must be encoded as `%23`. The notes need have no relation to
each other, and can be repeated as desired. It could be a chord, or a sequence
of played notes.

#### Examples


| Request | Response |
| ------- | -------- |
|`GET /api/note/C,D,E&transpose=1` | `{"transpose":1,"notes":["C#","D#","F"]}`|

### List known scales

`GET /scales`

### Get a scale

`GET /api/scale/<note>/<scale>?transpose=<n>`

#### Examples

| Request | Response |
| ------- | -------- |
|`GET /api/scale/Db/harmonic_minor&transpose=5` | `{"scale":"Db harmonic_minor","notes":["Gb","Ab","A","B","Db","D","F"]}`|

----

The code is live on [Glitch](https://chordal-ps.glitch.me/)

Project [i:513761]
