-- WeakAuras transmit table for "Black Blood of Y'Shaarj" (MoP Classic).
-- Structure mirrors real WeakAuras 5.19-5.21 exports (aurabar + subregions).

local GREEN  = {0.44313728809357, 0.69411766529083, 0.34117648005486, 1}  -- #71b157 (same as the ToT base aura)
local GOLD   = {0.90, 0.71, 0.13, 1}   -- #e6b422

local function auraTrigger(spellId)
  return {
    trigger = {
      type = "aura2",
      unit = "player",
      use_unit = true,
      debuffType = "HELPFUL",
      useExactSpellId = true,
      auraspellids = { spellId },
      matchesShowOn = "showOnActive",
      -- boilerplate fields WeakAuras writes on every trigger
      event = "Health",
      names = {},
      spellIds = {},
      subeventPrefix = "SPELL",
      subeventSuffix = "_CAST_START",
    },
    untrigger = {},
  }
end

local function subText(anchor, text, extraFormat)
  local t = {
    type = "subtext",
    text_visible = true,
    text_text = text,
    text_font = "Friz Quadrata TT",
    text_fontSize = 16,
    text_fontType = "OUTLINE",
    text_color = {1, 1, 1, 1},
    text_justify = "CENTER",
    text_selfPoint = "AUTO",
    text_automaticWidth = "Auto",
    text_fixedWidth = 64,
    text_wordWrap = "WordWrap",
    text_shadowColor = {0, 0, 0, 1},
    text_shadowXOffset = 0,
    text_shadowYOffset = 0,
    rotateText = "NONE",
    anchor_point = anchor,
    anchorXOffset = 0,
    anchorYOffset = 0,
  }
  for k, v in pairs(extraFormat) do t[k] = v end
  return t
end

local data = {
  id = "[Kende] BBY proc - bar",
  desc = "Author: Kendeclise. Black Blood of Y'Shaarj proc tracker (MoP Classic). Bar = 10 s of Wrath of the Darkspear with 1 tick per second; left text = stacks of Wrath (the real Intellect buff); bar turns gold from 9 stacks (snapshot window, lingers ~2 s after the bar ends). Plays an Error Beep sound on proc. Works for every item version.",
  uid = "BBoYS7kQ2xW",
  internalVersion = 82,
  tocversion = 50504,
  regionType = "aurabar",
  semver = "2.0.0",
  version = 1,
  url = "",

  -- Position relative to the parent group (the group itself sits at CENTER, 3/4 up)
  anchorFrameType = "SCREEN",
  anchorPoint = "CENTER",
  selfPoint = "CENTER",
  xOffset = 0,
  yOffset = 0,
  width = 300,
  height = 30,
  frameStrata = 1,
  alpha = 1,

  -- Bar
  orientation = "HORIZONTAL",
  inverse = true,               -- fills up as time passes
  smoothProgress = false,
  texture = "Solid",
  textureSource = "LSM",
  barColor = GREEN,
  barColor2 = {1, 1, 0, 1},
  enableGradient = false,
  gradientOrientation = "HORIZONTAL",
  backgroundColor = {0, 0, 0, 0.5},
  progressSource = {-1, ""},
  adjustedMax = "",
  adjustedMin = "",
  useAdjustededMax = false,
  useAdjustededMin = false,

  -- Icon (the trinket's own icon, left side)
  icon = true,
  icon_side = "LEFT",
  icon_color = {1, 1, 1, 1},
  iconSource = 0,
  displayIcon = "Interface\\Icons\\inv_jewelry_orgrimmarraid_trinket_02",
  desaturate = false,
  zoom = 0,

  -- Spark (off)
  spark = false,
  sparkTexture = "Interface\\CastingBar\\UI-CastingBar-Spark",
  sparkColor = {1, 1, 1, 1},
  sparkWidth = 10,
  sparkHeight = 30,
  sparkOffsetX = 0,
  sparkOffsetY = 0,
  sparkRotation = 0,
  sparkRotationMode = "AUTO",
  sparkBlendMode = "ADD",
  sparkHidden = "NEVER",

  subRegions = {
    { type = "subbackground" },
    { type = "subforeground" },
    -- Left: stacks of "Wrath" (trigger 2)
    subText("INNER_LEFT", "%2.s", {
      ["text_text_format_2.s_format"] = "none",
    }),
    -- Right: remaining time of the active trigger
    subText("INNER_RIGHT", "%p", {
      text_text_format_p_format = "timed",
      text_text_format_p_time_format = 0,
      text_text_format_p_time_precision = 1,
      text_text_format_p_time_dynamic_threshold = 60,
      text_text_format_p_time_legacy_floor = false,
      text_text_format_p_time_mod_rate = true,
    }),
    -- 9 ticks at 1..9 seconds (same as the ToT base aura, in a single sub-element)
    {
      type = "subtick",
      tick_visible = true,
      tick_color = {1, 1, 1, 1},
      tick_placement_mode = "AtValue",
      tick_placements = {"1", "2", "3", "4", "5", "6", "7", "8", "9"},
      progressSources = {{-2, ""}},
      automatic_length = true,
      tick_thickness = 2,
      tick_length = 30,
      use_texture = false,
      tick_texture = "Interface\\CastingBar\\UI-CastingBar-Spark",
      tick_blend_mode = "ADD",
      tick_desaturate = false,
      tick_rotation = 0,
      tick_xOffset = 0,
      tick_yOffset = 0,
      tick_mirror = false,
    },
  },

  triggers = {
    -- 1: "Wrath of the Darkspear" 10 s timeline (same spell for every item version)
    auraTrigger("146184"),
    -- 2: "Wrath" — the actual stacking Intellect buff (1..10 stacks, lingers ~2 s)
    auraTrigger("146202"),
    activeTriggerMode = -10,   -- first active trigger drives the bar
    disjunctive = "any",
  },

  conditions = {
    {
      check = { trigger = 2, variable = "stacks", op = ">=", value = "9" },
      changes = { { property = "barColor", value = GOLD } },
    },
  },

  actions = {
    init = {},
    start = {
      do_sound = true,
      sound = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\ErrorBeep.ogg",
      sound_channel = "Master",
    },
    finish = {},
  },

  animation = {
    start  = { type = "none", duration_type = "seconds", easeType = "none", easeStrength = 3 },
    main   = { type = "none", duration_type = "seconds", easeType = "none", easeStrength = 3 },
    finish = { type = "none", duration_type = "seconds", easeType = "none", easeStrength = 3 },
  },

  load = {
    use_never = false,
    zoneIds = "",
    size = { multi = {} },
    spec = { multi = {} },
    class = { multi = {} },
    talent = { multi = {} },
  },

  config = {},
  authorOptions = {},
  information = {},
}

local BLUE = {0.29, 0.62, 0.92, 1}  -- #4a9eea

local haste = {
  id = "[Kende] Primal Diamond proc",
  desc = "Author: Kendeclise. Sinister Primal Diamond (meta gem) proc tracker: Tempus Repit, +30% spell haste for 10 s, no stacks. 9 tick marks at 1-9 s. Bar stays up for the full duration. Plays an Electrical Spark sound on proc.",
  uid = "PrimDia9fQ2m",
  internalVersion = 82,
  tocversion = 50504,
  regionType = "aurabar",
  semver = "2.0.0",
  version = 1,
  url = "",

  -- Position handled automatically by the parent dynamic group (grow + space)
  anchorFrameType = "SCREEN",
  anchorPoint = "CENTER",
  selfPoint = "CENTER",
  xOffset = 0,
  yOffset = 0,
  width = 300,
  height = 30,
  frameStrata = 1,
  alpha = 1,

  orientation = "HORIZONTAL",
  inverse = false,              -- drains as the 10 s buff runs out
  smoothProgress = false,
  texture = "Solid",
  textureSource = "LSM",
  barColor = BLUE,
  barColor2 = {1, 1, 0, 1},
  enableGradient = false,
  gradientOrientation = "HORIZONTAL",
  backgroundColor = {0, 0, 0, 0.5},
  progressSource = {-1, ""},
  adjustedMax = "",
  adjustedMin = "",
  useAdjustededMax = false,
  useAdjustededMin = false,

  -- Icon (the meta gem's own icon, left side)
  icon = true,
  icon_side = "LEFT",
  icon_color = {1, 1, 1, 1},
  iconSource = 0,
  displayIcon = "Interface\\Icons\\inv_legendary_chimeraoffear",
  desaturate = false,
  zoom = 0,

  spark = false,
  sparkTexture = "Interface\\CastingBar\\UI-CastingBar-Spark",
  sparkColor = {1, 1, 1, 1},
  sparkWidth = 10,
  sparkHeight = 30,
  sparkOffsetX = 0,
  sparkOffsetY = 0,
  sparkRotation = 0,
  sparkRotationMode = "AUTO",
  sparkBlendMode = "ADD",
  sparkHidden = "NEVER",

  subRegions = {
    { type = "subbackground" },
    { type = "subforeground" },
    -- Left: buff name
    subText("INNER_LEFT", "%n", {}),
    -- Right: remaining time
    subText("INNER_RIGHT", "%p", {
      text_text_format_p_format = "timed",
      text_text_format_p_time_format = 0,
      text_text_format_p_time_precision = 1,
      text_text_format_p_time_dynamic_threshold = 60,
      text_text_format_p_time_legacy_floor = false,
      text_text_format_p_time_mod_rate = true,
    }),
    -- 9 ticks at 1..9 seconds
    {
      type = "subtick",
      tick_visible = true,
      tick_color = {1, 1, 1, 1},
      tick_placement_mode = "AtValue",
      tick_placements = {"1", "2", "3", "4", "5", "6", "7", "8", "9"},
      progressSources = {{-2, ""}},
      automatic_length = true,
      tick_thickness = 2,
      tick_length = 30,
      use_texture = false,
      tick_texture = "Interface\\CastingBar\\UI-CastingBar-Spark",
      tick_blend_mode = "ADD",
      tick_desaturate = false,
      tick_rotation = 0,
      tick_xOffset = 0,
      tick_yOffset = 0,
      tick_mirror = false,
    },
  },

  -- Single trigger: "Tempus Repit" (137590), the actual +30% haste buff applied by the meta gem's proc
  triggers = {
    auraTrigger("137590"),
    activeTriggerMode = -10,
  },

  conditions = {},

  actions = {
    init = {},
    start = {
      do_sound = true,
      sound = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Sounds\\ESPARK1.ogg",
      sound_channel = "Master",
    },
    finish = {},
  },

  animation = {
    start  = { type = "none", duration_type = "seconds", easeType = "none", easeStrength = 3 },
    main   = { type = "none", duration_type = "seconds", easeType = "none", easeStrength = 3 },
    finish = { type = "none", duration_type = "seconds", easeType = "none", easeStrength = 3 },
  },

  load = {
    use_never = false,
    zoneIds = "",
    size = { multi = {} },
    spec = { multi = {} },
    class = { multi = {} },
    talent = { multi = {} },
  },

  config = {},
  authorOptions = {},
  information = {},
}

local ORANGE = {0.878, 0.396, 0.29, 1}  -- #e0654a

local uvls = {
  id = "[Kende] Unerring Vision proc",
  desc = "Author: Kendeclise. Unerring Vision of Lei Shen proc tracker: Perfect Aim, +100% crit chance for 4 s, no stacks. 3 tick marks at 1-3 s. Very short window, bar drains fast and disappears the instant the buff falls off. Plays a Boxing Arena Gong sound on proc. Works for every item version.",
  uid = "UVLSprc02Qx",
  internalVersion = 82,
  tocversion = 50504,
  regionType = "aurabar",
  semver = "2.0.0",
  version = 1,
  url = "",

  -- Position handled automatically by the parent dynamic group (grow + space)
  anchorFrameType = "SCREEN",
  anchorPoint = "CENTER",
  selfPoint = "CENTER",
  xOffset = 0,
  yOffset = 0,
  width = 300,
  height = 30,
  frameStrata = 1,
  alpha = 1,

  orientation = "HORIZONTAL",
  inverse = false,              -- drains as the 4 s buff runs out
  smoothProgress = false,
  texture = "Solid",
  textureSource = "LSM",
  barColor = ORANGE,
  barColor2 = {1, 1, 0, 1},
  enableGradient = false,
  gradientOrientation = "HORIZONTAL",
  backgroundColor = {0, 0, 0, 0.5},
  progressSource = {-1, ""},
  adjustedMax = "",
  adjustedMin = "",
  useAdjustededMax = false,
  useAdjustededMin = false,

  -- Icon (the trinket's own icon, left side)
  icon = true,
  icon_side = "LEFT",
  icon_color = {1, 1, 1, 1},
  iconSource = 0,
  displayIcon = "Interface\\Icons\\ability_hunter_focusedaim",
  desaturate = false,
  zoom = 0,

  spark = false,
  sparkTexture = "Interface\\CastingBar\\UI-CastingBar-Spark",
  sparkColor = {1, 1, 1, 1},
  sparkWidth = 10,
  sparkHeight = 30,
  sparkOffsetX = 0,
  sparkOffsetY = 0,
  sparkRotation = 0,
  sparkRotationMode = "AUTO",
  sparkBlendMode = "ADD",
  sparkHidden = "NEVER",

  subRegions = {
    { type = "subbackground" },
    { type = "subforeground" },
    -- Centered remaining time (matches this trinket's look in the original base aura)
    subText("INNER_CENTER", "%p", {
      text_text_format_p_format = "timed",
      text_text_format_p_time_format = 0,
      text_text_format_p_time_precision = 1,
      text_text_format_p_time_dynamic_threshold = 60,
      text_text_format_p_time_legacy_floor = false,
      text_text_format_p_time_mod_rate = true,
    }),
    -- 3 ticks at 1..3 seconds
    {
      type = "subtick",
      tick_visible = true,
      tick_color = {1, 1, 1, 1},
      tick_placement_mode = "AtValue",
      tick_placements = {"1", "2", "3"},
      progressSources = {{-2, ""}},
      automatic_length = true,
      tick_thickness = 2,
      tick_length = 30,
      use_texture = false,
      tick_texture = "Interface\\CastingBar\\UI-CastingBar-Spark",
      tick_blend_mode = "ADD",
      tick_desaturate = false,
      tick_rotation = 0,
      tick_xOffset = 0,
      tick_yOffset = 0,
      tick_mirror = false,
    },
  },

  -- Single trigger: "Perfect Aim" (138963), the actual +100% crit buff applied by the trinket's proc
  triggers = {
    auraTrigger("138963"),
    activeTriggerMode = -10,
  },

  conditions = {},

  actions = {
    init = {},
    start = {
      do_sound = true,
      sound = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\BoxingArenaSound.ogg",
      sound_channel = "Master",
    },
    finish = {},
  },

  animation = {
    start  = { type = "none", duration_type = "seconds", easeType = "none", easeStrength = 3 },
    main   = { type = "none", duration_type = "seconds", easeType = "none", easeStrength = 3 },
    finish = { type = "none", duration_type = "seconds", easeType = "none", easeStrength = 3 },
  },

  load = {
    use_never = false,
    zoneIds = "",
    size = { multi = {} },
    spec = { multi = {} },
    class = { multi = {} },
    talent = { multi = {} },
  },

  config = {},
  authorOptions = {},
  information = {},
}

-- Parent DYNAMIC group: auto-stacks only the bars that are currently active, with a fixed
-- gap between them, so an unequipped/inactive trinket never leaves a blank gap, and a new
-- one added later needs no manual repositioning. Order in `c` below = top-to-bottom stacking.
local group = {
  id = "[Kende] Proc Trackers",
  desc = "Author: Kendeclise. Proc trackers (MoP Classic): Black Blood of Y'Shaarj, Sinister Primal Diamond (Tempus Repit) and Unerring Vision of Lei Shen (Perfect Aim). Dynamic group: only active procs are shown, stacked with no gaps.",
  uid = "BBoYSgrp01W",
  internalVersion = 82,
  tocversion = 50504,
  regionType = "dynamicgroup",
  semver = "2.0.0",
  version = 1,
  url = "",
  groupIcon = "Interface\\Icons\\inv_jewelry_orgrimmarraid_trinket_02",

  anchorFrameType = "SCREEN",
  anchorPoint = "CENTER",
  selfPoint = "TOP",     -- top edge is the growth anchor; the first active bar starts here
  xOffset = 0,
  yOffset = 232,          -- topmost bar's position when all 3 procs are active
  grow = "DOWN",
  align = "CENTER",
  space = 10,             -- gap between bars (30-tall bars -> 40 units apart, same as before)
  stagger = 0,
  sort = "none",          -- respect the order of `c` below, don't alphabetize
  animate = false,
  frameStrata = 1,
  alpha = 1,
  scale = 1,

  border = false,
  borderBackdrop = "Blizzard Tooltip",
  borderColor = {0, 0, 0, 1},
  borderEdge = "Square Full White",
  borderInset = 1,
  borderOffset = 4,
  borderSize = 2,
  backdropColor = {0, 0, 0, 0.5},

  subRegions = {},
  triggers = {
    {
      trigger = {
        type = "aura2", unit = "player", debuffType = "HELPFUL",
        event = "Health", names = {}, spellIds = {},
        subeventPrefix = "SPELL", subeventSuffix = "_CAST_START",
      },
      untrigger = {},
    },
  },
  conditions = {},
  actions = { init = {}, start = {}, finish = {} },
  animation = {
    start  = { type = "none", duration_type = "seconds", easeType = "none", easeStrength = 3 },
    main   = { type = "none", duration_type = "seconds", easeType = "none", easeStrength = 3 },
    finish = { type = "none", duration_type = "seconds", easeType = "none", easeStrength = 3 },
  },
  load = {
    use_never = false,
    zoneIds = "",
    size = { multi = {} },
    spec = { multi = {} },
    class = { multi = {} },
    talent = { multi = {} },
  },
  config = {},
  authorOptions = {},
  information = {},
}

return {
  m = "d",
  v = 1421,
  s = "5.20.7",
  d = group,
  c = { uvls, data, haste },
}
