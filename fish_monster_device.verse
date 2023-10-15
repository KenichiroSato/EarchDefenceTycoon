
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
fish_monster := class(creative_device):

    #ボスは20000.0  fishは12000.0
    EmergeDistance<private>: float = 20000.0
    HideDistance<private>: float = -20000.0
    BounceDistance<private>: float = 100.0

    @editable var MonsterProp: creative_prop = creative_prop{}
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

    Move<private>(Dist: float, Rotation: rotation, Duration: float)<suspends>: void =
        Transform := MonsterProp.GetTransform()
        MonsterProp.MoveTo(Transform.Translation + vector3{X:=0.0, Y:=0.0, Z:=Dist}, Rotation, Duration)