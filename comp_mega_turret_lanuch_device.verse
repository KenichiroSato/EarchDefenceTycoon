
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
    @editable CanonFires: []vfx_spawner_device = array{}
    @editable HitFires: []vfx_spawner_device = array{}
    
    @editable Monster: fish_monster = fish_monster{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        Button.ActivatedEvent.Subscribe(OnActivated)
        EmergeButton.ActivatedEvent.Subscribe(OnEmerge)
        DownButton.ActivatedEvent.Subscribe(OnDown)
        TestUpButton.InteractedWithEvent.Subscribe(OnEmerge)
        TestDownButton.InteractedWithEvent.Subscribe(OnDown)

    OnEmerge(Agent:agent):void =
        Print("OnEmerge")
        Monster.Emerge()

    OnDown(Agent: agent):void =
        Monster.Collapse()

    OnActivated(Agent: agent):void =
        spawn{ LaunchAnimation() }

    LaunchAnimation()<suspends>:void =
        for(Index : int = 0..CanonFires.Length - 1 ):
            if(CanonFire := CanonFires[Index]):           
                Print("Fire!")
                Sleep(0.5)
                CanonFire.Enable()

        for (Indexx: int = 0..2):
            for(Index : int = 0..HitFires.Length - 1 ):
                if(HitFire := HitFires[Index]):           
                    Print("Hit!")
                    HitFire.Enable()
                    Sleep(0.1)
            for(Index : int = 0..HitFires.Length - 1 ):
                if(HitFire := HitFires[Index]):
                    HitFire.Disable()      

        Monster.Collapse()
        for(Index : int = 0..CanonFires.Length - 1 ):
            if(CanonFire := CanonFires[Index]):   
                CanonFire.Disable()
        
