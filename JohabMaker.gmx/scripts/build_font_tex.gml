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
{
 
    show_debug_message("NEW FNTTEX");
    fntTex = surface_create(_newWid, _newHei);
}

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
        
        // draw_sprite(_data[@ CHAR.BAKED], 0, _x, _y);
        // add offset
        _x += _data[@ CHAR.X];
        _y += _data[@ CHAR.Y];
        
        get_atlas_glyph(bakedAtlas, i, -1); // store baked sprite into the glyphTemp surface
        
        draw_set_blend_mode(bm_add);
        draw_surface(glyphTemp, _x, _y);
        draw_set_blend_mode(bm_normal);
    }
    else
    {
        iui_rect(_x, _y, charWid, charHei, $FF00FF);
        // iui_align_center();
        // iui_label(_x + (charWid >> 1), _y + (charHei >> 1), dec_to_hex(ord(get_default_char(i))), c_yellow);
        // iui_align_pop();
    }
}
// show_debug_message("DRAWN " + string(_charlen) + " CHARACTERS TOTAL");
surface_reset_target();


/// BUILD ASCII IF DKB844
if (FNT_DKB)
{
    // update ascii surface
    _newWid = 32 * charAsciiWid;
    _newHei = 8 * charAsciiHei;
    
    if (surface_exists(fntAsciiTex))
        surface_resize(fntAsciiTex, _newWid, _newHei);
    else
        fntAsciiTex = surface_create(_newWid, _newHei);
        
    
    // Update contents
    surface_set_target(fntAsciiTex);
    
    // clear
    draw_clear(c_black);
    
    // grid
    for (var X=0; X<=32; X++)
    {
        for (var Y=0; Y<=8; Y++)
        {
            var _worldX = X * charAsciiWid;
            var _worldY = Y * charAsciiHei;
            iui_rect(_worldX - 1, 0, 2, _newHei, $FF00FF);
            iui_rect(0, _worldY - 1, _newWid, 2, $FF00FF);
        }
    }
    
    // ascii
    iui_align_center();
    draw_set_font(fntCurrent);
    for (var i=0; i<256; i++)
    {
        var _u = (i % 32) * charAsciiWid + (charAsciiWid >> 1);
        var _v = (i div 32) * charAsciiHei + (charAsciiHei >> 1);
        var _ch = chr(i);
        
        if (_ch == "#")
            _ch = "\" + _ch;
        
        draw_set_blend_mode(bm_add);
        iui_label(_u, _v, _ch, c_white);
        draw_set_blend_mode(bm_normal);
    }
    draw_set_font(fntOWO);
    iui_align_pop();
    
    surface_reset_target();
}

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
draw_set_blend_mode_ext(bm_one, bm_inv_src_alpha);

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
        // add offset
        _x += _data[@ CHAR.X];
        _y += _data[@ CHAR.Y];
        
        // draw_sprite(_data[@ CHAR.BAKED], 0, _x, _y);
        get_atlas_glyph(bakedAtlas, i, -1); // store baked sprite into the glyphTemp surface
        
        shader_set(shd_lumatoalpha);
        draw_surface(glyphTemp, _x, _y);
        shader_reset();
    }
    else if (drawGrid)
    {
        iui_rect(_x, _y, charWid, charHei, $FF00FF);
        
        // iui_align_center();
        // iui_label(_x + (charWid >> 1), _y + (charHei >> 1), dec_to_hex(ord(get_default_char(i))), c_yellow);
        // iui_align_pop();
    }
}
draw_set_blend_mode(bm_normal);
surface_reset_target();

/// BUILD ASCII IF DKB844
if (FNT_DKB)
{
    // build temp ascii w/ black bg
    var _tempsurf = surface_create(_newWid, _newHei);
    surface_set_target(_tempsurf);
    draw_clear(0);
    iui_align_center();
    draw_set_font(fntCurrent);
    for (var i=0; i<256; i++)
    {
        var _u = (i % 32) * charAsciiWid + (charAsciiWid >> 1);
        var _v = (i div 32) * charAsciiHei + (charAsciiHei >> 1);
        var _ch = chr(i);
        
        if (_ch == "#")
            _ch = "\" + _ch;
        
        draw_set_blend_mode(bm_add);
        iui_label(_u, _v, _ch, c_white);
        draw_set_blend_mode(bm_normal);
    }
    draw_set_font(fntOWO);
    iui_align_pop();
    surface_reset_target();
    
    // update ascii surface
    _newWid = 32 * charAsciiWid;
    _newHei = 8 * charAsciiHei;
    
    if (surface_exists(fntAsciiTex))
        surface_resize(fntAsciiTex, _newWid, _newHei);
    else
        fntAsciiTex = surface_create(_newWid, _newHei);
        
    
    // Update contents
    surface_set_target(fntAsciiTex);
    
    // clear
    draw_clear_alpha(bgCol, bgAlpha);
    
    // grid
    if (drawGrid)
    {
        for (var X=0; X<=32; X++)
        {
            for (var Y=0; Y<=8; Y++)
            {
                var _worldX = X * charAsciiWid;
                var _worldY = Y * charAsciiHei;
                iui_rect(_worldX - 1, 0, 2, _newHei, $FF00FF);
                iui_rect(0, _worldY - 1, _newWid, 2, $FF00FF);
            }
        }
        
    }
    
    // ascii
    draw_set_blend_mode_ext(bm_one, bm_inv_src_alpha);
    shader_set(shd_lumatoalpha);
    draw_surface(_tempsurf, 0, 0);
    shader_reset();
    draw_set_blend_mode(bm_normal);
    
    surface_reset_target();
    surface_free(_tempsurf);
}