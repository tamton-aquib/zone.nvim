# ZONE
A screensaver plugin for neovim. Inspiration from: [emacs-zone](https://www.emacswiki.org/emacs/ZoneMode).<br/>
Currently WIP. Has some bugs.

#### Requirements:
- Neovim version >= 0.8

#### Installation:
```lua
use { 'tamton-aquib/zone.nvim' }
```

#### Usage:
```lua
require("zone").setup()
```
<details>
<summary> Click here to see default configuration </summary>

```lua
require('zone').setup {
    style = "treadmill",
    after = 30,          -- Idle timeout
    exclude_filetypes = { "TelescopePrompt", "NvimTree", "neo-tree", "dashboard", "lazy" },
    -- More options to come later

    treadmill = {
        direction = "left",
        headache = true,
        tick_time = 30,     -- Lower, the faster
        -- Opts for Treadmill style
    },
    epilepsy = {
        stage = "aura",     -- "aura" or "ictal"
        tick_time = 100,
    },
    dvd = {
        -- text = {"line1", "line2", "line3", "etc"}
        tick_time = 100,
        -- Opts for Dvd style
    },
    -- etc
}
```
</details>

#### Showcase:

> Treadmill
<!-- ![zone_treadmill](https://user-images.githubusercontent.com/77913442/166483843-970fb4b3-51cd-499c-9f39-da67d940eeb1.gif) -->
https://user-images.githubusercontent.com/77913442/214005406-e5f6e311-8868-44c9-a0a9-3d3640222364.mp4

> Dvd

![zone_dvd](https://user-images.githubusercontent.com/77913442/166483923-94488f6a-5a11-4d01-8ff2-a9b2df929964.gif)

> Epilepsy

<!-- ![zone_epilepsy](https://user-images.githubusercontent.com/77913442/192028416-7406d801-ad8b-4c39-9df1-96ee3e65fad0.gif) -->
https://user-images.githubusercontent.com/77913442/214006320-bd2a1c50-b722-44b1-a453-9d817eb68bbe.mp4

> Vanish

![zone_vanish](https://user-images.githubusercontent.com/77913442/166484010-62037c22-983e-473d-b66c-d5ccf563102f.gif)

#### Note:
> ❗ This plugin wont eat the current buffer. It just emulates the content as a cover on top.

### Todo:
Moved to [todo.norg](https://github.com/tamton-aquib/zone.nvim/blob/main/todo.norg)
