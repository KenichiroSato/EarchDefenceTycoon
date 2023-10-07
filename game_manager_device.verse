
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
game_manager_device := class(creative_device):

    @editable CreatureSpawner: creature_spawner_device = creature_spawner_device{}
    @editable GoldGranter: item_granter_device = item_granter_device{}
    
    var ScoreLevel:int = 1
    var TotalScore:int = 0

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        CreatureSpawner.EliminatedEvent.Subscribe(OnCreatureEliminated)

    OnCreatureEliminated(Res:device_ai_interaction_result):void =
        if(Agent := Res.Source?):
            GoldGranter.GrantItem(Agent)
        set TotalScore = TotalScore + ScoreLevel
        Print("Score ={TotalScore}")

    GetCurrentScore<public>():int =
        return TotalScore

    ConsumeScore<public>(Amount: int):logic =
        if (TotalScore >= Amount):
            set TotalScore = TotalScore - Amount
            return true
        else:
            return false


