# ZONE
A screensaver plugin for neovim. Inspiration from: [emacs-zone](https://www.emacswiki.org/emacs/ZoneMode).<br/>
Currently WIP. Has some bugs.

#### Requirements:
- Neovim version >= 0.7

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
    -- More options to come later

    treadmill = {
        direction = "left",
        -- Opts for Treadmill style
    },
    epilepsy = {
        stage = "aura", -- "aura" or "ictal"
        -- etc.
    },
    dvd = {
        -- Opts for Dvd style
    },
    -- etc
}
```
</details>

#### Showcase:

> Treadmill

![zone_treadmill](https://user-images.githubusercontent.com/77913442/166483843-970fb4b3-51cd-499c-9f39-da67d940eeb1.gif)

> Dvd

![zone_dvd](https://user-images.githubusercontent.com/77913442/166483923-94488f6a-5a11-4d01-8ff2-a9b2df929964.gif)

> Epilepsy

![zone_epilepsy](https://user-images.githubusercontent.com/77913442/192028416-7406d801-ad8b-4c39-9df1-96ee3e65fad0.gif)

> Vanish

![zone_vanish](https://user-images.githubusercontent.com/77913442/166484010-62037c22-983e-473d-b66c-d5ccf563102f.gif)

#### Note:
> ❗ This plugin wont eat the current buffer. It just emulates the content as a cover on top.

### Todo:
- [ ] Add user config options.
- [ ] Better core helper functions.
- [ ] Performance improvements.
- [ ] Remove logical bugs (especially with other modes)
- [ ] Add styles:
    - [x] Running text: `treadmill`
    - [x] Classic DVD screensaver: `dvd`
    - [ ] Falling letters: `fall`
    - [ ] Trembling effect: `earthquake`
    - [x] Vanishing letters: `vanish`
    - [ ] Switching cases: `burn`
    - [x] Changing highlights: `epilepsy`
    - [ ] Matrix effect: `matrix`
    - [ ] Random style: `random`
- [ ] Write some docs for creating custom styles.
