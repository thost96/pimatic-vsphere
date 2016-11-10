module.exports = {
  title: "vsphere config options"
  type: "object"
  properties:
    host:
      description: "vsphere / esxi ip address or hostname"
      type: "string"
    user:
      description: "vsphere root user"
      type: "string"
      default: "root"
    password:
      description: "password for specified user"
      type: "string"
    ssl:
      description: "sslVerify"
      type: "boolean"
      default: false
    debug:
      description: "debug output"
      type: "boolean"
      default: false      
}