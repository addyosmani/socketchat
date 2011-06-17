class window.SmartTemplate

  constructor: (@name, @options) ->
    @templateHtml = if @options? and @options.hasOwnProperty('templateHtml') then @options.templateHtml else $('.' + @name + '.template')
    $('.template').hide()
    @fallbackIDNumber = -1
    
  add: (itemOrCollection) ->
    if itemOrCollection instanceof Array
      @addItem item for item in itemOrCollection
    else
      @addItem itemOrCollection

  addItem: (data, isUpdate) ->
    instance = @templateHtml.clone false
    if @options? and @options.hasOwnProperty('bindDataToCssClasses') and @options.bindDataToCssClasses?
      for own key, value of data
        instance.find('.'+key).text value if instance.find('.'+key)?
    
    instance.attr 'id', @name + '_' + (data['id'] || data['_id'] || @fallbackIDNumber += 1)
    
    for regex in [/\{{(.*?)\}}/g, /\%7B%7B(.*?)\%7D%7D/g]          
      unless instance.html().match(new RegExp regex) is null            
        for matchedElement in instance.html().match(new RegExp regex)          
          unevaledValue = matchedElement.replace('{{','').replace('}}','').replace('%7B%7B','').replace('%7D%7D','')
          value = if data.hasOwnProperty(unevaledValue)
            data[unevaledValue]
          else
            if unevaledValue[0..2] is 'if ' 
              @condition = eval unevaledValue.replace('if ', '')
              if @condition is false
                @doNotevaluateRegexes = true
                'HtmlToRemove'
              else
                ''
            else if unevaledValue is 'else'
              if @condition is true
                @doNotevaluateRegexes = true
                'HtmlToRemove'
              else
                @doNotevaluateRegexes = undefined
                'HtmlToKeep'            
            else if unevaledValue is '/if'
              @doNotevaluateRegexes = undefined
              @condition = undefined
              '/END'              
            else
              if @doNotevaluateRegexes and @doNotevaluateRegexes is true
                ''
              else
                oldValues = {}
                oldValues[key] = window[key] for own key, value of data
                window[key] = value for own key, value of data
                result = eval unevaledValue
                window[key] = value for own key, value of oldValues
                result
            
          instance.html(instance.html().replace(matchedElement, value))
          
      if instance.html().match('HtmlToRemove')
        if instance.html().match('HtmlToKeep')
          htmlToRemove = instance.html().split('HtmlToRemove')[1].split('HtmlToKeep')[0]
        else
          htmlToRemove = instance.html().split('HtmlToRemove')[1].split('/END')[0]
        instance.html(instance.html().replace(htmlToRemove, '').replace('HtmlToRemove', '').replace('HtmlToKeep', '').replace('/END',''))
      else
        instance.html instance.html().replace('/END','')    
            
    instance.css @options.cssStyleProperties if @options? and @options.hasOwnProperty('cssStyleProperties')
    instance.removeClass('template')
    
    if !isUpdate?
      @options.beforeAdd instance if @options? and @options.hasOwnProperty('beforeAdd')
    
      unless @options and @options.hasOwnProperty('prependTo')         
        if @options and @options.hasOwnProperty('appendTo')
          instance.appendTo @options.appendTo
        else 
          instance.appendTo @templateHtml.parent()
      else
        instance.prependTo @options.prependTo
    
      @options.afterAdd instance if @options? and @options.hasOwnProperty('afterAdd')
    
    instance.show()
    return instance
  
  remove: (id) ->
    instance = @findInstance id, true
    @options.beforeRemove instance if @options.hasOwnProperty('beforeRemove')
    instance.remove()
    @options.afterRemove instance if @options.hasOwnProperty('afterRemove')   

  update: (data) ->
    instance = @findInstance data.id, true
    @options.beforeUpdate instance if @options.hasOwnProperty('beforeUpdate')
    instance.html @addItem(data, true).html()
    @options.afterUpdate obj if @options.hasOwnProperty('afterUpdate')

  clear: ->
    for instance in @findWithOrWithoutContainer('.'+@name, true)
      $(instance).remove() unless $(instance).hasClass('template')

  refresh: (data) ->
    @clear()
    @add data

  findInstance: (id, withScope) ->
    withScope = false if withScope is undefined
    if ("#{id}".match @name)?
      if ("#{id}".match '#')? then @findWithOrWithoutContainer(id, withScope) else @findWithOrWithoutContainer('#'+id, withScope) 
    else
      @findWithOrWithoutContainer('#'+@name+'_'+id, withScope)

  findWithOrWithoutContainer: (domElementIdentifier, withScope) ->
    if @options.hasOwnProperty('bindToContainer') and withScope
      $($.find("##{@options.bindToContainer.attr('id')} #{domElementIdentifier}"))
    else
      $($.find("#{domElementIdentifier}"))
