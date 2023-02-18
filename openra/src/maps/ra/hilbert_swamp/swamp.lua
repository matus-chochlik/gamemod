StartHunt = function(a)
    if a.HasProperty("Hunt") then
        Trigger.OnIdle(a, a.Hunt)
    end
end

StartHuntParty = function(l)
    Utils.Do(l, function(a)
        StartHunt(a)
    end)
end

SetupRaidActors = function(barge, units)
    local cannon = units[1]

	StartHuntParty(units)

    Utils.Do(
        Player.GetPlayers(function(p) return p.IsLocalPlayer end),
        function(p)
            Radar.Ping(p, Map.CenterOfCell(barge.Location), HSLColor.White, 200)
        end
    )
end

SpawnMilitaryRaid = function()
    local military = Player.GetPlayer("Military")

    local spawnpoints = {
		EntryNNE1, EntryNNE2, EntryN1, EntryN2, EntryNNW1, EntryNNW2,
		EntryNW2, EntryNW1, EntryNNW3, EntryNW2, EntryNW1, EntryE,
		EntrySW2, EntrySW1, EntrySW3, EntrySSW2, EntrySSW1, EntrySW1,
		EntryS, EntrySE1, EntrySE2, EntrySSE1, EntryE, EntryNE1,
		EntryNNE1, EntryNE, EntryNE1,
    }
    local landings = {
		Landing01, Landing02, Landing03, Landing04, Landing05, Landing06,
		Landing07, Landing08, Landing09, Landing10, Landing11, Landing12,
		Landing13, Landing14, Landing15, Landing16, Landing17, Landing18,
		Landing20, Landing21, Landing22, Landing23, Landing24, Landing25,
		Landing26, Landing27, Landing28, Landing29, Landing29, Landing30,
		Landing31, Landing32, Landing33, Landing34, Landing35, Landing36,
		Landing36, Landing38, Landing39, Landing40, Landing41, Landing41,
		Landing43, Landing44, Landing45, Landing46, Landing47, Landing48,
		Landing49, Landing50, Landing51, Landing52, Landing53, Landing54,
    }
    local entry = Utils.Random(spawnpoints)
    local landing = Utils.Random(landings)
    local exit = Utils.Random(spawnpoints)

    local spawned = Reinforcements.ReinforceWithTransport(
        military, "atlst",
        {"jeep", "jeep"},
        {entry.Location, landing.Location},
        {landing.Location, exit.Location}
    )
    SetupRaidActors(spawned[1], spawned[2])

    Trigger.AfterDelay(
        DateTime.Seconds(Utils.RandomInteger(60, 120)),
        SpawnMilitaryRaid
    )
end

WorldLoaded = function()
    Trigger.AfterDelay(DateTime.Seconds(20), SpawnMilitaryRaid)
end
