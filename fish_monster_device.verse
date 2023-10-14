
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
fish_monster := class(creative_device):

    @editable var MonsterProp: creative_prop = creative_prop{}
    var InitialPosition<private>: vector3 = vector3{X:=0.0, Y:= 0.0, Z:=0.0}
    var InitialRotation<private>: rotation = rotation{}
    EmergeDistance<private>: float = 10000.0
    HideDistance<private>: float = -10000.0

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        set InitialPosition = MonsterProp.GetTransform().Translation
        set InitialRotation = MonsterProp.GetTransform().Rotation
        MoveToHidePosition()

    MoveToHidePosition<private>():void =
        spawn{Move(HideDistance, 0.1)}

    Emerge(): void =
        spawn{Move(EmergeDistance, 0.2)}

    Collapse():void =
        spawn:
            CollapseWithSpawn()

    CollapseWithSpawn()<suspends>:void =
        Transform := MonsterProp.GetTransform()
        NewRotation := MakeRotationFromYawPitchRollDegrees(0.0, 40.0, 0.0)
        MonsterProp.MoveTo(Transform.Translation + vector3{X:=0.0, Y:=0.0, Z:=HideDistance}, NewRotation, 2.0)

    Move(Dist: float, Duration: float)<suspends>: void =
        Transform := MonsterProp.GetTransform()
        MonsterProp.MoveTo(Transform.Translation + vector3{X:=0.0, Y:=0.0, Z:=Dist}, Transform.Rotation, Duration)