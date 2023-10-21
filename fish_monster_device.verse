
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
fish_monster := class(creative_device):

    #ボスは20000.0  fishは12000.0 jawは13000
    #初期位置 fish: 6300 - 12000 = -5700 
    #初期位置 jaw: 3500 - 13000 = -9500 
    #初期位置 boss: 6600 - 20000 = -13400 
    @editable EmergeDistance: float = 20000.0
    @editable HideDistance: float = -20000.0
    BounceDistance<private>: float = 100.0

    @editable var MonsterProp: creative_prop = creative_prop{}
    @editable HudManager:hud_manager_device = hud_manager_device{}
    var InitialPosition<private>: vector3 = vector3{X:=0.0, Y:= 0.0, Z:=0.0}
    var InitialRotation<private>: rotation = rotation{}
    var IsDefeated<private>: logic = false

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        set InitialPosition = MonsterProp.GetTransform().Translation
        set InitialRotation = MonsterProp.GetTransform().Rotation

    Emerge(): void =
        set IsDefeated = false
        spawn{EmergeAndBounce()}

    EmergeAndBounce<private>()<suspends>:void =
        Move(EmergeDistance, InitialRotation, 1.0)
        HudManager.OnMonsterEmerged()
        #Disable bounce for performance reason
        #Bounce()

    Bounce<private>()<suspends>:void =
        loop:
            Print("Bounce")
            if (IsDefeated?):
                Print("break")
                break
            Move(BounceDistance, InitialRotation, 0.7)
            Move(BounceDistance*(-1.0), InitialRotation, 0.7)
            Sleep(0.1)

    Collapse():void =
        Print("Collapse")
        set IsDefeated = true
        NewRotation := InitialRotation.ApplyPitch(-5.0)
        spawn{Move(HideDistance, NewRotation, 5.0)}
        HudManager.OnMonsterDefeated()

    Move<private>(Dist: float, Rotation: rotation, Duration: float)<suspends>: void =
        Transform := MonsterProp.GetTransform()
        MonsterProp.MoveTo(Transform.Translation + vector3{X:=0.0, Y:=0.0, Z:=Dist}, Rotation, Duration)