SpawnCreeps = function()
    local creeps = Player.GetPlayer("Creeps")
    local neutral = Player.GetPlayer("Neutral")

    local spawninfo = {
        {CreepSpawnA, CreepDestA},
        {CreepSpawnB, CreepDestB},
        {CreepSpawnC, CreepDestC}
    }
    local spawn = Utils.Random(spawninfo)
	local what = "spider"

    local pop = creeps.GetActorsByType(what)
    if #pop < 100 and not Temple.IsDead and Temple.EffectiveOwner == neutral
	then
        Utils.Do(
            Reinforcements.Reinforce(
                creeps,
                {what, what},
                {spawn[1].Location, spawn[1].Location}
            ),
            function(z) Trigger.OnIdle(z, z.Hunt) end
        )
    end

    Trigger.AfterDelay(
        DateTime.Seconds(Utils.RandomInteger(60, 90)),
        SpawnCreeps
    )
end

SpawnWizards = function()
    local creeps = Player.GetPlayer("Creeps")
    local neutral = Player.GetPlayer("Neutral")

    local spawninfo = {
        {CreepSpawnA, CreepDestA},
        {CreepSpawnB, CreepDestB},
        {CreepSpawnC, CreepDestC}
    }
    local spawn = Utils.Random(spawninfo)
	local what = "wzrd"

    local pop = creeps.GetActorsByType(what)
    if #pop < 1 and not Temple.IsDead and Temple.EffectiveOwner == neutral
	then
        Utils.Do(
            Reinforcements.Reinforce(
                creeps,
                {what},
                {spawn[1].Location, spawn[1].Location}
            ),
            function(z) Trigger.OnIdle(z, z.Hunt) end
        )
    end

    Trigger.AfterDelay(
        DateTime.Seconds(Utils.RandomInteger(450, 500)),
        SpawnCreeps
    )
end


WorldLoaded = function()
    Trigger.AfterDelay(DateTime.Seconds(60), SpawnCreeps)
    Trigger.AfterDelay(DateTime.Seconds(150), SpawnWizards)
end
