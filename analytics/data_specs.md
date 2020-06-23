# Data Specs

Godot sends user data to the server in the form of a JSON object via an HTTP `POST` request. This payload is the basis of all analysis and is thoroughly documented on this page. 

*Table of Contents*: 

[0. Overview: ](#overview) overall structure

[1. Life Cycle: ](#life-cycle) Overview of the life cycle of data from creation to deletion. 

[2. JSON Contents: ](#json-contents) detailed description of every key and its content

[3. Send Schedule:]() when is the JSON sent and 

[4. Implications for Analysis:]() Data duplication, data loss, etc. 


## Overview

User data is first stored in memory, then written to file on the device, then sent to remote server which saves is on disk but also in a database. The files on the local device's disk are deleted upon succesful transmission to remove server. The database is dumped (backed up) every 24 hrs.  


## Life Cycle

*The data's life cycle:*

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
    


## JSON Contents

### Overview

`mo_`: mouse aka tap/drag data

`ba_`: "ball" aka collectible object

`sw_`: subwave aka single puzzle

`device_`: 



### Real Example

Sample JSON from db:

```
json_raw = '{"mo_x": [-97.381409, -101.270752, -88.491577, -84.046631, -91.269653, 28.743347, 7.074341, 22.075989, 20.409119, 23.187195, 20.964722, 20.409119, -9.594116], "mo_y": [83.333344, 80.000031, 62.777802, 62.777802, 68.333344, 21.666687, -155, -156.666656, -155, -158.333328, -166.666656, -171.111099, -62.222214], "ba_ID": [0, 0], "level": 1, "ba_age": [5, 6], "ba_time": [367116, 371651], "mo_lobe": [2, 2, 2, 2, 2, 2, 4, 4, 4, 4, 4, 4, 4], "mo_time": [365058, 365225, 365387, 365525, 365671, 366832, 368991, 369122, 369272, 369396, 369545, 369694, 371364], "sw_flip": [0, 1, 0], "sw_time": [364339, 367914, 373764], "version": 1.08, "focus_in": [379081, 386834], "rand_pos": 2, "device_ID": "a3f1ef82e68aa9bb", "device_IP": ["192.168.1.66", "2001:569:7ac6:6900:1457:626f:c220:f868", "2001:569:7ac6:6900:ee9b:f3ff:fe96:3eb5", "fe80:0:0:0:ee9b:f3ff:fe96:3eb5", "fe80:0:0:0:ec9b:f3ff:fe96:3eb5", "127.0.0.1", "0:0:0:0:0:0:0:1"], "device_OS": "Android", "focus_out": [374954, 381247], "level_won": false, "sw_offset": [1, 3, 4], "user_quit": false, "device_dpi": 420, "drone_play": [374062], "mo_press_x": [-96.825806, -101.270752, -87.935974, -83.491028, -90.158447, -168.500244, 7.074341, 22.075989, 19.297913, 22.631592, 20.409119, 19.853516, 0.406982], "mo_press_y": [82.777802, 80.000031, 61.666687, 62.222229, 67.777802, 120.555573, -155, -156.666656, -155, -158.333328, -167.222214, -171.666656, -195], "repeat_bad": 2, "ba_position": [1, 3], "device_name": "SM-N920W8", "mo_act_drag": [0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1], "sw_time_end": [367116, 371651], "total_saves": 13, "max_unlocked": 1, "mo_move_time": [365057, 365371, 365387, 365525, 365670, 365670, 366725, 366743, 366761, 366778, 366796, 366814, 366832, 369254, 369271, 369395, 369529, 369694, 371282, 371298, 371315, 371331, 371363, 371364], "OS_start_time": 364316, "mo_move_pos_x": [-97.381409, -88.491577, -88.491577, -84.046631, -91.269653, -91.269653, -167.944641, -166.277771, -161.277283, -152.38739, -133.49646, -101.270752, 28.743347, 19.853516, 20.409119, 23.187195, 20.964722, 20.409119, 0.406982, -0.148682, -1.259888, -4.037964, -9.038513, -9.594116], "mo_move_pos_y": [83.333344, 62.222229, 62.777802, 62.777802, 67.777802, 68.333344, 120.000031, 118.888916, 117.222229, 112.777802, 102.777802, 85.555573, 21.666687, -155, -155, -158.333328, -166.666656, -171.111099, -194.444443, -192.222214, -182.222214, -160, -76.111099, -62.222214], "mo_press_time": [365039, 365192, 365338, 365486, 365635, 366691, 368974, 369089, 369218, 369360, 369496, 369641, 371266], "device_ID_rand": 2846276096, "device_ID_time": 1592595456, "failure_thresh": 15, "sw_subwave_num": [0, 1, 5], "device_timezone": {"bias": -420, "name": "PDT"}, "mo_fake_release": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], "device_kb_locale": "en_CA", "mo_act_taken_act": [50, 0, 0, 0, 0, 0, 2, -1962528752, 0, 0, 0, 0, 0, 0, 2, -1962528752], "mo_act_taken_pos": [-1, 1, 1, 1, 1, 1, 1, -1, 3, 3, 3, 3, 3, 3, 3, -1], "mo_act_taken_time": [364621, 365338, 365652, 365952, 366254, 366565, 367116, 368208, 369289, 369598, 369905, 370218, 370532, 370835, 371668, 371976, 374062], "device_current_time": {"day": 22, "dst": true, "hour": 14, "year": 2020, "month": 6, "minute": 51, "second": 40, "weekday": 1}, "device_screensize_x": 1920, "device_screensize_y": 1080, "device_video_driver": 0}'
```

The json above is organized below with one key and its value printed per line, ordered first by type (lists first, everything else second), category (`mo_`, `sw_`, etc.), and size (if list), respectively. The number in parenthesis is the size of the list: 

```
drone_play                    (1) : [374062]
mo_act_drag                  (13) : [0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1]
mo_fake_release              (13) : [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
mo_lobe                      (13) : [2, 2, 2, 2, 2, 2, 4, 4, 4, 4, 4, 4, 4]
mo_press_time                (13) : [365039, 365192, 365338, 365486, 365635, 366691, 368974, 369089, 369218, 369360, 369496, 369641, 371266]
mo_press_x                   (13) : [-96.825806, -101.270752, -87.935974, -83.491028, -90.158447, -168.500244, 7.074341, 22.075989, 19.297913, 22.631592, 20.409119, 19.853516, 0.406982]
mo_press_y                   (13) : [82.777802, 80.000031, 61.666687, 62.222229, 67.777802, 120.555573, -155, -156.666656, -155, -158.333328, -167.222214, -171.666656, -195]
mo_time                      (13) : [365058, 365225, 365387, 365525, 365671, 366832, 368991, 369122, 369272, 369396, 369545, 369694, 371364]
mo_x                         (13) : [-97.381409, -101.270752, -88.491577, -84.046631, -91.269653, 28.743347, 7.074341, 22.075989, 20.409119, 23.187195, 20.964722, 20.409119, -9.594116]
mo_y                         (13) : [83.333344, 80.000031, 62.777802, 62.777802, 68.333344, 21.666687, -155, -156.666656, -155, -158.333328, -166.666656, -171.111099, -62.222214]
mo_act_taken_act             (16) : [50, 0, 0, 0, 0, 0, 2, -1962528752, 0, 0, 0, 0, 0, 0, 2, -1962528752]
mo_act_taken_pos             (16) : [-1, 1, 1, 1, 1, 1, 1, -1, 3, 3, 3, 3, 3, 3, 3, -1]
mo_act_taken_time            (17) : [364621, 365338, 365652, 365952, 366254, 366565, 367116, 368208, 369289, 369598, 369905, 370218, 370532, 370835, 371668, 371976, 374062]
mo_move_pos_x                (24) : [-97.381409, -88.491577, -88.491577, -84.046631, -91.269653, -91.269653, -167.944641, -166.277771, -161.277283, -152.38739, -133.49646, -101.270752, 28.743347, 19.853516, 20.409119, 23.187195, 20.964722, 20.409119, 0.406982, -0.148682, -1.259888, -4.037964, -9.038513, -9.594116]
mo_move_pos_y                (24) : [83.333344, 62.222229, 62.777802, 62.777802, 67.777802, 68.333344, 120.000031, 118.888916, 117.222229, 112.777802, 102.777802, 85.555573, 21.666687, -155, -155, -158.333328, -166.666656, -171.111099, -194.444443, -192.222214, -182.222214, -160, -76.111099, -62.222214]
mo_move_time                 (24) : [365057, 365371, 365387, 365525, 365670, 365670, 366725, 366743, 366761, 366778, 366796, 366814, 366832, 369254, 369271, 369395, 369529, 369694, 371282, 371298, 371315, 371331, 371363, 371364]
ba_ID                         (2) : [0, 0]
ba_age                        (2) : [5, 6]
ba_position                   (2) : [1, 3]
ba_time                       (2) : [367116, 371651]
focus_in                      (2) : [379081, 386834]
focus_out                     (2) : [374954, 381247]
sw_time_end                   (2) : [367116, 371651]
sw_flip                       (3) : [0, 1, 0]
sw_offset                     (3) : [1, 3, 4]
sw_subwave_num                (3) : [0, 1, 5]
sw_time                       (3) : [364339, 367914, 373764]
device_IP                     (7) : ['192.168.1.66', '2001:569:7ac6:6900:1457:626f:c220:f868', '2001:569:7ac6:6900:ee9b:f3ff:fe96:3eb5', 'fe80:0:0:0:ee9b:f3ff:fe96:3eb5', 'fe80:0:0:0:ec9b:f3ff:fe96:3eb5', '127.0.0.1', '0:0:0:0:0:0:0:1']
++++++++++++++++++++
level                           : 1
version                         : 1.08
rand_pos                        : 2
device_ID                       : a3f1ef82e68aa9bb
device_OS                       : Android
level_won                       : False
user_quit                       : False
device_dpi                      : 420
repeat_bad                      : 2
device_name                     : SM-N920W8
total_saves                     : 13
max_unlocked                    : 1
OS_start_time                   : 364316
device_ID_rand                  : 2846276096
device_ID_time                  : 1592595456
failure_thresh                  : 15
device_timezone                 : {'bias': -420, 'name': 'PDT'}
device_kb_locale                : en_CA
device_current_time             : {'day': 22, 'dst': True, 'hour': 14, 'year': 2020, 'month': 6, 'minute': 51, 'second': 40, 'weekday': 1}
device_screensize_x             : 1920
device_screensize_y             : 1080
device_video_driver             : 0
```

</details>

The rest of this section provides detailed explanations for each key in the example above: 

#### `drone_play`

Example: 
```
drone_play                    (1) : [374062]
```

#### `mo_time`: 

ABSOLUTE TIME



"mo_x":[], #POSITION X

"mo_y":[], #POSITION Y

"mo_lobe":[], #WHICH SLICE

level: level number #NUMBER OF LEVEL

"mo_press_time":[],  #RELATIVE TIME IN THE LEVEL (time of n.X)

"mo_act_drag":[], #DRAG OR TAP

"mo_move_time":[], #DURATION OF DRAG/TAP

"mo_fake_release":[], #SUCCESSFUL DRAG  (for collect)

`mo_act_taken_act`: `[int]` 

```
16-mo_act_taken_act             : [50, 0, 0, 0, 0, 0, 2, -1962528752, 0, 0, 0, 0, 0, 0, 2, -1962528752]
```

`mo_act_taken_pos`: `[int]

```
16-mo_act_taken_pos             : [-1, 1, 1, 1, 1, 1, 1, -1, 3, 3, 3, 3, 3, 3, 3, -1]
```

`mo_act_taken_time`: `[int]`
```
17-mo_act_taken_time            : [364621, 365338, 365652, 365952, 366254, 366565, 367116, 368208, 369289, 369598, 369905, 370218, 370532, 370835, 371668, 371976, 374062]
```


"ba_position":[], #STATUS OF SLICE YOU’RE ACTING ON

"ba_ID":[], #SLICE YOU’RE ACTING ON

“ba_age”:[] #size at which target is collected

“ba_time”:[] #time at which target is collected

"sw_time":[], #RELATIVE TIME IN THE WAVE (time of X.n)

`sw_subwave_num`: `[int]` a list of integers, each corresponding to the unique identifier of a puzzle (as defined in the third column of `spawn.txt`)

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
