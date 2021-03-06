var express = require('express');
var router = express.Router();
var path = require('path');
var fs = require('fs');


var config = require('../config');
var Mail = require('../actions/mail');
var Callback = require('../actions/callback');

var mail = new Mail(config.mail);
var callback = new Callback();

var actionRunner = {
  mail: mail,
  callback: callback
}



router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});


router.get('/show/:key', function(req, res, next) {
  res.render('show', {key: req.params.key});
});


router.post('/send/:key', function (req, res, next) {
  var key = req.params.key;
  var configForWidget = fs.readFileSync(path.resolve(__dirname + '/../configs/' + key + '.json'), 'utf8');
  
  configForWidget = JSON.parse(configForWidget);

  if (configForWidget.actions) {
    configForWidget.actions.forEach( function(action) {
      console.log('action:', action.type);
      if (actionRunner[action.type]) {
        console.log('run action', action, req.body);
        actionRunner[action.type].run(action, req.body);
      }
    })
  }

  res.send(req.body);
  
});

/*
router.get('/configs/:key', function(req, res, next) {
  var key = req.params.key;
  res.setHeader('Content-Type', 'application/json');
  res.sendFile(path.resolve(__dirname + '/../configs/' + key + '.json'));
});
*/

router.get('/include/widget.js/:key', function(req, res, next) {
  var key = req.params.key;
  console.log('key:', key);

  var widgetjs = fs.readFileSync(path.resolve(__dirname + '/../build/widget.js'), 'utf8');

  var configForWidget = fs.readFileSync(path.resolve(__dirname + '/../configs/' + key + '.json'), 'utf8');

  configForWidget = JSON.stringify(JSON.parse(configForWidget));
  configForWidget = configForWidget.replace(/\'/g,'\\\'');

  //config = config.replace(/\r|\n/g, '');

  widgetjs = widgetjs.replace(/@@@config@@@/g, configForWidget);
  widgetjs = widgetjs.replace(/@@@key@@@/g, key);
  widgetjs = widgetjs.replace(/@@@host@@@/g, config.host);

  
  res.set('Content-Type', 'text/javascript');
  res.send(widgetjs);
});

/*
router.get('/include/style.css', function(req, res, next) {
  var contents = fs.readFileSync(path.resolve(__dirname + '/../build/css/widget.css'), 'utf8');

  res.set('Content-Type', 'text/css');
  res.send(contents);
});
*/

module.exports = router;