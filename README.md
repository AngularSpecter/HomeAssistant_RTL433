# HASS_RFLink

This project integrates GE Interlogix brand home security sensors with the Home Assistant home automation platform by using an RTLSDR to passively monitor the sensors.  The basic flow of the program is:

RTL_433 --( json )---> Interlogix.py ---( MQTT )---> HASS

A fork of the RTL_433 project is used to control the SDR, RX and demod the signal and generate json that is fed to the python script.  The python script reads the json data and interacts with a MySQL database to log the event and translate it into another json based message that is emitted to a Home Assistant instance via MQTT.  

The backend uses a MySQL database to define the mapping between the message output by RLT_443 and the output json MQTT message as well as the MQTT channel to be used.  

Installation and prereqs:

1.  Build and install RTL_433
   At this time, the main trunk of RTL_433 does not support Interlogix sensors, but the following fork does:
   
   https://github.com/baileybrent/rtl_433/
   
   Build and install according to the instructions.  Test the install by running:
   
   /rtl_433 -f 319500000 -R 98 -F json -q
   
   You should see messages like:
   
   {"time" : "2018-01-02 17:02:11", "model" : "GE Interlogix Device", "device_type" : "a", "device_type_name" : "contact sensor", "device_serial" : "a105bb", "device_raw_message" : "a11430", "low_battery" : "off", "f1_latch_state" : "close", "f2_latch_state" : "open", "f3_latch_state" : "close", "f4_latch_state" : "open", "f5_latch_state" : "open"}
   
 2.  Install MySql.  
     Install MySQL according to your distro and import tha MySQL.sql schema.  I suggest installing the full LAMP-server and phpmyadmin
     
 3.  Install python MySQL and MQTT bindings ( MySQLdb, phao-mqtt )
 
 4.  Update secrets.py with your database info and MQTT broker and run the `install` script.  This will install the INTERLOGIX.py and secrets.py file to `/usr/local/bin` and the systemd unit file. 
 
 5.  Test the system by pipeing RTL_433 output into the Interlogix.py script
 
      rtl_433 -f 319500000 -R 98 -F json -q | INTERLOGIX.py
      
      You should see data in the database updating and messages streaming in the console that look like:
      
      SUCCESS: {"time" : "2018-01-02 17:02:11", "model" : "GE Interlogix Device", "device_type" : "a", "device_type_name" : "contact sensor", "device_serial" : "a105bb", "device_raw_message" : "a11430", "low_battery" : "off", "f1_latch_state" : "close", "f2_latch_state" : "open", "f3_latch_state" : "close", "f4_latch_state" : "open", "f5_latch_state" : "open"}
      
      Database failures will result in the messages in the console being prefixed with FAILURE
      
      If all is working, exit the script.
 
 6. Start the daemon with `service RTL319 start`  
  
 7. Begin filling in the database as devices are discovered.
 
**Known_devices**

* device_idx = decimal device IDX from RTL_433 message (log.device_idx)
* DESCRIPTION = text description of the device

**device_types** : device type definitions

* device_type = numeric device type from RTL_433 message (log.device_idx)
* device_desc = text description of the device type

**ha_field_map** : device type specific message translation

* idx = device type id from RTL_433 message  (log.device_type)
* RTL433_field = json key in RTL_433 message ( low_battery | f[1:5]_latch_state )
* json_field      = corresponding key to send in mqtt message

**ha_mqtt_channels**: device specific MQTT channel definition

* idx = device idx from know_devices.device_idx (log.device_idx)
* DESCRIPTION = text description of the device
* MQTT_topic = mqtt to transmit device status updates on

     
The flow I recommend is to cycle a device and watch to log obtain it's device ID and latch mapping.  Then fill in the tables in the presented order.
  
  1. Associate the ID with a device name in the known_device table
  2. Add the device type to the device_types table if it isn't already in there
  3. Define the input->output key mapping for the mqtt message in the ha_field_map table
  4. Map the device ID to an output mqtt topic with the ha_mqtt_channels
  
MQTT message generation is completely dynamic.  Once enough information is present in the database to full translate an incoming message, the MQTT messages will be generated and published.  Only the last two tables are strictly necessiary, but the first two allow the log data to be translated into friendlier output with SQL joins to make analysis easier.


# Home Assistant configuration

The MQTT messages will come into home assistant with the format defined in the database.  An example yaml entry for a sensor is:

    binary_sensor:
      - platform: mqtt
        name: Door Front Position
        state_topic: 'home/door'
        value_template: '{{ value_json.position }}'
        payload_off: "closed"
        payload_on: "open"
        device_class: opening
        
This assumes that the door window sensor associated with the 'front door' is publishing to `home/door` with the latch from the RTL_433 message being translated to the json key `position`.
