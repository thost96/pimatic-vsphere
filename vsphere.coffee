module.exports = (env) ->

  Promise = env.require 'bluebird'
  _ = env.require 'lodash'
  nvs = require 'vsphere'
  exec = require 'node-ssh-exec'
  
  class vSphereClient extends env.plugins.Plugin

    init: (app, @framework, @config) =>
      ###
      #param @host  = target vcenter server or esxi host
      #param @user  = vcenter or esxi root user
      #param @pass  = vcenter or esxi root user password
      #param @ssl   = verify ssl (true|false)
      #param @debug = debug output (on|off)
      ###      
      @host   = @config.host
      @user   = @config.user
      @pass   = @config.password
      @ssl    = @config.ssl
      debug  = @config.debug

      @vc = new nvs.Client(@host, @user, @pass, @ssl) 

      deviceConfigDef = require("./device-config-schema")
      @framework.deviceManager.registerDeviceClass 'vSphereControl', 
        configDef: deviceConfigDef.vSphereControl
        createCallback: (config, lastState) => new vSphereControl(config, @, lastState)
      
      @framework.deviceManager.on 'discover', (eventData) =>
        @framework.deviceManager.discoverMessage('pimatic-vsphere', "scanning vsphere host for virtual machines")
        
        @vc.getVMinContainerPowerState(@vc.serviceContent.rootFolder).once('result', (result) =>
          for i, vm of result
            do (vm) =>
              if debug
                env.logger.debug JSON.stringify(vm)

              deviceConfig = 
                id: "vsphere-control-" + vm.name
                name: vm.name
                class: 'vSphereControl'
                state: vm.powerState
                vmid: vm.obj[Object.keys(vm.obj)[1]]

              @framework.deviceManager.discoveredDevice 'pimatic-vsphere', "#{deviceConfig.name}", deviceConfig
        )

      @framework.on "after init", =>
        mobileFrontend = @framework.pluginManager.getPlugin 'mobile-frontend'
        if mobileFrontend?
          mobileFrontend.registerAssetFile 'js', "pimatic-vsphere/devices/vspherecontrol-template.coffee"
          mobileFrontend.registerAssetFile 'html', "pimatic-vsphere/devices/vspherecontrol-template.html"
        else
          env.logger.warn "vshpere could not find the mobile-frontend. No gui will be available"
 

  class vSphereControl extends env.devices.Device

    template: "vSphereControl" 

    attributes:
      state:
        description: "virtual machine state"
        type: "string"

    actions:
      powerAction:
        params:
          action:
            type: "string"
      sshCommand:
        params:
          command:
            type: "string"

    ###
    #param @config device configuration
    #param @plugin used for plugin wide debug settings (true or false)
    #param @lastStae is the last state saved from sqlite db
    ### 
    constructor: (@config, @plugin, lastState) ->
      ###
      #param @id    = device id set by user
      #param @name  = device name set by user
      #param @state = virtual machine power state
      #param @debug = plugin wide debug setting (true or false)
      #param @timers used for clearing Intervals on destroy
      ###
      @id = @config.id
      @name = @config.name 
      @state = lastState?.state?.value or @config.state 
      @vmid = @config.vmid
      @debug = @plugin.config.debug  
      @timers = []   
      @timers.push setInterval( ( => 
          @getState()
        ), @config.interval
      )
      super(@config, @plugin, lastState)

    destroy: () ->
      for timerId in @timers
        clearInterval timerId
      super()

    getState: () ->  
      if @debug
        env.logger.debug @state
      Promise.resolve @state

    powerAction: (action) ->
      if @debug
        env.logger.debug "button #{action} for #{@config.name} was pressed"
      switch action.toString()
        when "on" then @sshCommand("vim-cmd vmsvc/power.on #{@config.vmid}")
        when "off" then @sshCommand("vim-cmd vmsvc/power.off #{@config.vmid}")
        when "restart" then @sshCommand("vim-cmd vmsvc/power.reboot #{@config.vmid}")

    sshCommand: (@command) ->
      #https://www.npmjs.com/package/node-ssh-exec
      config = {
        host: @plugin.host,
        username: @plugin.user,
        password: @plugin.pass
      }
      exec(config, @command, (error, response) ->
          if error 
            env.logger.error error
          else
            env.logger.info response                  
      )

  return new vSphereClient