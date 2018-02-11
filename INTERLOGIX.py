#!/usr/bin/python3

import sys
import json
#import requests
import MySQLdb as DB
import time, datetime
import math
import paho.mqtt.client as mqtt
import signal
import secrets

print("Starting up")

db_user = secrets.db_user
db_pass = secrets.db_pass
db_host = secrets.db_host
db_database = secrets.db_database

mqtt_broker = secrets.mqtt_broker

# Connect to MQTT
mqtt_client = mqtt.Client()
mqtt_client.connect( mqtt_broker )
mqtt_client.loop_start()

# Connect to the database
db_conn = DB.connect(host = db_host, user = db_user, passwd = db_pass, db = db_database )
db_cur  = db_conn.cursor()

# Run the query loop
loop_ctl = True
while loop_ctl:

 try:

   line = sys.stdin.readline()
   parsed = json.loads( line )

   #Log the line into the database
   query  = "Insert into `log` (`idx`, `timestamp`, `timestamp_string`, "
   query += "`device_idx`, `device_idx_hex`, `device_type`, "
   query += "`battery_low`, `latch0`, `latch1`, `latch2`, `latch3`, `latch4`, "
   query += "`raw_message`, `raw_hex`)"
   query += " VALUES (NULL, "
   query += str( int( time.mktime( datetime.datetime.strptime( parsed['time'], "%Y-%m-%d %H:%M:%S").timetuple() ) ) ) + ', '
   query += '"' + parsed['time'] + '", '

   query += str( int( parsed['device_serial'], 16 ) ) + ', '
   query += '"' + parsed['device_serial'] + '", '
   query += str( int( parsed['device_type'  ], 16 ) ) + ', '

   query += "0, " if parsed['low_battery'] == "off" else "1, "
   query += "0, " if parsed['f1_latch_state'] == "open" else "1, "
   query += "0, " if parsed['f2_latch_state'] == "open" else "1, "
   query += "0, " if parsed['f3_latch_state'] == "open" else "1, "
   query += "0, " if parsed['f4_latch_state'] == "open" else "1, "
   query += "0, " if parsed['f5_latch_state'] == "open" else "1, "

   query += str( int( parsed['device_raw_message'], 16 ) ) + ', '
   query += '"' + parsed['device_raw_message'] +'" '
   query += " )"

   try:
     db_cur.execute( query )
     db_conn.commit()
     print( "SUCCESS: " + line )
   except:
     db_conn.rollback() 
     print( "FAILED: " + query )

  
   #Home Assistant MQTT message formatting
  
   try:
     query = "SELECT `MQTT_topic` FROM `known_devices` join `ha_mqtt_channels` on known_devices.idx = ha_mqtt_channels.idx WHERE `device_idx` = " + str( int( parsed['device_serial'], 16 ) )
     db_cur.execute( query )
     result = db_cur.fetchall()
     if not result: continue

     MQTT_topic = result[0][0]

     query = "SELECT * from `ha_field_map` where `device_type_idx` = " + str( int( parsed['device_type'  ], 16 ) )
     db_cur.execute( query )
     result = db_cur.fetchall()
     if not result: continue

     data = {}

     for line in result:
       data[ line[3] ] = parsed[ line[2] ]

     jstring = json.dumps( data )

     print( "publishing " + MQTT_topic + ": " + jstring )
     print( "" )
     print( "--------------------------------------------")

     mqtt_client.publish( MQTT_topic, jstring )

   except:
      print("MQTT error")

 except KeyboardInterrupt:
   print("Exiting")
   loop_ctl = False

db_conn.close()
