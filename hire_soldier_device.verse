
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
hire_soldier_device := class(creative_device):

    @editable Spawner:guard_spawner_device = guard_spawner_device{}
    @editable Button: conditional_button_device = conditional_button_device{}
    @editable SpawnDevice:player_spawner_device = player_spawner_device{}

    var CurrentAgent: ?agent = false

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        Button.ActivatedEvent.Subscribe(OnActivated)
        SpawnDevice.SpawnedEvent.Subscribe(OnPlayerSpawned)

    OnActivated(Agent: agent):void =
        spawn{SpawnWithDelay(Agent)}

    SpawnWithDelay(Agent: agent)<suspends>:void =
        for (Index : int = 0..Spawner.GetSpawnLimit() - 1):
            Spawner.Spawn(Agent)

    OnPlayerSpawned(Agent: agent):void=
        Print("OnPlayerSpawned")
        set CurrentAgent = option{Agent}
        Spawner.Hire(Agent)
