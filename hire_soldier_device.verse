
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
hire_soldier_device := class(creative_device):

    @editable LowGradeSpawner:guard_spawner_device = guard_spawner_device{}
    @editable HighGradeSpawner:guard_spawner_device = guard_spawner_device{}
    @editable ModerateGradeSpawner:guard_spawner_device = guard_spawner_device{}
    @editable VeryHighGradeSpawner:guard_spawner_device = guard_spawner_device{}

    @editable LowGradeButton: conditional_button_device = conditional_button_device{}
    @editable HighGradeButton: conditional_button_device = conditional_button_device{}
    @editable ModerateGradeButton: conditional_button_device = conditional_button_device{}
    @editable VeryHighGradeButton: conditional_button_device = conditional_button_device{}
    
    @editable PlayerSpawner:player_spawner_device = player_spawner_device{}

    var CurrentAgent: ?agent = false
    var CurrentSpawner: ?guard_spawner_device = false

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        LowGradeButton.ActivatedEvent.Subscribe(OnLowButtonActivated)
        ModerateGradeButton.ActivatedEvent.Subscribe(OnModerateButtonActivated)
        HighGradeButton.ActivatedEvent.Subscribe(OnHighButtonActivated)
        VeryHighGradeButton.ActivatedEvent.Subscribe(OnVeryHighButtonActivated)

        LowGradeSpawner.SpawnedEvent.Subscribe(OnGuardSpawned)
        ModerateGradeSpawner.SpawnedEvent.Subscribe(OnGuardSpawned)
        HighGradeSpawner.SpawnedEvent.Subscribe(OnGuardSpawned)
        VeryHighGradeSpawner.SpawnedEvent.Subscribe(OnGuardSpawned)

        PlayerSpawner.SpawnedEvent.Subscribe(OnPlayerSpawned)

    OnGuardSpawned(Agent: agent):void =
        if (Spawner := CurrentSpawner?):
            if(Player := CurrentAgent?):
                Spawner.Hire(Player)

    OnLowButtonActivated(Agent: agent):void =
        SpawnWithDelay(Agent, LowGradeSpawner)

    OnModerateButtonActivated(Agent: agent):void =
        SpawnWithDelay(Agent, ModerateGradeSpawner)

    OnHighButtonActivated(Agent: agent):void =
        SpawnWithDelay(Agent, HighGradeSpawner)

    OnVeryHighButtonActivated(Agent: agent):void =
        SpawnWithDelay(Agent, VeryHighGradeSpawner)

    SpawnWithDelay(Agent: agent, newSpawner: guard_spawner_device):void =
        if(Spawner := CurrentSpawner?):
            Spawner.Disable()
        set CurrentSpawner = option{newSpawner}
        newSpawner.Enable()

    OnPlayerSpawned(Agent: agent):void=
        Print("OnPlayerSpawned")
        set CurrentAgent = option{Agent}
        if (Spawner := CurrentSpawner?):
            Spawner.Hire(Agent)
