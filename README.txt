--------Classes--------

abilities
	Ability
	AbilityConditionChecker
	AbilityDatabase
	AbilityDataEvent
	Attack
	AttackConditionChecker
	Buff
	DrunkBullet
	Item
actors
	ActorDatabase
	Controls
	Unit
collects
	Gem
	HappyOrb
	PrizeDrop
com
	EnemySetup
effects
	TransitionScreen
enemies
	Enemy
	EnemyDatabase
game
	BGMDatabase
	CheatCodeDatabase
	Game
	GameClient
	GameConditionChecker
	GameDataEvent
	GameUnit
	GameVariables
	MovementManager
maps
	Map
	MapDatabase
	MapDataEvent
	MapManager
	MapObject
	MapObjectConditionChecker
	MapObjectParser
	Tileset
tileMapper
	InteractiveTile
	ScreenRect
	TileMap
	Unit
ui
	CheatCodeDisplay
	Cursor
	DecisionDisplay
	GetDisplay
	PlayerDisplay
	RangeInfo
	Target
	hud
		HealthBar
		HUD_Enemy
		HUD_Unit
		HUDManager
	screens
		BaseScreen
		ConfigScreen
		FileScreen
		GameOverScreen
		Menu
		PlayerSelect
		ShopScreen
		StageSelect
		TitleScreen
util
	ArgPathElement
	AttackTExt
	FPSDisplay
	FunctionUtils
	KeyDown
	PopUp



-----------How to use the editor-----------

There are currently 6 types of terrain. These are customizable of course.

We'll have to change Water and One-way. Water currently works as 2d side-scrolling water.
One-way is a platform you can jump onto from below.

The numbers and letters are hotkeys you can use instead of clicking on the button.
If you want to change a whole row of terrain, use the arrows in the top left.

--------Terrain--------

Impassable is basically a block you can't walk into.
Passable you can walk on.
Invisible is also a block you can't walk into.
Locked Doors are impassable unless you have a key.

--------Moving Objects--------

These will basically be interactive objects (enemies, keys, etc).
They can also be spawn points (invisible or not) for players and enemies.

You can delete interactive objects with the last option.