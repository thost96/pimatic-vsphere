$(document).on( "templateinit", (event) ->

  class vSphereControlItem extends pimatic.DeviceItem
    
    constructor: (data, @device) ->
      super(data, @device)
      @id   = @device.id
      @name = @device.name

      attribute = @getAttribute("state")
      @state = ko.observable attribute.value()
      attribute.value.subscribe (newValue) =>
        @state newValue   
      
    afterRender: (elements) ->
      super(elements)      

    onPowerOn: ->
      $.get("/api/device/#{@id}/powerAction?action=on")

    onPowerOff: ->
      $.get("/api/device/#{@id}/powerAction?action=off")

    onPowerRestart: ->
      $.get("/api/device/#{@id}/powerAction?action=restart")
   
  # register the item-class
  pimatic.templateClasses['vSphereControl'] = vSphereControlItem
)  