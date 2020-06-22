# Data Specs

Godot sends user data to the server in the form of a JSON object via an HTTP `POST` request. This payload is the basis of all analysis and is thoroughly documented on this page. 

*Table of Contents*: 
[[0. Overview: ]] overall structure
[[1. JSON Contents]] detailed description of every key and its content
[[2. Send Schedule:]] when is the JSON sent and 
[[3. Implications for Analysis]]: Data duplication, data loss, etc. 

## 0. Overview

*The data life cycle:*

* Every time the user interacts with the screen (touch, swipe) data associated with the interaction is created and appended to a series of lists _stored in memory_.
* This data is written to a json file on local disk (from memory) as soon as (a) an individual puzzle is solved or (b) the app is pushed to the background. (:exclamation: implications for analysis: possible to have incomplete data for a puzzle that's neither won or lost) 
  * Note: data from multiple puzzles are written to _the same json file_. This bundle is referred to as a "session". 
* An attempt to send the file to server occurs in the following circumstances: 
    (a) the user reaches the end of the level (either by hitting the minimum threshold for passing the level and thus losing, or by winning enough puzzles to succesfully reach the end of the level). 
    (b) the user pushes the the app to background (:exclamation: it's possible to have multiple identical entries in the db with the exact same content)
    (c) user exits the game before finishing all puzzles (i.e. before winning or losing the level). 
    (d) when the user first opens the app (enters home screen). This is for cases where there remain files on disk that were not succesfully sent to the server

* Session files on disk are deleted as soon as they were sent succesfully to the server (200 response). 
* The server stores the JSON as a file on disk as well as by committing it to SQL with the following fields: 
  * 
    




## 1. The Content

### Overview

`mo_`: mouse aka tap/drag data

`ba_`: "ball" aka collectible object

`sw_`: subwave aka single puzzle

`device_`: 


### `mo_time`: ABSOLUTE TIME

"mo_x":[], #POSITION X
"mo_y":[], #POSITION Y
"mo_lobe":[], #WHICH SLICE
level: level number #NUMBER OF LEVEL
"mo_press_time":[],  #RELATIVE TIME IN THE LEVEL (time of n.X)
"mo_act_drag":[], #DRAG OR TAP
"mo_move_time":[], #DURATION OF DRAG/TAP
"mo_fake_release":[], #SUCCESSFUL DRAG  (for collect)
"ba_position":[], #STATUS OF SLICE YOU’RE ACTING ON
"ba_ID":[], #SLICE YOU’RE ACTING ON
“ba_age”:[] #size at which target is collected
“ba_time”:[] #time at which target is collected
"sw_time":[], #RELATIVE TIME IN THE WAVE (time of X.n)
"sw_num":[], #NUMBER OF WAVEen the shell displays the branch name, the shell will execute nastyScript which should be in the local directory.
"sw_offset":[], #slice index ofset
"sw_flip" : [], #flipped or not
"device_current_time":OS.get_datetime(), #local time
"device_OS": OS.get_name(), #OS VERSION
"device_kb_locale":OS.get_locale(), #IP -- PT ? EN ?
"device_name":OS.get_model_name(), #MODELO DO APARELHO
"device_screensize_x":OS.get_screen_size().x, #RES x
"device_screensize_y":OS.get_screen_size().y, #RES Y
"device_timezone":OS.get_time_zone_info(), #TIMEZONE
"device_dpi":OS.get_screen_dpi(), #DPIS
"device_IP": IP.get_local_addresses(), #IP
"OS_start_time": OS.get_ticks_msec(), # time since current login
collect_status #BOOLEAN
