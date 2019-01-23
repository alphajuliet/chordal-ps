// server.js
// andrewj 2019-01-15

// Imports
const fs = require('fs'),
  express = require('express'),
  app = express(),
  url = require('url'),
  C = require('./dist/Router')

// -------------------------------
// http://expressjs.com/en/starter/static-files.html
app.use(express.static('public'));

// http://expressjs.com/en/starter/basic-routing.html
app.get('/', function(request, response) {
  response.sendFile(__dirname + '/views/index.html');
});

// Redirect all /api calls to the Chordal router
app.use('/api', function (req, res, next) {
  console.log('Request: ', req.originalUrl)
  const json = JSON.parse(C.route(req.url))
  res.json(json)
})

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
// listen for requests :)
const port = 3000
const listener = app.listen(port, function() {
  console.log('Your app is listening on port ' + listener.address().port);
});

// The End
