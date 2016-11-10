module.exports = {
	title: "WMI Device config schemas"
	vSphereControl: 
	  	title: "vSphereControl config options"
	  	type: "object"
	  	properties: 
        state:
          description: "virtual machine power state"
          type: "string"
        vmid:
          description: "virtual machine id"
          type: "number"
        interval:
          description: "interval for refreshing virtual machine states"
          type: "number"
          default: 60000
}