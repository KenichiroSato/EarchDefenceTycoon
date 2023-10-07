
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
crystal_spawner_device := class(creative_device):

    @editable Button: button_device = button_device{}
    @editable CrystalSpawner: item_spawner_device = item_spawner_device{}
    @editable GameManager: game_manager_device = game_manager_device{}
    @editable ScorePerItem: int = 0

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        Button.InteractedWithEvent.Subscribe(OnButtonInteracted)

    OnButtonInteracted(Agent: agent):void =
        Current := GameManager.GetCurrentScore()
        if (Current >= ScorePerItem):
            CrystalSpawner.SpawnItem()
            GameManager.ConsumeScore(ScorePerItem)
            spawn{ CoolDownButton() }
        else:
            Print("Short of score!!")

    CoolDownButton()<suspends>:void =
        Button.Disable()
        Sleep(3.0)
        Button.Enable()