SetupRaidActors = function(barge, units)
    local cannon = units[1]

    Utils.Do(
        units,
        function(a)
            if a == cannon then
                Trigger.OnIdle(a, a.Hunt)
            else
                Trigger.OnIdle(
                    a,
                    function()
                        if cannon.IsDead then
                            a.Hunt()
                        else
                            a.Guard(cannon)
                        end
                    end
                )
            end
        end
    )

    Utils.Do(
        Player.GetPlayers(function(p) return p.IsLocalPlayer end),
        function(p)
            Radar.Ping(p, Map.CenterOfCell(barge.Location), HSLColor.White, 200)
        end
    )
end

SpawnPirateRaid = function()
    local pirates = Player.GetPlayer("Pirates")

    local spawnpoints = {
        PirateSpawn01, PirateSpawn02, PirateSpawn03,
        PirateSpawn04, PirateSpawn05, PirateSpawn06,
        PirateSpawn07, PirateSpawn08, PirateSpawn09,
        PirateSpawn10, PirateSpawn11, PirateSpawn12,
        PirateSpawn13, PirateSpawn14, PirateSpawn15,
    }
    local landings = {
        PirateLanding01, PirateLanding02, PirateLanding03,
        PirateLanding04, PirateLanding05, PirateLanding06,
        PirateLanding07, PirateLanding08, PirateLanding09,
        PirateLanding10, PirateLanding11, PirateLanding12,
        PirateLanding13, PirateLanding14, PirateLanding15,
        PirateLanding16, PirateLanding17, PirateLanding18,
        PirateLanding19, PirateLanding20, PirateLanding21,
        PirateLanding22, PirateLanding23, PirateLanding24,
        PirateLanding25, PirateLanding26, PirateLanding27,
        PirateLanding28, PirateLanding29, PirateLanding30,
        PirateLanding31, PirateLanding32, PirateLanding33,
        PirateLanding34, PirateLanding35, PirateLanding36,
    }
    local entry = Utils.Random(spawnpoints)
    local landing = Utils.Random(landings)
    local exit = Utils.Random(spawnpoints)

    local spawned = Reinforcements.ReinforceWithTransport(
        pirates, "barge",
        {"pican", "picp", "pibard", "pir", "pir", "pir", "pyr", "pyr", "pyr"},
        {entry.Location, landing.Location},
        {landing.Location, exit.Location}
    )
    SetupRaidActors(spawned[1], spawned[2])

    Trigger.AfterDelay(
        DateTime.Seconds(Utils.RandomInteger(60, 120)),
        SpawnPirateRaid
    )
end

SpawnCreeps = function()
    local creeps = Player.GetPlayer("Creeps")

    local spawninfo = {
        {ZombieSpawnLabE, ZombieSpawnE, ZombieDestE},
        {ZombieSpawnLabC, ZombieSpawnC, ZombieDestC},
        {ZombieSpawnLabW, ZombieSpawnW, ZombieDestW}
    }
    local spawn = Utils.Random(spawninfo)

    local pop = creeps.GetActorsByType("zombie")
    if #pop < 100 and not spawn[1].IsDead then
        Utils.Do(
            Reinforcements.Reinforce(
                creeps,
                {"zombie", "zombie", "zombie", "zombie", "zombie"},
                {spawn[2].Location, spawn[3].Location}
            ),
            function(z) Trigger.OnIdle(z, z.Hunt) end
        )
    end

    Trigger.AfterDelay(
        DateTime.Seconds(Utils.RandomInteger(30, 45)),
        SpawnCreeps
    )
end

WorldLoaded = function()
    Trigger.AfterDelay(DateTime.Seconds(420), SpawnPirateRaid)
    Trigger.AfterDelay(DateTime.Seconds(240), SpawnCreeps)
end
