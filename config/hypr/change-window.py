#!/bin/env python3

import subprocess
import json

def get_windows(type: int):
    """get current all windows, and return a list
    type: 1-hyprland 2-sway
    """
    if(type == 1):
        pass
    elif(type == 2):
        raw = subprocess.check_output(['swaymsg', '-r', '-t', 'get_tree']) \
            .decode('UTF-8')
        raw = json.loads(raw)
        for output in raw['nodes']:
            # if(output['type'] == 'output'):
                # yield output['name']
        
        windows = []
        return windows
    else:
        exit()

def change_window(window: str, type_: int) -> None:
    """
    Changes the focus of the window on a Sway window manager.

    Args:
        window (str): The window's ID that should gain focus.
        type_ (int): The type of window focus change to be made. 
                     1 for workspace change, 2 for window focus change.

    Raises:
        ValueError: When the type_ argument is not 1 or 2.

    Returns:
        None
    """
    if type_ == 1:
        # Focus on workspace
        subprocess.call(['swaymsg', '-r', '-t', 'workspace', window])
    elif type_ == 2:
        # Focus on window
        subprocess.call(['swaymsg', '-r', '-t', 'focus', window])
    else:
        raise ValueError("Invalid type_ argument. Must be 1 or 2.") 

if __name__ == "__main__":
    get_windows(2)
