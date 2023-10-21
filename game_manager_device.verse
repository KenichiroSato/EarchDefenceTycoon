
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
game_manager_device := class(creative_device):

    @editable CreatureSpawners: []creature_spawner_device = array{}

    @editable GoldGranter: item_granter_device = item_granter_device{}
    @editable GoldGranter2: item_granter_device = item_granter_device{}
    @editable GoldGranter4: item_granter_device = item_granter_device{}
    @editable GoldGranter8: item_granter_device = item_granter_device{}
    @editable GoldGranter16: item_granter_device = item_granter_device{}
    @editable GoldGranter32: item_granter_device = item_granter_device{}
    
    @editable SpawnDevice:player_spawner_device = player_spawner_device{}
    @editable HudManager:hud_manager_device = hud_manager_device{}
    @editable VendingMachines10: []vending_machine_device = array{}
    @editable VendingMachines100: []vending_machine_device = array{}

    @editable ButtonPerKill_2: conditional_button_device = conditional_button_device{}
    @editable ButtonPerKill_4: conditional_button_device = conditional_button_device{}
    @editable ButtonPerKill_8: conditional_button_device = conditional_button_device{}
    @editable ButtonPerKill_16: conditional_button_device = conditional_button_device{}
    @editable ButtonPerKill_32: conditional_button_device = conditional_button_device{}

    
    var CurrentAgent: ?agent = false
    var GoldPerKill:int = 1
    var CurrentGold:int = 0
    var CurrentGranter: item_granter_device = item_granter_device{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        Print("GameManager OnBegin")
        for(Index : int = 0..CreatureSpawners.Length - 1 ):
            if(CreatureSpawner := CreatureSpawners[Index]):
                CreatureSpawner.EliminatedEvent.Subscribe(OnCreatureEliminated)
        SpawnDevice.SpawnedEvent.Subscribe(OnPlayerSpawned)
        SubscribeVindingMachines()
        ButtonPerKill_2.ActivatedEvent.Subscribe(OnActivatedPerKill_2)
        ButtonPerKill_4.ActivatedEvent.Subscribe(OnActivatedPerKill_4)
        ButtonPerKill_8.ActivatedEvent.Subscribe(OnActivatedPerKill_8)
        ButtonPerKill_16.ActivatedEvent.Subscribe(OnActivatedPerKill_16)
        ButtonPerKill_32.ActivatedEvent.Subscribe(OnActivatedPerKill_32)
        set CurrentGranter = GoldGranter

    OnActivatedPerKill_2(Agent: agent):void =
        set GoldPerKill = 2
        set CurrentGranter = GoldGranter2
    OnActivatedPerKill_4(Agent: agent):void =
        set GoldPerKill = 4
        set CurrentGranter = GoldGranter4
    OnActivatedPerKill_8(Agent: agent):void =
        set GoldPerKill = 8
        set CurrentGranter = GoldGranter8
    OnActivatedPerKill_16(Agent: agent):void =
        set GoldPerKill = 16
        set CurrentGranter = GoldGranter16
    OnActivatedPerKill_32(Agent: agent):void =
        set GoldPerKill = 32
        set CurrentGranter = GoldGranter32

    SubscribeVindingMachines():void =
        for(Index : int = 0..VendingMachines10.Length - 1 ):
            if(Machine := VendingMachines10[Index]):
                Machine.ItemSpawnedEvent.Subscribe(OnPurchased10)
        for(Index : int = 0..VendingMachines100.Length - 1 ):
            if(Machine := VendingMachines100[Index]):
                Machine.ItemSpawnedEvent.Subscribe(OnPurchased100)


    OnPurchased10(Agent: agent):void =
        OnPurchased(10)

    OnPurchased100(Agent: agent):void =
        OnPurchased(100)

    OnPurchased(value: int):void =
        set CurrentGold = CurrentGold - value
        ShowGold()
    
    OnPlayerSpawned(Agent: agent):void=
        set CurrentAgent = option{Agent}

    OnCreatureEliminated(Res:device_ai_interaction_result):void =
        if(Agent := CurrentAgent?):
            set CurrentGold = CurrentGold + GoldPerKill
            CurrentGranter.GrantItem(Agent)
            ShowGold()
            Print("CurrentGold ={CurrentGold}")

    ShowGold<private>():void =
        HudManager.ShowGold(CurrentGold)


