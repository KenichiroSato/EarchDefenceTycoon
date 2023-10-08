
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
hud_manager_device := class(creative_device):

    @editable GoldMessage: hud_message_device = hud_message_device{}


    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        Print("Hello, world!")
        Print("2 + 2 = {2 + 2}")

    ShowGold(GoldCount: int):void =
        ShowMessage(GoldMessage,"Current Gold={GoldCount}")


    ShowMessage<private>(Device: hud_message_device, Message: string) : void =
        Device.Hide()
        Device.SetText(StringToMessage(Message))
        Device.Show()

    StringToMessage<localizes>(value:string) : message = "{value}"
