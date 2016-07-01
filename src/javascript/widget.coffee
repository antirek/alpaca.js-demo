jQmbl = $.noConflict true

app = 
  tpl: '@@include("../../tmp/widget.html")'
  styles: '@@include("../../build/css/widget.css")'


jQmbl('#container').addClass('tbl_wrapper').append(app.tpl)

loadStyles = (callback)->
  id = 'widget_styles'

  if !document.getElementById(id)
    head  = document.getElementsByTagName('head')[0]
    style = document.createElement('style')
    style.id = 'mbl_widget_styles'
    style.type = 'text/css'
    style.media = 'all';
    if style.styleSheet
      style.styleSheet.cssText = app.styles
    else
      style.appendChild(document.createTextNode(app.styles))

    head.appendChild(style)
    callback() if typeof(callback) == 'function'


loadStyles()

WForm = (options) ->
  loadConfig = (cb)->
    host = ''
    serverUrl = host + '/configs/' + options['key'];
    jQmbl.getJSON(serverUrl, cb);

  bind = (selector, form)->
    jQmbl(selector).alpaca(form);

  loadConfig: loadConfig
  bind: bind

wForm = new WForm({key: '@@@key@@@'});

wForm.loadConfig (data)->
  jQmbl('#buttonEmbedded').html(data.element.title)
  jQmbl('#buttonEmbedded').removeClass('hide')

  jQmbl("#myModal .modal-dialog").addClass(data.element.dialogWidthClass) if data.element.dialogWidthClass

  data.form.options.form.attributes.action = "http://localhost:3000/send/@@@key@@@"
  data.form.options.form.attributes.method = "post"

  data.form.options.form.buttons.submit.click = ()->
    this.ajaxSubmit()
      .done ()->
        console.log 'send'
        jQmbl('#form').alpaca("destroy");
        jQmbl('#form').html('thanks!!!');
      .fail ()->
        console.log 'fail'
    
  wForm.bind '#form', data.form
            


# fix косяк с backdrop
jQmbl "#myModal"
  .on "shown.bs.modal", (event)->
    jQmbl ".modal-backdrop"
      .css "z-index", "-1";

  .on "hide.bs.modal", (event)->
    jQmbl ".modal-backdrop"
      .hide()
