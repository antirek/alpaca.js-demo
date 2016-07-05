
var Callback = function (options) {

    var run = function (config, data) {
        console.log('callback', config, data);
    };

    return {
        run: run
    }
}

module.exports = Callback;