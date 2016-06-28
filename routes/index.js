var express = require('express');
var router = express.Router();
var path = require('path')


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


module.exports = router;
