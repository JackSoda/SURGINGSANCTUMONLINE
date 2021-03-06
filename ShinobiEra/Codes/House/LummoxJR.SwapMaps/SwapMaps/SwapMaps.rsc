w   ǋ�c��Y��=[   blotch.dmi DMI ��� 3�             * �



	
�efffffffff   D   �?��Y� �=(   ground.dmi DMI ��� 3�           ����  B   B�{���Y� �=(   dirt.dmi DMI ���f 3           ����  r   Y���Y� �=X   gold.dmi DMI ����3�� ̙ �          & �L

�iI�$999��   �   ����Y:�=�   fence.dmi DMI ���                   ����     ����          ����     ����      �   D�:0��YX�=�   mob.dmi DMI ���   �3�          � 			DFFFFFFFFFfFfFfffffdFfFffdfdFFFFFFF   �G   |SQ��Y���?�G  swapmaps.html <HTML><BODY>

<STYLE><!--
  .ref DT {font-family: monospace; margin-top: 10pt}
--></STYLE>

<H2>SwapMaps Library</H2>
<I>by Lummox JR</I><P>


Most people think of maps in BYOND as a static part of their game; even if it
can be saved and loaded again, the assumption is that the set of game maps
will always be the same size and won't change. But in fact BYOND is a lot
more flexible than that: It's possible to use maps in a much more dynamic
way.<P>

The SwapMaps library was developed for just this purpose. The idea is simple:
At any time, you can create, or load, a dynamic map. The library will find
room for it, and then you can build on or decorate the space at will. The map
will function just like any other place in your game, until you delete or
unload it. Best of all, saving a swapmap is simple, and the savefiles can be
transferred to other worlds.<P>

Uses of swapmaps are many: You can create larger maps to explore, of forests
or caves or what have you, an overworld of infinite size. You can use them to
create temporary battle areas for players to battle monsters or each other.
You can assign each player a house, a plot of land for them to build on.<P>

One goal of the library is to make its savefiles as small and compact as
possible, so that they'll take up less space on your server and take less
time to transfer from world to world. Swapmaps make massive multiplayer
role-playing games feasible in BYOND.<P>


<H3>Nuts And Bolts</H3>

At the core of the library is a datum called <TT>/swapmap</TT>. Every
<TT>swapmap</TT> has a unique <TT>id</TT>, a name, that can be used to look
it up or load it.<P>

There are two ways to create a new swapmap: You can create one based on your
existing map by calling <TT>new /swapmap(id,turf/corner1,turf/corner2)</TT>,
and this map will never be deleted; it's used for saving purposes only. You
can create a standard swapmap, one that can be unloaded at will, by calling
<TT>new /swapmap(id,width,height,depth)</TT>, where the width, height, and
depth are its size in x, y, and z. Maps don't have to be the same size; you
can make them any size you like, and the world map will grow to adjust if
necessary.<P>

A map can also be loaded by calling <TT>SwapMaps_Load(id)</TT>, a global
proc. This will search for a file named <TT>map_<I>&lt;id&gt;</I>.sav</TT>
and, if found, load it. The proc returns the <TT>swapmap</TT> that was
loaded, or <TT>null</TT> if no map was found.<P>

When a map is created or loaded, the library will try to find a place to fit
it among all the other loaded maps. A swapmap can have smaller x and y
dimensions than your world, so <B>it's your responsibility to add a boundary
to the swapmap</B> if you don't want people crossing from one to the other.
For your convenience, there are procs included that will help you build on
your map quickly.<P>

A swapmap that has been loaded can be found by its id with
<TT>SwapMaps_Find(id)</TT>.

When you want to unload a map, you can do it one of two ways: You can call
<TT>SwapMaps_Unload(id)</TT> to do it by name, or you can use the datum and
call <TT>swapmap.Unload()</TT> directly. The map will be saved and
deleted.<P>

Call <TT>SwapMaps_Save(id)</TT> or <TT>swapmap.Save()</TT>, just like the
unloading process, to save a map without deleting it. You should do this
when there's no danger of the process being interrupted, as when the map is
in use. To prevent the save from slowing down the game, saves and loads call
<TT>sleep()</TT> at every z level; thus there's a slight potential for some
weird bugs if something goes upstairs or down within the swapmap during a
save.<P>

When a swapmap is saved, it saves all the turfs in it, plus the areas those
turfs belong to (if they belong to any area other than the default), plus
items in the map. <B>Any mob with a key</B> (i.e., belonging to a player) is
<B>not saved</B> along with the swapmap.<P>

If you delete a swapmap (such as when you unload it, or if you delete the
datum), its turfs and their contents will be deleted too, and the world map
may shrink down if it's been stretched to fit the swapmap you just deleted.
Mobs with keys won't be deleted, just like during the save process; they'll
be relocated to <TT>null</TT>.<P>


<H3>Accessing The Map</H3>

Each map has its coordinates stored in the datum as vars: <TT>x1</TT>,
<TT>y1</TT>, and <TT>z1</TT> mark out the lower left corner, and <TT>x2</TT>,
<TT>y2</TT>, and <TT>z2</TT> mark the upper right. An easy way to find the
corner turfs is to use the <TT>swapmap.LoCorner()</TT> and
<TT>swapmap.HiCorner()</TT> procs. If you specify a z level, those procs will
return the low and high corners (that is, with the lowest and highest x and y
coordinates) at that z; otherwise they'll return the corner turfs with the
lowest or highest z values.<P>

You can easily get a list of turfs by using <TT>swapmap.AllTurfs()</TT>,
which sends back all the turfs in the map or on one z-level. If you want to
find all the turfs on one z-level, call <TT>swapmap.AllTurfs(z)</TT>.<P>

<TT>swapmap.Contains(turf/T)</TT> is useful for finding out whether a turf is
even part of the map. This proc returns 1 if the turf belongs to the map, or
0 if it doesn't. This could also be called for objs and mobs, but it's not
really safe for areas because it checks the x, y, and z values; an area's xyz
coordinates are the lowest of all the turfs it contains, and so they might
technically be on another map even if the area has turfs on this one.<P>

<TT>swapmap.InUse()</TT> returns 1 if a mob with a key (a player or their
leftover mob) is on the map, 0 if there are none.<P>

To quickly build on your map, <TT>swapmap.BuildRectangle()</TT> and
<TT>swapmap.BuildFilledRectangle()</TT> are very useful. Each should be
called with two corner turfs, and a type to build:

<PRE>proc/SetupBattleMap(n)
  var/swapmap/M = SwapMaps_Find("battle[n]")
  M.BuildRectangle(LoCorner(),\
                   HiCorner()),\
                   /turf/grass{density=1;opacity=1})
  M.BuildFilledRectangle(get_step(LoCorner(),NORTHEAST),\
                         get_step(HiCorner(),SOUTHWEST),\
                         /turf/grass)</PRE>

The type you build in may be a turf, an obj, or a mob. (Areas are easier;
just add a block of turfs to <TT>area.contents</TT>.) This can be used to
quickly build walls for a house, or a stand of trees, or boundary walls as in
this example. An open rectangle (not filled) will be open on every z level;
in 3 dimensionsthis would look more like 4 sides of a box with no bottom or
lid.<P>

Another building proc is <TT>swapmap.BuildInTurfs()</TT>, which takes a list
of turfs and the item type to build.<P>


<H3>Template Maps</H3>

If you reuse a certain type of map often, like a battle map, one thing you
can do to save time is to use <TT>SwapMaps_CreateFromTemplate(id)</TT>, which
lets you load a map as a template. A new map is created, but its <TT>id</TT>
is not a text string; instead, it's the map itself. This map will never be
saved; it can be deleted using <TT>del()</TT>, or by unloading it. Here's an
example of how to use that.

<PRE>proc/StartBattle(mob/M1, mob/M2)
  var/turf/T1 = M1.loc
  var/turf/T2 = M2.loc
  var/swapmap/battlemap = SwapMaps_CreateFromTemplate("arena")
  var/turf/T = locate(round(battlemap.x1+battlemap.x2)/2,\
                      round(battlemap.y1+battlemap.y2)/2,\
                      battlemap.z1)
  M1.loc = get_step(T, SOUTH)
  M1.dir = NORTH
  M2.loc = get_step(T, NORTH)
  M2.dir = SOUTH
  M1.inbattle=1
  M2.inbattle=1
  while(M1 && M2 && M1.HP>0 && M2.HP>0)
    M1.BattleTurn(M2)
    if(M2 && M2.HP>=0)
      M2.BattleTurn(M1)
      if(!M1 || M2.HP<=0) M2.loc = T2   // return winner to old location
    else
      M1.loc = T1                       // return winner to old location
  del(battlemap)</PRE>

This snippet of code assumes that you've already got a map file called
<TT>map_arena.sav</TT>. If this file exists, a copy of it is loaded and its
size and features become the battle map. Multiple copies can be loaded from
this template, so any number of players (basically limited only by memory)
can do battle at once.<P>


<H3>Caveat Cartographer</H3>

There are a few things you should be careful about when using this library:

<UL>
<LI>Because the save and load operations sleep, nothing should be moving on a
    map when it is saved.</LI>

<LI>NPCs and other things that keep a var referencing a mob (or any obj or
    turf for that matter) that may or may not be on the map (like a player)
    should have that var replaced with something else, like the chracter's
    name and player key. Otherwise, the mob may be saved to the file by
    mistake, causing unpredictable results the next time the map is
    loaded.</LI>

<LI>It is possible for a map to be larger in the x and y dimensions than your
    world. When this map is loaded, it will expand the size of your world,
    and with it any other maps you may have. If you've planned for this
    properly by giving all maps opaque boundaries then it won't be a problem,
    but otherwise you should make sure all your swapmaps are only as big as
    the x,y size of the maps you compiled into the game.</LI>

<LI>Swapmaps that are smaller than the world map may end up placed alongside
    each other. They should have a boundary of some kind, unless for whatever
    reason you want players to be able to walk (and see) from one to the
    other. Remember also that if you have any terrain-altering objects like
    bombs, your map boundaries should be impervious to them.</LI>
</UL>



<HR>
<H3>Library Reference</H3>

<H4>User-Defined Vars</H4>

These vars should be set at runtime, in <TT>world/New()</TT> or wherever your
initialization is done.<P>

<DL CLASS=ref>
<DT>swapmaps_mode</DT>
<DD>The default save mode: .sav or .txt (plain text). If a file of the
    expected name isn't found when loading a map, but a different format is
    found, the other file will be loaded instead. When saved, that file will
    be saved in its original format regardless of this setting.

    <DL>
    <DT>SWAPMAPS_SAV = 0</DT>
    <DD>(default) Uses .sav files for raw /savefile output.</DD>
    <DT>SWAPMAPS_TEXT = 1</DT>
	<DD>Uses .txt files via ExportText() and ImportText(). These maps are
        easily editable and appear to take up less space in the current
        version of BYOND.</DD>
    </DL>
    </DD>

<DT>swapmaps_iconcache</DT>
<DD>An associative list of icon files with names, like <TT>"player"&nbsp;=
    'player.dmi'</TT>. When saved, icons using files in this list will be
    replaced with the string or name you choose, which can save space in your
    maps. Homemade icons can be added to the list via
    <TT>SwapMaps_AddIconToCache(name,&nbsp;icon)</TT>, but if you load the map in
    another world or during another session, the icons will have to be
    re-created before the map is loaded.</DD>
</DL>

<H4>Global Procs</H4>

<DL CLASS=ref>
<DT>SwapMaps_Find(id)</DT>
<DD>Find a map by its <TT>id</TT></DD>

<DT>SwapMaps_Load(id)</DT>
<DD>Load a map by its <TT>id</TT></DD>

<DT>SwapMaps_Save(id)</DT>
<DD>Save a map by its <TT>id</TT> (calls <TT>swapmap.Save()</TT>)</DD>

<DT>SwapMaps_Unload(id)</DT>
<DD>Save and unload a map by its <TT>id</TT> (calls <TT>swapmap.Unload()</TT>)</DD>

<DT>SwapMaps_Save_All()</DT>
<DD>Save all maps</DD>

<DT>SwapMaps_DeleteFile(id)</DT>
<DD>Delete a map file</DD>

<DT>SwapMaps_CreateFromTemplate(id)</DT>
<DD>Create a new map by loading another map to use as a template. This map
has <TT>id==src</TT> and will not be saved. To make it savable, change the
<TT>id</TT> to a name via the <TT>SetID()</TT> proc.</DD>

<DT>SwapMaps_LoadChunk(id, turf/locorner)</DT>
<DD>Load a map file as a chunk, to be placed at a specific location on the
    existing game maps. The loaded map does not need to be unloaded and may
    be deleted. Returns nonzero if successful.</DD>

<DT>SwapMaps_SaveChunk(id, turf/corner1, turf/corner2)</DT>
<DD>Save a portion of the map as a chunk. This will become a new map file
    in its own right, using the <TT>id</TT> specified. Returns nonzero if
    successful.</DD>

<DT>SwapMaps_GetSize(id)</DT>
<DD>Check a map file to find its size, without loading it. Returns a list
    containing the x, y, and z sizes of the map if successful, or null if
    the map was not found.</DD>

<DT>SwapMaps_AddIconToCache(name, icon)</DT>
<DD>Cache an icon file by name for space-saving storage</DD>
</DL>

<H4><TT>/swapmap</TT> Vars</H4>

<DL CLASS=ref>
<DT>id</DT>
<DD>Usually this is a string identifying the map uniquely. The map will be
    saved as <TT>map_<I>&lt;id&gt;</I>.sav</TT> or <TT>map_<I>&lt;id&gt;</I>.txt</TT>
    depending on the mode. If <TT>id</TT> is set to <TT>src</TT>, the map
    will not be saved. This var should not be changed directly; use
    <TT>SetID(id)</TT> to change it.</DD>

<DT>x1, y1, z1</DT>
<DD>Minimum x, y, z coordinates. These are the same coordinates returned by
    the <TT>LoCorner()</TT> proc.</DD>

<DT>x2, y2, z2</DT>
<DD>Maximum x, y, z coordinates. These are the same coordinates returned by
    the <TT>HiCorner()</TT> proc.</DD>

<DT>tmp/locked</DT>
<DD>Save or load in progress.</DD>

<DT>tmp/mode</DT>
<DD>The save mode of this map; set at creation-time to <TT>swapmaps_mode</TT>,
    or when the map is loaded to the format of the file.</DD>

<DT>tmp/ischunk</DT>
<DD>This should not be changed directly. The var indicates that the map is
    a chunk for purposes of loading, unloading, saving, or deletion. A chunk
    does not allocate new map space, but instead loads over the turfs of an
    existing map. When deleted, the turfs will not be erased.</DD>
</DL>

<H4><TT>/swapmap</TT> Procs</H4>

<DL CLASS=ref>
<DT>new</DT>
<DD>Create the datum but initialize nothing. This map will be prepared for a
    load.</DD>

<DT>new(id, x, y, z)</DT>
<DD>Create a new map with the specified <TT>id</TT>, with a specific size in
    each dimension. Any or all of the dimensions may be omitted; the default
    size of a map is <TT>world.maxx</TT>&times;<TT>world.maxy</TT>&times;1.
    Space will be allocated for this map, but existing atoms in its
    boundaries will not be destroyed.</DD>

<DT>new(id, turf/corner1, turf/corner2)</DT>
<DD>Create a new map based on a region of the compiled-in game map. (If the
    corner turfs don't fall within the boundaries of the original game map,
    the datum will be deleted.) This map is used for saving only. On deletion
    or unloading, the atoms within this map will not be destroyed.</DD>

<DT>del()</DT>
<DD>When the datum is deleted, turfs and their contents will be deleted also,
    as well as any areas that were unique to this map. Space will be
    deallocated and the global map will be reduced in size if the space is
    not needed by other maps. The map is not saved; to save and delete, call
    <TT>Unload()</TT> instead.</DD>

<DT>Write(savefile/S)</DT>
<DD>An override of <TT>datum.Write()</TT> for saving.</DD>

<DT>Read(savefile/S)</DT>
<DD>An override of <TT>datum.Read()</TT> for loading.</DD>

<DT>Save()</DT>
<DD>Save this map.</DD>

<DT>Unload()</DT>
<DD>Save this map and delete.</DD>

<DT>SetID(id)</DT>
<DD>Change the <TT>id</TT> of the map.</DD>

<DT>AllTurfs(z)</DT>
<DD>Return all turfs on one z-level of the map, or on all z-levels if none is
    specified. <TT>z</TT> is in world coordinates, not local.</DD>

<DT>Contains(turf/T)</DT>
<DD>Return 1 if the turf is on this map, 0 if it is not. This is also save
    for objs and mobs, but not for areas.</DD>

<DT>InUse()</DT>
<DD>Return 1 if a mob with a key is on this map, 0 if none.</DD>

<DT>LoCorner(z=z1)</DT>
<DD>Return the turf with the lowest x and y coordinates on a given z level of
    this map, or with the lowest x, y, and z for the whole map. <TT>z</TT> is
    in world coordinates, not local.</DD>

<DT>HiCorner(z=z2)</DT>
<DD>Return the turf with the highest x and y coordinates on a given z level
    of this map, or with the highest x, y, and z for the whole map. <TT>z</TT>
    is in world coordinates, not local.</DD>

<DT>BuildFilledRectangle(turf/T1, turf/T2, item)</DT>
<DD>Build a filled rectangle of <TT>item</TT> from corner turf <TT>T1</TT> to
    <TT>T2</TT>. <TT>item</TT> is a type path like <TT>/turf/wall</TT> or
    <TT>/obj/food{nutrients=2}</TT>. If the corner turfs are on different
    z-levels, a rectangle will be built on each level from <TT>T1</TT> to
    <TT>T2</TT>.</DD>

<DT>BuildRectangle(turf/T1, turf/T2, item)</DT>
<DD>Build an unfilled rectangle of <TT>item</TT> from corner turf <TT>T1</TT>
    to <TT>T2</TT>. <TT>item</TT> is a type path like <TT>/turf/wall</TT> or
    <TT>/obj/food{nutrients=2}</TT>. If the corner turfs are on different
    z-levels, a rectangle will be built on each level from <TT>T1</TT> to
    <TT>T2</TT>.</DD>

<DT>BuildInTurfs(list/turfs, item)</DT>
<DD>Build <TT>item</TT> at every turf in the list <TT>turfs</TT>. The
    list doesn't strictly have to contain turfs. <TT>item</TT> is a type path
    like <TT>/turf/wall</TT> or <TT>/obj/food{nutrients=2}</TT>.</DD>
</DL>


<H4>Overridden Procs</H4>

<DL CLASS=ref>
<DT>atom.Write(savefile/S)</DT>
<DD>This is overridden to allow for easy icon replacement, as well as to cull
    out empty lists and save no mobs with keys in a <TT>contents</TT>
    list.</DD>

<DT>atom.Read(savefile/S)</DT>
<DD>This is overridden to allow for easy icon replacement, as well as to add
    items to contents if needed.</DD>
</DL>


<H3>Version History</H3>

<H4>Version 2.1</H4>
<UL>
  <LI>Fixed a bug in map placement.</LI>
</UL>
<H4>Version 2</H4>
<UL>
  <LI>Fixed a bug that was causing <TT>SwapMaps_CreateFromTemplate()</TT> to
      function incorrectly.</LI>
  <LI>Added chunk support with <TT>SwapMaps_LoadChunk()</TT> and
      <TT>SwapMaps_SaveChunk()</TT>.</LI>
  <LI>Added <TT>SwapMaps_GetSize()</TT> to poll map sizes without loading
      any maps.</LI>
</UL>



</BODY></HTML>