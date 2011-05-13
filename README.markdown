INSTALLING AND RUNNING
=====

If you wish to run this code, you will need to:

1. Make a PlayerIO account and follow their setup instructions
2. Replace their Game.cs with the Game.cs located inside this repo
3. Put your own game id inside Net.as
4. Build the SWF

CLIENT
=====

### FlashPunk Engine

The FlashPunk used here is the same fork of the engine as https://github.com/SelfPossessed/FlashPunk.

For convenience, the packages were renamed to simply flashpunk as having a net folder was annoying. Debug console code was commented out for speed purposes. Small changes were also made, like making FP.time public to reduce getTimer() calls, making the recycled singly linked list into a doubly linked one, and adding an unrecycled function to allow rollbacks to function properly. These changes may cause frustrations when merging with other forks.

The fork adds rollback capability for Worlds and Entities. However, due to the usage of linked lists and recycling, the order of updates is not guaranteed between different clients. Entity updates are therefore divided into two steps; preUpdate and update. Collision checks are done in preUpdate, after which flags for changes to be made are set. The update function then applies the changes.

### Logging

Log information is sent via ExternalInterface to be printed out by JavaScript. This means that you cannot run the code within FlashDevelop. This was done so that debugging between different computers was as simple as copying and pasting the output from a textarea.

### Timestep

The client runs at a fixed timestep of 20 milliseconds. The max framerate is therefore 50. The fixed timestep makes physics easier and reduces bandwidth (sending frames is cheaper than sending milliseconds) at the cost of slight CPU performance.

SERVER
=====

The code is developed with peer to peer in mind. However, to avoid requiring users to open ports in their firewall/router, PlayerIO servers are used as a middleman, which bounces packets to opponents. The server is not an authoritave server. Since PlayerIO uses TCP, the code assumes in order guaranteed delivery of packets.

The server does not attempt to get two players with vastly different pings to start the game at approximately the same time yet.

ROLLBACK
=====

### Data

Command inputs, such as W pressed or W released, and the frames they were executed on are sent between clients immediately. No game state information, such as X,Y positions or physics, are sent. No interpolation is used.

Commands are stored in a datastructure in the order of frames.

### Concept

There are two versions of the game state running simultaneously.

The true state is completely accurate and always behind in terms of time. In other words, the data is old but reliable. It runs silently in the background.

The perceived state is up to date in terms of time but never guaranteed to be accurate. This is what is displayed to the user. It is used as a form of latency hiding.

When an opponent's command is received, the true state is updated to the received frame. This is done because the game knows that everything before a received opponent frame is definite and accurate. The perceived state is then rolled back to the true state to accomodate the new changes. It is then updated to the current frame.

### Example

> #### Player1 Side

1. Player1 executes a command
2. Command is executed locally in the perceived state
3. Command is stored in the datastructure
4. Command is sent through PlayerIO to player2
5. Changes due to command are rendered

># ### Player2 Side

1. Player2 receives the command
2. Command is stored in the datastructure
3. True state is updated to the timestamp of the command
4. Commands up to that timestamp (including the just received one) are executed in the true state
5. Perceived state is rolled back to the true state
6. Perceived state is updated to the current time, executing any remaining stored commands
7. Changes due to the received command are rendered

### Pausing/Slowdown

No pausing occurs, even during lag or CPU spikes. The rollback will simply be very sudden and jarring.