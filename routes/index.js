var express = require('express');
var router = express.Router();
var path = require('path');
var fs = require('fs');


router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});


router.get('/show/:key', function(req, res, next) {
  res.render('show', {key: req.params.key});
});


router.post('/send/:key', function (req, res, next) {
	res.send(req.body);
});


router.get('/configs/:key', function(req, res, next) {
  var key = req.params.key;
  res.setHeader('Content-Type', 'application/json');
  res.sendFile(path.resolve(__dirname + '/../configs/' + key + '.json'));
});


router.get('/include/widget.js', function(req, res, next) {
  var contents = fs.readFileSync(path.resolve(__dirname + '/../build/widget.js'), 'utf8');

  res.set('Content-Type', 'text/javascript');
  res.send(contents);
});

router.get('/include/style.css', function(req, res, next) {
  var contents = fs.readFileSync(path.resolve(__dirname + '/../build/css/widget.css'), 'utf8');

  res.set('Content-Type', 'text/css');
  res.send(contents);
});


module.exports = router;