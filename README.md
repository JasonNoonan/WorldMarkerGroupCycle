# Description

AddOn expanding on [World Marker Cycler](https://wago.io/koguSJAuR) by Clove.

Same basic idea, will cycle through the defined group of world markers, with keybinds for placing markers and clearing markers.

Expanded functionality includes:

1. The ability to add profiles to manage different cycle groups of world markers
   1. Example: You use `Default` to handle the normal 8-marker rotation, but `Ovinax` to rotate through just 4 markers.
1. Uses the default Blizzard keybind system to allow for more keybinding options, namely the ability to use the mousewheel as a keybind easily.

# How to Use

World Marker Group Cycle comes with a few console commands:

- `/wmgc` - Load the profile GUI, which lets you switch between profiles and modify the cycle groups (marker order, number of markers)
- `/wmgc print` - Print the marker order for your currently selected profile
- `/wmgc new <profile_name>` - Create a new profile named `<profile_name>`, and switch to it.
- `/wmgc switch <profile_name>` - Switch to the named profile. Both `new` and `switch` use the `AceDB:SetProfile()` function behind the scenes, so technically these two options behave the same.
- `/wmgc delete <profile_name>` - Delete the named profile. Silently fails if the profile doesn't exist. Cannot be the current profile.
