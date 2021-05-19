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

SpawnDinosaurs = function()
    dinosaurs = Player.GetPlayer("Dinosaurs")
    population = {trex=2, rapt=5, steg=25, tric=20}
    spawnlabs = {
        trex=TRexSpawnLab,
        rapt=RaptSpawnLab, 
        steg=StegSpawnLab, 
        tric=TricSpawnLab, 
    }
    spawnpaths = {
        trex={TRexSpawnStart.Location, TRexSpawnEnd.Location},
        rapt={RaptSpawnStart.Location, RaptSpawnEnd.Location},
        steg={StegSpawnStart.Location, StegSpawnEnd.Location},
        tric={TricSpawnStart.Location, TricSpawnEnd.Location},
    }

    for ty, co in pairs(population) do
        pop = dinosaurs.GetActorsByType(ty)
        if #pop < co and not spawnlabs[ty].IsDead then
            Reinforcements.Reinforce(
                dinosaurs,
                {ty},
                spawnpaths[ty],
                DateTime.Seconds(Utils.RandomInteger(10, 20))
            )
        end
    end
    Trigger.AfterDelay(
        DateTime.Seconds(Utils.RandomInteger(30, 45)),
        SpawnDinosaurs
    )
end

SpawnEngenByAir = function()
    engen = Player.GetPlayer("Engen")
    routes = {
        {EngenSpawnSE, EngenLandingE, EngenSpawnN},
        {EngenSpawnSE, EngenRallySC, EngenSpawnSW},
        {EngenSpawnSW, EngenRallySC, EngenSpawnE},
        {EngenSpawnN, EngenRallyC, EngenSpawnE},
        {EngenSpawnNE, EngenRallyHill, EngenSpawnSE},
        {EngenSpawnNE, EngenLandingN, EngenSpawnN},
        {EngenSpawnE, EngenLandingNW, EngenSpawnW},
        {EngenSpawnSW, EngenLandingSW, EngenSpawnE},
        {EngenSpawnE, EngenRallyC, EngenSpawnE},
        {EngenSpawnW, EngenRallyC, EngenSpawnE},
    }
    route = Utils.Random(routes)

    StartHuntParty(Reinforcements.ReinforceWithTransport(
        engen, "tran", {"eg1", "eg1", "eg1", "eg1", "eg2", "eg2", "eg2", "eg2"},
        {route[1].Location, route[2].Location},
        {route[2].Location, route[3].Location}
    )[2])

    Trigger.AfterDelay(
        DateTime.Seconds(Utils.RandomInteger(70, 150)),
        SpawnEngenByAir
    )
end

SpawnEngenBySea = function()
    engen = Player.GetPlayer("Engen")
    routes = {
        {EngenSpawnSE, EngenLandingSE, EngenSpawnSE},
        {EngenSpawnSE, EngenLandingE, EngenSpawnE},
        {EngenSpawnE, EngenLandingE, EngenSpawnSE},
        {EngenSpawnE, EngenLandingNE, EngenSpawnNE},
        {EngenSpawnNE, EngenLandingN, EngenSpawnN},
        {EngenSpawnSW, EngenLandingSW, EngenSpawnW},
        {EngenSpawnW, EngenLandingNW, EngenSpawnN},
        {EngenSpawnW, EngenLandingSW, EngenSpawnSW},
        {EngenSpawnE, EngenLandingBay, EngenSpawnE},
    }
    route = Utils.Random(routes)

    StartHuntParty(Reinforcements.ReinforceWithTransport(
        engen, "egland", {"egjeep", "egjeep"},
        {route[1].Location, route[2].Location},
        {route[2].Location, route[3].Location}
    )[2])

    Trigger.AfterDelay(
        DateTime.Seconds(Utils.RandomInteger(60, 120)),
        SpawnEngenBySea
    )
end

SpawnEngenByLand = function()
    engen = Player.GetPlayer("Engen")
    routes = {
        {EngenSpawnS, EngenRallySC},
        {EngenSpawnS, EngenRallyC},
    }
    route = Utils.Random(routes)

    StartHuntParty(Reinforcements.Reinforce(
        engen, {"egjeep", "egjeep"},
        {route[1].Location, route[2].Location}
    ))

    Trigger.AfterDelay(
        DateTime.Seconds(Utils.RandomInteger(70, 180)),
        SpawnEngenByLand
    )
end

WorldLoaded = function()
    Trigger.AfterDelay(DateTime.Seconds(10), SpawnDinosaurs)
    Trigger.AfterDelay(DateTime.Seconds(110), SpawnEngenByAir)
    Trigger.AfterDelay(DateTime.Seconds(120), SpawnEngenBySea)
    Trigger.AfterDelay(DateTime.Seconds(150), SpawnEngenByLand)
end
