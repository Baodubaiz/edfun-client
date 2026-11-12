class_name HubColors
extends RefCounted
## The hub color system (light theme). Every UI color should come from here.

const PRIMARY := Color("6c4cf1")
const PRIMARY_DARK := Color("5636d9")
const PRIMARY_SOFT := Color("eeeaff")
const ACCENT := Color("ff7a45") ## Play buttons
const ACCENT_DARK := Color("eb6430")

const BG := Color("f5f6fb")
const SURFACE := Color("ffffff")
const SURFACE_PRESSED := Color("f1f2f8")
const BORDER := Color("e6e8f0")

const TEXT := Color("1c1d2b")
const TEXT_MUTED := Color("6b7080")
const ON_COLOR := Color("ffffff") ## text/icons on PRIMARY / ACCENT

const SUCCESS := Color("22c55e")
const DANGER := Color("ef4444")
const OVERLAY := Color(0.11, 0.11, 0.17, 0.55)
