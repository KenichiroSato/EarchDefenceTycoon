
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
hud_manager_device := class(creative_device):

    @editable GoldMessage: hud_message_device = hud_message_device{}
    @editable MainMessage: hud_message_device = hud_message_device{}
    @editable VendingMachine1: vending_machine_device = vending_machine_device{}
    @editable AudioPlayer: audio_player_device = audio_player_device{}
    #@editable BGMPlayer: radio_device = radio_device{}
    @editable BGMPlayer: audio_player_device = audio_player_device{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        VendingMachine1.ItemSpawnedEvent.Subscribe(OnPurchased1)
        ShowMainMessage("Buy weapon with Gold!")

    OnPurchased1(Agent: agent):void =
        ShowMainMessage("Shoot monsters and earn Golds!!")
    
    ShowGold(GoldCount: int):void =
        GoldMessage.Hide()
        GoldMessage.SetText(StringToMessage("Current Gold={GoldCount}"))
        GoldMessage.Show()


    ShowMainMessage(Message: string) : void =
        MainMessage.Hide()
        MainMessage.Show(StringToMessage(Message))

    StringToMessage<localizes>(value:string) : message = "{value}"

    OnMonsterEmerged():void =
        BGMPlayer.Play()
        spawn{ShowMonsterEmergedMessage()}

    ShowMonsterEmergedMessage()<suspends>:void =
        ShowMainMessage("Giant monster has appeared!")
        Sleep(4.0)
        ShowMainMessage("Build a mega turret gun and defeat it!")

    OnMonsterDefeated():void =
        BGMPlayer.Stop()
        AudioPlayer.Play()
        ShowMainMessage("You made it!!")
    
