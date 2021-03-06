fs = require 'fs' 
props = require 'props'
winston = require 'winston'

default_file_name = '.taliesin.properties'
default_file_path = process.env[if process.platform is 'win32' then 'USERPROFILE' else 'HOME'] + '/' + default_file_name

configuration = (callback, path = default_file_path, create = true) ->
   fs.readFile path, (err, data) ->
      if (err)
         if(create)
            fs.open path, 'a', (err, fd) ->
               fs.close fd
         callback {}
      else
         callback(props data)

init_logger = (verbose = false) ->
   @logger = new winston.Logger({
      transports: [
         new (winston.transports.Console) {
            level: if verbose then "verbose" else "info"
         }
      ]
   }).cli()

valid_properties = (object, props...) ->
   result = true
   result = result and prop of object for prop in props
   result

module.exports = {
   configuration: configuration,
   init_logger: init_logger,
   logger: @logger,
   valid_properties: valid_properties
}
