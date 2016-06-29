jQmbl = $.noConflict true

app = 
  tpl: '@@include("../../tmp/widget.html")'
  styles: '@@include("../../build/css/widget.css")'


jQmbl('#container').addClass('tbl_wrapper').append(app.tpl)


WForm = (options) ->
  loadConfig = (cb)->
    serverUrl = 'http://localhost:3000/configs/' + options['key'];
    jQmbl.getJSON(serverUrl, cb);

  bind = (selector, form)->
    jQmbl(selector).alpaca(form);

  loadConfig: loadConfig
  bind: bind

wForm = new WForm({key: 'demo'});

wForm.loadConfig (data)->
  wForm.bind '#form', data.form
            


# fix косяк с backdrop
jQmbl "#myModal"
  .on "shown.bs.modal", (event)->
    jQmbl ".modal-backdrop"
      .css "z-index", "-1";