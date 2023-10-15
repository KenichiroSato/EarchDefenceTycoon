
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
comp_mega_turret_lanuch_device := class(creative_device):

    @editable EmergeButton: conditional_button_device = conditional_button_device{}
    @editable DownButton: conditional_button_device = conditional_button_device{}

    @editable TestUpButton: button_device = button_device{}
    @editable TestDownButton: button_device = button_device{}

    @editable Button: conditional_button_device = conditional_button_device{}
    @editable CannonFire: vfx_spawner_device = vfx_spawner_device{}
    @editable FireFish1: vfx_spawner_device = vfx_spawner_device{}
    @editable FireFish2: vfx_spawner_device = vfx_spawner_device{}
    @editable FireFish3: vfx_spawner_device = vfx_spawner_device{}

    @editable Monster: fish_monster = fish_monster{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        Button.ActivatedEvent.Subscribe(OnActivated)
        EmergeButton.ActivatedEvent.Subscribe(OnEmerge)
        DownButton.ActivatedEvent.Subscribe(OnDown)
        TestUpButton.InteractedWithEvent.Subscribe(OnEmerge)
        TestDownButton.InteractedWithEvent.Subscribe(OnDown)

    OnEmerge(Agent:agent):void =
        Monster.Emerge()

    OnDown(Agent: agent):void =
        Monster.Collapse()

    OnActivated(Agent: agent):void =
        spawn{ LaunchAnimation() }

    LaunchAnimation()<suspends>:void =
        for(Index : int = 0..3 ):
            Print("Fire!")
            Sleep(0.3)
            CannonFire.Enable()
            Sleep(0.3)
            CannonFire.Disable()

        for(Index : int = 0..3 ):
            Print("Fire!")
            Sleep(0.1)
            FireFish1.Enable()
            FireFish2.Disable()
            Sleep(0.1)
            FireFish3.Disable()
            FireFish2.Enable()
            Sleep(0.1)
            FireFish1.Disable()
            FireFish3.Enable()

        Monster.Collapse()
        