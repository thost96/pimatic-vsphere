# pimatic-vsphere

[![npm version](https://badge.fury.io/js/pimatic-vsphere.svg)](http://badge.fury.io/js/pimatic-vsphere)
[![dependencies status](https://david-dm.org/thost96/pimatic-vsphere/status.svg)](https://david-dm.org/thost96/pimatic-vsphere)

A pimatic plugin to control virtual machines on remote vmware vsphere host. 

## Plugin Configuration
	{
          "plugin": "vsphere",
          "host": "192.168.1.1",
          "password": "password"
    }
The plugin has the following configuration properties:

| Property          | Default  | Type    | Description                                 |
|:------------------|:---------|:--------|:--------------------------------------------|
| host              | -        | String  | Hostname or IP address of the vSphere Host|
| user  			| root 	   | String  | vsphere host admin user |
| password 			| - 	   | String  | Password for the user specified |
| ssl				| false	   | Boolean | verify ssl certificate, default false |
| debug             | false    | Boolean | Debug mode. Writes debug messages to the pimatic log, if set to true |


## Device Configuration
Please use the autodiscovery funtion on the devices page. This will display your virtual machines and fill all needed information automatically. 

This manual configuration can be done, if nessesary:

#### vSphereControl
The vSphereControl displays the powerState of the virtual machine and three buttons for PowerOn, PowerOff and Restart. 

	{
			"id": "wmi1",
			"class": "WmiSensor",
			"name": "WMI Sensor",
			"host": "",			
			"username": "",
			"password": "",
			"command": ""
	}

| Property          | Default  | Type    | Description                                 |
|:------------------|:---------|:--------|:--------------------------------------------|
| state             | -        | String  | virtual machine power state |
| vmid	 			| - 	   | String  | virtual machine identifier used for power actions |
| interval 			| 60000    | Number  | The time interval in milliseconds at which the powerState is updated |


## ToDo

* Add virtual machine performance monitoring device
* Add vsphere control device

## History

See [Release History](https://github.com/thost96/pimatic-vsphere/blob/master/History.md).

## License 

Copyright (c) 2016, Thorsten Reichelt and contributors. All rights reserved.

License: [GPL-2.0](https://github.com/thost96/pimatic-vsphere/blob/master/LICENSE).