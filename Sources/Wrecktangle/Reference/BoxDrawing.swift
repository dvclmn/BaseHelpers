//
//  BoxDrawing.swift
//  BoxCore
//
//  Created by Dave Coleman on 15/9/2024.
//

public extension BoxCore {
  static let boxDrawing: String = """
  
  U+2580  ▀  Upper half block
  U+2581  ▁  Lower one eighth block
  U+2582  ▂  Lower one quarter block
  U+2583  ▃  Lower three eighths block
  U+2584  ▄  Lower half block
  U+2585  ▅  Lower five eighths block
  U+2586  ▆  Lower three quarters block
  U+2587  ▇  Lower seven eighths block
  U+2588  █  Full block
  U+2589  ▉  Left seven eighths block
  U+258A  ▊  Left three quarters block
  U+258B  ▋  Left five eighths block
  U+258C  ▌  Left half block
  U+258D  ▍  Left three eighths block
  U+258E  ▎  Left one quarter block
  U+258F  ▏  Left one eighth block
  U+2590  ▐  Right half block
  U+2591  ░  Light shade
  U+2592  ▒  Medium shade
  U+2593  ▓  Dark shade
  U+2594  ▔  Upper one eighth block
  U+2595  ▕  Right one eighth block
  U+2596  ▖  Quadrant lower left
  U+2597  ▗  Quadrant lower right
  U+2598  ▘  Quadrant upper left
  U+2599  ▙  Quadrant upper left and lower left and lower right
  U+259A  ▚  Quadrant upper left and lower right
  U+259B  ▛  Quadrant upper left and upper right and lower left
  U+259C  ▜  Quadrant upper left and upper right and lower right
  U+259D  ▝  Quadrant upper right
  U+259E  ▞  Quadrant upper right and lower left
  U+259F  ▟  Quadrant upper right and lower left and lower right
  
  U+25A0  ■  Black square
  U+25A1  □  White square
  U+25A2  ▢  White square with rounded corners
  U+25A3  ▣  White square containing small black square
  U+25A4  ▤  Square with horizontal fill
  U+25A5  ▥  Square with vertical fill
  U+25A6  ▦  Square with orthogonal crosshatch fill
  U+25A7  ▧  Square with upper left to lower right fill
  U+25A8  ▨  Square with upper right to lower left fill
  U+25A9  ▩  Square with diagonal crosshatch fill
  U+25AA  ▪  Black small square
  U+25AB  ▫  White small square
  U+25AC  ▬  Black rectangle
  U+25AD  ▭  White rectangle
  U+25AE  ▮  Black vertical rectangle
  U+25AF  ▯  White vertical rectangle
  U+25B0  ▰  Black parallelogram
  U+25B1  ▱  White parallelogram
  U+25B2  ▲  Black up-pointing triangle
  U+25B3  △  White up-pointing triangle
  U+25B4  ▴  Black up-pointing small triangle
  U+25B5  ▵  White up-pointing small triangle
  U+25B6  ▶  Black right-pointing triangle
  U+25B7  ▷  White right-pointing triangle
  U+25B8  ▸  Black right-pointing small triangle
  U+25B9  ▹  White right-pointing small triangle
  U+25BA  ►  Black right-pointing pointer
  U+25BB  ▻  White right-pointing pointer
  U+25BC  ▼  Black down-pointing triangle
  U+25BD  ▽  White down-pointing triangle
  U+25BE  ▾  Black down-pointing small triangle
  U+25BF  ▿  White down-pointing small triangle
  U+25C0  ◀  Black left-pointing triangle
  U+25C1  ◁  White left-pointing triangle
  U+25C2  ◂  Black left-pointing small triangle
  U+25C3  ◃  White left-pointing small triangle
  U+25C4  ◄  Black left-pointing pointer
  U+25C5  ◅  White left-pointing pointer
  U+25C6  ◆  Black diamond
  U+25C7  ◇  White diamond
  U+25C8  ◈  White diamond containing small black diamond
  U+25C9  ◉  Fisheye
  U+25CA  ◊  Lozenge
  U+25CB  ○  White circle
  U+25CC  ◌  Dotted circle
  U+25CD  ◍  Circle with vertical fill
  U+25CE  ◎  Bullseye
  U+25CF  ●  Black circle
  U+25D0  ◐  Circle with left half black
  U+25D1  ◑  Circle with right half black
  U+25D2  ◒  Circle with lower half black
  U+25D3  ◓  Circle with upper half black
  U+25D4  ◔  Circle with upper right quadrant black
  U+25D5  ◕  Circle with all but upper left quadrant black
  U+25D6  ◖  Left half circle black
  U+25D7  ◗  Right half black circle
  U+25D8  ◘  Inverse bullet
  U+25D9  ◙  Inverse white circle
  U+25DA  ◚  Upper half inverse white circle
  U+25DB  ◛  Lower half inverse white circle
  U+25DC  ◜  Upper left quadrant circular arc
  U+25DD  ◝  Upper right quadrant circular arc
  U+25DE  ◞  Lower right quadrant circular arc
  U+25DF  ◟  Lower left quadrant circular arc
  U+25E0  ◠  Upper half circle
  U+25E1  ◡  Lower half circle
  U+25E2  ◢  Black lower right triangle
  U+25E3  ◣  Black lower left triangle
  U+25E4  ◤  Black upper left triangle
  U+25E5  ◥  Black upper right triangle
  U+25E6  ◦  White bullet
  U+25E7  ◧  Square with left half black
  U+25E8  ◨  Square with right half black
  U+25E9  ◩  Square with upper left diagonal half black
  U+25EA  ◪  Square with lower right diagonal half black
  U+25EB  ◫  White square with vertical bisecting line
  U+25EC  ◬  White up-pointing triangle with dot
  U+25ED  ◭  Up-pointing triangle with left half black
  U+25EE  ◮  Up-pointing triangle with right half black
  U+25EF  ◯  Large circle
  U+25F0  ◰  White square with upper left quadrant
  U+25F1  ◱  White square with lower left quadrant
  U+25F2  ◲  White square with lower right quadrant
  U+25F3  ◳  White square with upper right quadrant
  U+25F4  ◴  White circle with upper left quadrant
  U+25F5  ◵  White circle with lower left quadrant
  U+25F6  ◶  White circle with lower right quadrant
  U+25F7  ◷  White circle with upper right quadrant
  U+25F8  ◸  Upper left triangle
  U+25F9  ◹  Upper right triangle
  U+25FA  ◺  Lower-left triangle
  U+25FB  ◻  White medium square
  U+25FC  ◼  Black medium square
  U+25FD  ◽  White medium small square
  U+25FE  ◾  Black medium small square
  U+25FF  ◿  Lower right triangle
  """
  
}
