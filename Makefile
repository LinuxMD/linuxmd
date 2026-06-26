png2tile/png2tile:
	cd png2tile && cmake . && make

tuxhead.tiles tuxhead.tilemap tuxhead.pal: tuxhead.png | png2tile
	png2tile/png2tile $< -binary -pal gen -tilemapformat gen -savetileimage tuxhead.tiles.png -savetiles tuxhead.tiles -savetilemap tuxhead.tilemap -savepalette tuxhead.pal -tileformat chunky

linux/arch/m68k/include/asm/tuxhead.h: tuxhead.tiles tuxhead.tilemap tuxhead.pal
	xxd -i tuxhead.tiles > $@
	xxd -i tuxhead.tilemap >> $@
	xxd -i tuxhead.pal >> $@
