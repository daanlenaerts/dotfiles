-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- Optimized for retina-class 2x displays, like 13" 2.8K, 27" 5K, 32" 6K.
hl.env("GDK_SCALE", "1")

-- By default: extend to the right.
-- hl.monitor({ output = "", mode = "preferred", position = "720x0", scale = 1.33333 })

hl.monitor({ output = "eDP-1", mode = "preferred", position = "-1080x0", scale = 1.33333 })

-- Thuis
hl.monitor({ output = "desc:AOC Q2790 GQMKCHA015919", mode = "preferred", position = "-3820x-1440", scale = 1 })
-- hl.monitor({ output = "desc:AOC Q2790 GQMKCHA015919", mode = "preferred", position = "-1440x-2190", scale = 1, transform = 1 })
hl.monitor({ output = "desc:AOC Q2790 HBDL5HA000638", mode = "preferred", position = "-1260x-1440", scale = 1 })

-- Vandijck
hl.monitor({
  output = "desc:Philips Consumer Electronics Company PHL 275E2F UHB2141010561",
  mode = "preferred",
  position = "-2560x-1440",
  scale = 1,
})
hl.monitor({
  output = "desc:Philips Consumer Electronics Company PHL 275E2F UHB2141010560",
  mode = "preferred",
  position = "0x-1440",
  scale = 1,
})

-- Vandijck boven
hl.monitor({ output = "desc:LG Electronics LG HDR 4K 0x000235CE", mode = "preferred", position = "-1920x-2160", scale = 1 })

-- Vandijck vergaderzaal
-- hl.monitor({ output = "DP-4", mode = "preferred", position = "720x0", scale = 1.333 })

-- Thuis 4K
hl.monitor({ output = "desc:LG Electronics LG ULTRAFINE 509NTWGL8793", mode = "preferred", position = "-5760x-2160", scale = 1 })
hl.monitor({ output = "desc:LG Electronics LG ULTRAFINE 509NTGYL8927", mode = "preferred", position = "-1920x-2160", scale = 1 })

-- Corda 4K
hl.monitor({ output = "desc:Dell Inc. DELL P3225QE 9KD6G84", mode = "preferred", position = "-5760x-2160", scale = 1 })
hl.monitor({ output = "desc:Dell Inc. DELL P3225QE BZ46G84", mode = "preferred", position = "-1920x-2160", scale = 1 })

-- Reserve room on the left of the first workspace on the ultrawide-ish 4K
-- screens. Omarchy 4 handles the lid switch itself, so the old bindl rules that
-- disabled and restored eDP-1 are gone.
hl.workspace_rule({
  workspace = "w[t1]m[desc:LG Electronics LG ULTRAFINE 509NTWGL8793]",
  gaps_out = { top = 10, right = 10, bottom = 10, left = 1500 },
})
hl.workspace_rule({
  workspace = "w[t1]m[desc:Dell Inc. DELL P3225QE 9KD6G84]",
  gaps_out = { top = 10, right = 10, bottom = 10, left = 1500 },
})
