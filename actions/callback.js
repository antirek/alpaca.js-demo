var fetchUrl = require("fetch").fetchUrl;

var Callback = function (options) {

    var baseUrl = 'http://call.mobilon.ru/';

    var prepareOrderUrl = function (key, opts) {
        var qs = '';
        for (var prop in opts) {
            if (opts.hasOwnProperty(prop)) {
                qs += prop + '=' + opts[prop] + '&';
            };
        }; 

        return [baseUrl, key, '/save?', qs].join("");
    };

    var run = function (config, data) {
        //console.log('callback', config, data);

        var url = prepareOrderUrl(config.key, {
            number: data[config.phoneField]
        });
        console.log('callback url:', url);
        
        fetchUrl(url, function (error, meta, body) {
            console.log('callback result', body.toString());
        });
    };

    return {
        run: run
    }
}

module.exports = Callback;