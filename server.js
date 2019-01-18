// server.js
// andrewj 2019-01-15

// Imports
const fs = require('fs'),
      express = require('express'),
      app = express(),
      url = require('url'),
      R = require('ramda'),
      C = require('./dist/Chordal')

// -------------------------------
// http://expressjs.com/en/starter/static-files.html
app.use(express.static('public'));

// http://expressjs.com/en/starter/basic-routing.html
app.get('/', function(request, response) {
  response.sendFile(__dirname + '/views/index.html');
});

// Render and display the README.md file with the API documentation
app.get('/README', function (req, res) {
  fs.readFile(__dirname + '/README.md', 'utf8', (err, data) => {
    if (err) 
      console.error(err)
    else {
      res.end(md.render(data))
    }
  })
})

// -------------------------------
// Get the note names
app.get('/allnotes', (req, res) => {
  console.log('GET /allNotes')
  
  const x = C.allNotes
  const json = { notes: x }

  const status = json.error ? 400 : 200
  res.status(status).json(json)
})

// -------------------------------
// Get all chords
app.get('/chords', (req, res) => {
  console.log('GET /chords')

  let json
  const x = C.allChords
  if (R.equals(x, {}))
    json = { error: "Chords not available." }
  else
    json = { chords: x }
  const status = json.error ? 400 : 200
  res.status(status).json(json)
})

// -------------------------------
// Get a given chord
app.get('/chord/:note/:chord', (req, res) => {
  
  // Get parameters
  const note = req.params.note
  const chord = R.toLower(req.params.chord)
  const transpose  = Number(url.parse(req.url, true).query.transpose || 0)
  const inversion = Number(url.parse(req.url, true).query.inversion || 0)
  const opts = { transpose, inversion }
  
  // Call service
  console.log(`GET ${req.url}`)
  console.log(`Chord: ${note}_${chord}, transpose by ${transpose}, invert by ${inversion}`)

  let json
  const x = C.getChord(note)(chord)(opts)
  if (R.equals(x, {}))
    json = { error: "Chord not recognised." }
  else
    json = { 
      notes: x.value0,
      transpose: transpose,
      inversion: inversion
    }
  const status = json.error ? 400 : 200
  res.status(status).json(json)
  
})

// ---------------------------------
// Handle a list of notes
app.get('/notes', (req, res) => {

  // Get arguments
  const tr  = Number(url.parse(req.url, true).query.transpose || 0)
  const notesStr = url.parse(req.url, true).query.list || ""
  const notes = R.split(',', notesStr)
  const opts = { transpose: tr, inversion: 0 }

  console.log(`GET ${req.url}`)
  console.log(`Transpose [${notes}] by ${tr} semitone(s)`)

  let json
  const x = C.transposeNotes(notes)(opts)
  if (R.equals(x, {}))
    json = { error: "Notes not recognised." }
  else
    json = { 
      notes: x.value0,
      transpose: tr
    }
  const status = json.error ? 400 : 200
  res.status(status).json(json)
})


// ---------------------------------
// Get all available scales
app.get('/scales', (req, res) => {
  console.log('GET /scales')
  
  let json
  const x = C.allScales
  if (R.equals(x, {}))
    json = { error: "Scales not available." }
  else
    json = { scales: x }
  const status = json.error ? 400 : 200
  res.status(status).json(json)
})

// ---------------------------------
// Return a requested scale
app.get('/scale/:note/:scale', (req, res) => {

  const note = req.params.note
  const scale = req.params.scale
  const tr  = Number(url.parse(req.url, true).query.transpose || 0)
  const opts = {
    transpose: tr,
    inversion: 0
  }

  console.log(`GET ${req.url}`)
  console.log(`Scale: ${note} ${scale}`)

  let json
  const x = C.getScale(note)(scale)(opts)
  if (R.equals(x, {}))
    json = { error: "Scales not available." }
  else
    json = { 
      notes: x.value0,
      transpose: tr
    }
  const status = json.error ? 400 : 200
  res.status(status).json(json)
})

// -------------------------------
// listen for requests :)
const port = 3000
const listener = app.listen(port, function() {
  console.log('Your app is listening on port ' + listener.address().port);
});

// The End
