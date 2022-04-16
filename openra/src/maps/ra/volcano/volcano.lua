SpawnCreeps = function()
    local creeps = Player.GetPlayer("Creeps")
    local neutral = Player.GetPlayer("Neutral")

    local spawninfo = {
        {Temple, CreepSpawnA, CreepDestA},
        {Temple, CreepSpawnB, CreepDestB},
        {Temple, CreepSpawnC, CreepDestC}
    }
    local spawn = Utils.Random(spawninfo)
	local what = "spider"

    local pop = creeps.GetActorsByType(what)
    if #pop < 100 and not spawn[1].IsDead and spawn[1].EffectiveOwner == neutral
	then
        Utils.Do(
            Reinforcements.Reinforce(
                creeps,
                {what, what},
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
    Trigger.AfterDelay(DateTime.Seconds(60), SpawnCreeps)
end
