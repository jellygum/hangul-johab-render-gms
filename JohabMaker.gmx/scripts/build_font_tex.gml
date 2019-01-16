#define build_font_tex
///build_font_tex()
/*
    Build font texture by blitting glyphs surface
*/

// Update surface
var _newWid = gridWid * charWid;
var _newHei = gridHei * charHei;

if (surface_exists(fntTex))
    surface_resize(fntTex, _newWid, _newHei);
else
    fntTex = surface_create(_newWid, _newHei);

// Update contents
surface_set_target(fntTex);

// clear
draw_clear(c_black);

// Grid
var _texW = _newWid;
var _texH = _newHei;
for (var X=0; X<=gridWid; X++)
{
    for (var Y=0; Y<=gridHei; Y++)
    {
        var _worldX = X * charWid;
        var _worldY = Y * charHei;
        iui_rect(_worldX - 1, 0, 2, _texH, $FF00FF);
        iui_rect(0, _worldY - 1, _texW, 2, $FF00FF);
    }
}

// Glyphs
var _charlen = gridWid * gridHei;
var _data;
for (var i=0; i<_charlen; i++)
{
    _data = charData[| i];
    var _x = (i % gridWid) * charWid;
    var _y = (i div gridWid) * charHei;
    
    if (_data[@ CHAR.OCCUPIED])
    {
        /*
        if (!surface_exists(_data[@ CHAR.BAKED]))
            build_char_surface(i);
        draw_surface(_data[@ CHAR.BAKED], _x, _y);
        */
        
        draw_sprite(_data[@ CHAR.BAKED], 0, _x, _y);
    }
    else
    {
        iui_rect(_x, _y, charWid, charHei, $FF00FF);
        
        // iui_align_center();
        // iui_label(_x + (charWid >> 1), _y + (charHei >> 1), dec_to_hex(ord(get_default_char(i))), c_yellow);
        // iui_align_pop();
    }
}
show_debug_message("DRAWN " + string(_charlen) + " CHARACTERS TOTAL");

surface_reset_target();

#define build_font_tex_ext
///build_font_tex_ext(drawGrid, bgCol, bgAlpha)
/*
    Build font texture by blitting glyphs surface
*/

var drawGrid = argument0, bgCol = argument1, bgAlpha = argument2;

// Update surface
var _newWid = gridWid * charWid;
var _newHei = gridHei * charHei;

if (surface_exists(fntTex))
    surface_resize(fntTex, _newWid, _newHei);
else
    fntTex = surface_create(_newWid, _newHei);

// Update contents
surface_set_target(fntTex);

// clear
draw_clear_alpha(bgCol, bgAlpha);

// Grid
if (drawGrid)
{
    var _texW = _newWid;
    var _texH = _newHei;
    for (var X=0; X<=gridWid; X++)
    {
        for (var Y=0; Y<=gridHei; Y++)
        {
            var _worldX = X * charWid;
            var _worldY = Y * charHei;
            iui_rect(_worldX - 1, 0, 2, _texH, $FF00FF);
            iui_rect(0, _worldY - 1, _texW, 2, $FF00FF);
        }
    }
}

// Glyphs
var _charlen = gridWid * gridHei;
var _data;
for (var i=0; i<_charlen; i++)
{
    _data = charData[| i];
    var _x = (i % gridWid) * charWid;
    var _y = (i div gridWid) * charHei;
    
    // build_char_surface(i);
    if (_data[@ CHAR.OCCUPIED])
    {
        /*
        if (!surface_exists(_data[@ CHAR.BAKED]))
            build_char_surface(i);
        
        draw_surface(_data[@ CHAR.BAKED], _x, _y);
        */
        
        draw_sprite(_data[@ CHAR.BAKED], 0, _x, _y);
    }
    else if (drawGrid)
    {
        iui_rect(_x, _y, charWid, charHei, $FF00FF);
        
        // iui_align_center();
        // iui_label(_x + (charWid >> 1), _y + (charHei >> 1), dec_to_hex(ord(get_default_char(i))), c_yellow);
        // iui_align_pop();
    }
}
show_debug_message("DRAWN " + string(_charlen) + " CHARACTERS TOTAL");

surface_reset_target();