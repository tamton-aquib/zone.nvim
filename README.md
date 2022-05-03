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
    after = 10,          -- Idle timeout

    treadmill = {
        direction = "left",
        -- Opts for Treadmill style
    },
    dvd = {
        -- Opts for Dvd style
    },
    -- etc
}
```
</details> <br />

#### Showcase:

> Treadmill

> Dvd

> Vanish


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
    - [ ] Random style: `random`
- [ ] Write some docs for creating custom styles.
