#!/bin/bash

TICKPORT=33450
RDBPORT=$((TICKPORT+1))
HDBPORT=$((TICKPORT+2))

# Start a new session with name "tick-setup".
tmux -2 new-session -d -s tick-setup

# In this session, create a new window called "kdb-tick".
tmux new-window -t tick-setup: -n 'kdb-tick'

# Split this window horizontally.
tmux split-window -h

# Select the first pane and split it vertically.
tmux select-pane -t 0
tmux split-window -v

# Select the pane on the right and split it vertically also.
tmux select-pane -t 2
tmux split-window -v

# We now have four panes open and can start up tick.q.
tmux select-pane -t 0
tmux send-keys "q tick.q sym hdb -p $TICKPORT" C-m

# Navigate to the next window and start up the RDB.
tmux select-pane -t 1
tmux send-keys "q tick/r.q :$TICKPORT :$HDBPORT -p $RDBPORT" C-m

# Navigate to the next window and start the HDB
tmux select-pane -t 2
tmux send-keys "q hdb/sym -p $HDBPORT" C-m

# Navigate to the final window and start up the feed.
tmux select-pane -t 3
tmux send-keys "q feed.q -t 500" C-m

# Attatch to the session.
tmux -2 a -t tick-setup
