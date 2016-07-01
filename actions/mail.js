var nodemailer = require('nodemailer');
 
var Mail = function (options) {
    var transporter = nodemailer.createTransport(options.smtpString);

    var send = function (to, subject, text) {

        var mailOptions = {
            to: to,
            subject: subject,
            text: text
        };
         
        transporter.sendMail(mailOptions, function(error, info){
            if(error){
                return console.log(error);
            }
            console.log('Message sent: ' + info.response);
        });
    }

    return {
        send: send
    }
}

module.exports = Mail;