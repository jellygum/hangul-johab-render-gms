///save_project(fname)
/*
    Saves project
*/

// var FILE = file_bin_open(_dir, 1);
var _dir = argument0;
var _filebuffer = buffer_create(1, buffer_grow, 1);

var _atlaswid = sprite_get_width(maskAtlas);
var _atlashei = sprite_get_height(maskAtlas);
var _masksize = _atlaswid * _atlashei * 4;
var _bakedsize = _masksize;
var _maskbuffer = buffer_create(_masksize, buffer_grow, 1);
var _bakedbuffer = buffer_create(_bakedsize, buffer_grow, 1);

/*
    PREP STUFF
*/
// check surface
var atlasTemp = surface_create(_atlaswid, _atlashei);

// copy atlases into each buffer
// copy mask atlas sprite into _maskbuffer
surface_set_target(atlasTemp);
draw_clear_alpha(0, 0);
draw_sprite(maskAtlas, 0, 0, 0);
surface_reset_target();

buffer_get_surface(_maskbuffer, atlasTemp, 0);
surface_save(atlasTemp, working_directory + "/debug/atlas_mask_save.png"); // for debug
// show_debug_message("MASK BUFFER SIZE : " + string(buffer_get_size(_maskbuffer)));

// copy baked atlas sprite into _bakedbuffer
surface_set_target(atlasTemp);
draw_clear_alpha(0, 0);
draw_sprite(bakedAtlas, 0, 0, 0);
surface_reset_target();

buffer_get_surface(_bakedbuffer, atlasTemp, 0);
surface_save(atlasTemp, working_directory + "/debug/atlas_baked_save.png"); // for debug
// show_debug_message("MASK BUFFER SIZE : " + string(buffer_get_size(_bakedbuffer)));
///////////////////////

/*
    BEGIN BUFFER
*/
buffer_seek(_filebuffer, buffer_seek_start, 0);

// write header & project info
buffer_write(_filebuffer, buffer_string, "JORT"); // Magic word
buffer_write(_filebuffer, buffer_u16, 128); // version
buffer_write(_filebuffer, buffer_u16, gridWid); // grid size
buffer_write(_filebuffer, buffer_u16, gridHei);
buffer_write(_filebuffer, buffer_u16, charWid); // glyph size
buffer_write(_filebuffer, buffer_u16, charHei);
buffer_write(_filebuffer, buffer_u16, charAsciiWid);
buffer_write(_filebuffer, buffer_u16, charAsciiHei);
buffer_write(_filebuffer, buffer_u8, fntSize); // font size
buffer_write(_filebuffer, buffer_u8, choRows); // beols
buffer_write(_filebuffer, buffer_u8, jungRows);
buffer_write(_filebuffer, buffer_u8, jongRows);
buffer_write(_filebuffer, buffer_u8, jamoRows);
buffer_write(_filebuffer, buffer_u8, asciiRows);
buffer_write(_filebuffer, buffer_bool, FNT_ASCII); // use ascii?
buffer_write(_filebuffer, buffer_bool, FNT_DKB); // dkb844?
buffer_write(_filebuffer, buffer_bool, FNT_MIDDLE); // Middle?
buffer_write(_filebuffer, buffer_bool, FNT_LAST); // Last?
// write atlas size & offsets
buffer_write(_filebuffer, buffer_u32, _masksize); // buffer size
buffer_write(_filebuffer, buffer_u32, _bakedsize);
buffer_write(_filebuffer, buffer_u32, sprite_get_width(maskAtlas)); // atlas size
buffer_write(_filebuffer, buffer_u32, sprite_get_height(maskAtlas));

var _offsetoff = buffer_tell(_filebuffer); // write offsets later
buffer_write(_filebuffer, buffer_u32, 0); // Atlas data offsets
buffer_write(_filebuffer, buffer_u32, 0);
buffer_write(_filebuffer, buffer_u32, 0); // Glyph info offset
buffer_write(_filebuffer, buffer_string, fntPath); // write font directory

// write atlas data
var _maskoff = buffer_tell(_filebuffer); // let's write surface buffer's contents
buffer_copy(_maskbuffer, 0, _masksize, _filebuffer, _maskoff);
buffer_seek(_filebuffer, buffer_seek_relative, _masksize);

var _bakedoff = buffer_tell(_filebuffer);
buffer_copy(_bakedbuffer, 0, _bakedsize, _filebuffer, _bakedoff);
buffer_seek(_filebuffer, buffer_seek_relative, _bakedsize);

// write all glyph's info
var _glyphoff = buffer_tell(_filebuffer);

buffer_write(_filebuffer, buffer_u16, charLen); // write data length
for (var i=0; i<charLen; i++)
{
    var _data = charData[| i];
    
    // get glyph data
    var _occupied = _data[@ CHAR.OCCUPIED]; // Is the glyph actually usable / visible?
    var _gsource = _data[@ CHAR.SOURCE]; // glyph data : Source character & offsets
    var _goffx = _data[@ CHAR.X];
    var _goffy = _data[@ CHAR.Y];
    
    // write glyph data into buffer
    buffer_write(_filebuffer, buffer_bool, _occupied);
    buffer_write(_filebuffer, buffer_string, _gsource);
    buffer_write(_filebuffer, buffer_u16, _goffx);
    buffer_write(_filebuffer, buffer_u16, _goffy);
}

// go back & write offsets
buffer_seek(_filebuffer, buffer_seek_start, _offsetoff);
buffer_write(_filebuffer, buffer_u32, _maskoff);
buffer_write(_filebuffer, buffer_u32, _bakedoff);
buffer_write(_filebuffer, buffer_u32, _glyphoff);

// save buffer to file
buffer_save(_filebuffer, _dir);
////////////////////

// delet
buffer_delete(_filebuffer);
buffer_delete(_maskbuffer);
buffer_delete(_bakedbuffer);
surface_free(atlasTemp);
