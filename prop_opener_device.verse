
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
prop_opener_device := class(creative_device):

    @editable GameManager: game_manager_device = game_manager_device{}
    @editable PropManipulator: prop_manipulator_device = prop_manipulator_device{}
    @editable Button: button_device = button_device{}
    @editable Price:int = 0

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        Button.InteractedWithEvent.Subscribe(OnButtonInteracted)

    OnButtonInteracted(Agent: agent):void =
        Print("OnButtonInteracted")
        if (Price <= GameManager.TotalScore):
            Print("You can build")
        else :
            Print("Short of score")

            
