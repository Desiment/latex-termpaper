# termpaper - LaTeX Term Paper Class

LaTeX class for SPbU Software Engineering termpapers.

**Requirements:** LuaLaTeX, xparse, polyglossia, fontspec, luaboolean, fontswitch.

**Installation:** Place `termpaper.cls` in LaTeX path or document folder.

## Class Options

- `14pt` - Use 14pt font size (requires `extarticle` base class)
- `titleconf={path/to/config.lua}` - Specify file for title page (if not given, default filler will be used)

## Usage
```latex
\documentclass[title={config/my-title.lua}]{termpaper}
\begin{document}
% Uses custom Lua file for title page data
\end{document}
```

## Configuration Files

1. **Lua Configuration:** Title page data (author, title, advisor, etc.) in `title/records.lua` by default
2. **TeX Template:** Title page layout in `title/base.tex`

## Font Notes
- Main font: CMU Serif (Computer Modern Unicode)
- Sans-serif: CMU Sans Serif
- Monospace: CMU Typewriter Text
- Alternative monospace options commented in class file

## Compatibility

- **Engine:** LuaLaTeX required (for Lua scripting and font support)
- **Base Class:** `article` (12pt) or `extarticle` (14pt)
- **Languages:** Russian (primary) and English

**Version:** 2026/01/06 | **Author:** Desiment | **Status:** Stable
