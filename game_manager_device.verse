
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
game_manager_device := class(creative_device):

    @editable CreatureSpawners: []creature_spawner_device = array{}
    @editable GoldGranter: item_granter_device = item_granter_device{}
    @editable SpawnDevice:player_spawner_device = player_spawner_device{}
    @editable HudManager:hud_manager_device = hud_manager_device{}
    @editable VendingMachines1: []vending_machine_device = array{}
    @editable VendingMachines10: []vending_machine_device = array{}
    @editable VendingMachines100: []vending_machine_device = array{}
    
    var CurrentAgent: ?agent = false
    var GoldPerKill:int = 1
    var CurrentGold:int = 0

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        for(Index : int = 0..CreatureSpawners.Length - 1 ):
            if(CreatureSpawner := CreatureSpawners[Index]):
                CreatureSpawner.EliminatedEvent.Subscribe(OnCreatureEliminated)
        SpawnDevice.SpawnedEvent.Subscribe(OnPlayerSpawned)
        SubscribeVindingMachines()

    SubscribeVindingMachines():void =
        for(Index : int = 0..VendingMachines10.Length - 1 ):
            if(Machine := VendingMachines10[Index]):
                Machine.ItemSpawnedEvent.Subscribe(OnPurchased10)
        for(Index : int = 0..VendingMachines100.Length - 1 ):
            if(Machine := VendingMachines100[Index]):
                Machine.ItemSpawnedEvent.Subscribe(OnPurchased100)

    OnPurchased1(Agent: agent):void =
        OnPurchased(1)

    OnPurchased10(Agent: agent):void =
        OnPurchased(10)

    OnPurchased100(Agent: agent):void =
        OnPurchased(100)

    OnPurchased<private>(value: int):void =
        set CurrentGold = CurrentGold - value
        ShowGold()
    
    OnPlayerSpawned(Agent: agent):void=
        set CurrentAgent = option{Agent}

    OnCreatureEliminated(Res:device_ai_interaction_result):void =
        if(Agent := CurrentAgent?):
            set CurrentGold = CurrentGold + GoldPerKill
            GoldGranter.GrantItem(Agent)
            ShowGold()
        Print("CurrentGold ={CurrentGold}")

    ShowGold<private>():void =
        HudManager.ShowGold(CurrentGold)


