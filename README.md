# Friday Night Funkin' - Psych Engine

## Credits:
### Psych Engine:
* Shadow Mario - Coding
* RiverOaken - Arts and Animations
* Keoiki - Note Splash Animations

### Grafex Mod aka Psych Graphic Rework:
* Xale - Lead Coding, Artist
* PurpleSnake - Coding, Assets


## Atleast one change to every week:
### Week 1:
  * New Dad Left sing sprite 
  * Unused stage lights are now used
### Week 2:
  * Both BF and Skid & Pump does "Hey!" animations
  * Thunders does a quick light flash and zooms the camera in slightly
  * Added a quick transition/cutscene to Monster
### Week 3:
  * BF does "Hey!" during Philly Nice
  * Blammed has a cool new colors flash during that sick part of the song
### Week 4:
  * Better hair physics for Mom/Boyfriend (Maybe even slightly better than Week 7's :eyes:)
  * Henchmen die during all songs. Yeah :(
### Week 5:
  * Bottom Boppers and GF does "Hey!" animations during Cocoa and Eggnog
  * On Winter Horrorland, GF bops her head slower in some parts of the song.
### Week 6:
  * On Thorns, the HUD is hidden during the cutscene
  * Also there's the Background girls being spooky during the "Hey!" parts of the Instrumental

## Cool new Chart Editor changes and countless bug fixes
![an](https://user-images.githubusercontent.com/44785097/130653801-3bdaf3e0-3499-4bc5-ba95-95225567c445.jpg)
* You can now chart "Event" notes, which are bookmarks that trigger specific actions that usually were hardcoded on the vanilla version of the game.
* Your song's BPM can now have decimal values
* You can manually adjust a Note's strum time if you're really going for milisecond precision
* You can change a note's type on the Editor, it comes with two example types:
  * Alt Animation: Forces an alt animation to play, useful for songs like Ugh/Stress
  * Hey: Forces a "Hey" animation instead of the base Sing animation, if Boyfriend hits this note, Girlfriend will do a "Hey!" too.
  * Hurt Note: Hitting this note will make you take damage equivalent to 15% of your health (5% if it's a sustain note piece).

## Character Editor menu (Press 8 during a song)
![611204265433b](https://user-images.githubusercontent.com/44785097/130653956-3b15d82e-328c-4a59-8cf7-1d2b17c05f9a.jpg)


## Story mode menu rework:
![](https://i.imgur.com/UB2EKpV.png)
* Added a different BG to every song (less Tutorial)
* All menu characters are now in individual spritesheets, makes modding it easier.

## Credits menu
![](https://i.imgur.com/NdIQt3d.png)
* You can add a head icon, name, description and a Redirect link for when the player presses Enter while the item is currently selected.

## Awards/Achievements
* The engine comes with 16 example achievements that you can mess with and learn how it works (Check Achievements.hx and search for "checkForAchievement" on PlayState.hx)

## Options menu:
* You can change Note colors, Controls and Preferences there.
 * On Preferences you can toggle Downscroll, Anti-Aliasing, Framerate, Low Quality, Note Splashes, Hide Hud elements, Flashing Lights, etc.

## Other gameplay features:
* When the enemy hits a note, it plays the note hit animation on their strum, just like when the player hits a note.
* Lag doesn't impact the camera movement and player icon scaling anymore.
* Some stuff based on Week 7's changes has been put in (Background colors on Freeplay, Note splashes)
* You can reset your Score on Freeplay/Story Mode by pressing Reset button.
* You can listen to a song on Freeplay by pressing Space once.
