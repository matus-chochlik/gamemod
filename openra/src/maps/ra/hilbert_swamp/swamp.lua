SetupRaidActors = function(units)
	units = Utils.Where(
		units,
		function(a)
			return not a.IsDead
		end
	)
	local leader = units[1]

	Utils.Do(
		units,
		function(a)
			if a == leader then
				Trigger.OnIdle(a, a.Hunt)
			else
				Trigger.OnIdle(
					a,
					function()
						if not leader.IsDead then
							a.Guard(leader)
						else
							a.Hunt()
						end
					end
				)
			end
		end
	)

end

SpawnMilitaryRaid = function()
	local military = Player.GetPlayer("Military")

	local spawnpoints = {
		EntryNNE1, EntryNNE2, EntryN1, EntryN2, EntryNNW1, EntryNNW2,
		EntryNW2, EntryNW1, EntryNNW3, EntryNW2, EntryNW1, EntryE, EntryW,
		EntrySW2, EntrySW1, EntrySW3, EntrySSW2, EntrySSW1, EntrySW1,
		EntryS, EntrySE1, EntrySE2, EntrySSE1, EntryE, EntryNE1,
		EntryNNE1, EntryNE, EntryNE1,
	}
	local landings = {
		Landing01, Landing02, Landing03, Landing04, Landing05, Landing06,
		Landing07, Landing08, Landing09, Landing10, Landing11, Landing12,
		Landing13, Landing14, Landing15, Landing16, Landing17, Landing18,
		Landing20, Landing21, Landing22, Landing23, Landing24, Landing25,
		Landing26, Landing27, Landing28, Landing29, Landing30, Landing31,
		Landing32, Landing33, Landing34, Landing35, Landing36, Landing37,
		Landing38, Landing39, Landing40, Landing41, Landing42, Landing43,
		Landing44, Landing45, Landing46, Landing47, Landing48, Landing49,
		Landing50, Landing51, Landing52, Landing53, Landing54,
	}
	local entry = Utils.Random(spawnpoints)
	local landing = Utils.Random(landings)
	local exit = Utils.Random(spawnpoints)

	Utils.Do(
		Player.GetPlayers(function(p) return p.IsLocalPlayer end),
		function(p)
			Radar.Ping(p, Map.CenterOfCell(entry.Location), HSLColor.White, 200)
		end
	)

	local spawned = nil
	if Map.TerrainType(entry.Location) == "Water"
		and Map.TerrainType(exit.Location) == "Water"
	then
		spawned = Reinforcements.ReinforceWithTransport(
			military, "spdbt",
			{"e7", "e1", "e3"},
			{entry.Location, landing.Location},
			{landing.Location, exit.Location}
		)
		SetupRaidActors(spawned[2])
	else
		if Utils.RandomInteger(0, 2) == 0
		then
			spawned = Reinforcements.ReinforceWithTransport(
				military, "tran",
				{"e7", "e1", "e1", "e1", "e2", "e2", "e3", "e3"},
				{entry.Location, landing.Location},
				{landing.Location, exit.Location}
			)
			SetupRaidActors(spawned[2])
		else
			spawned = Reinforcements.ReinforceWithTransport(
				military, "atlst",
				{"arty", "1tnk", "jeep", "jeep", "ftrk"},
				{entry.Location, landing.Location},
				{landing.Location, exit.Location}
			)
			SetupRaidActors(spawned[2])
		end
	end

	Trigger.OnAddedToWorld(
		spawned[2][1],
		function(c)
			Utils.Do(
				Player.GetPlayers(function(p) return p.IsLocalPlayer end),
				function(p)
					Radar.Ping(
						p,
						Map.CenterOfCell(c.Location),
						HSLColor.Yellow,
						200
					)
				end
			)
		end
	)

	Trigger.AfterDelay(
		DateTime.Seconds(Utils.RandomInteger(60, 120)),
		SpawnMilitaryRaid
	)
end

SpawnLoners = function()
	local loners = Player.GetPlayer("Loners")

	local spawnpoints = {
		EntryNE, EntryNNE1, EntrySE3
	}
	local droppoints = {
		Landing01, Landing02, Landing03, Landing04, Landing05, Landing06,
		Landing07, Landing08, Landing09, Landing10, Landing11, Landing12,
		Landing13, Landing14, Landing15, Landing16, Landing17, Landing18,
		Landing20, Landing21, Landing22, Landing23, Landing24, Landing25,
		Landing26, Landing27, Landing28, Landing29, Landing30, Landing31,
		Landing32, Landing33, Landing34, Landing35, Landing36, Landing37,
		Landing38, Landing39, Landing40, Landing41, Landing42, Landing43,
		Landing44, Landing45, Landing46, Landing47, Landing48, Landing49,
		Landing50, Landing51, Landing52, Landing53, Landing54,
	}
	local entry = Utils.Random(spawnpoints)
	local start = Utils.Random(droppoints)
	local exit = Utils.Random(spawnpoints)

	spawned = Reinforcements.ReinforceWithTransport(
		loners, "apc",
		{"sniper", "e1", "e2", "e1", "e3"},
		{entry.Location, start.Location},
		{start.Location, exit.Location}
	)
	SetupRaidActors(spawned[2])

	Trigger.AfterDelay(
		DateTime.Seconds(Utils.RandomInteger(30, 50)),
		SpawnLoners
	)
end

band = {}

SpawnBandits = function()
	local bandits = Player.GetPlayer("Bandits")

	if Utils.RandomInteger(0, 2) == 0
	then
		local spawnpoints = {
			EntryNE, EntryNNE1, EntrySE3
		}
		local droppoints = {
			BanditBase1
		}
		local entry = Utils.Random(spawnpoints)
		local start = Utils.Random(droppoints)
		local exit = Utils.Random(spawnpoints)

		spawned = Reinforcements.ReinforceWithTransport(
			bandits, "jeep",
			{"e1", Utils.Random({"e1", "e2", "e3"})},
			{entry.Location, start.Location},
			{start.Location, exit.Location}
		)
	else
		local spawnpoints = {
			EntryNE1, EntryE, EntrySSE1, EntrySE2
		}
		local droppoints = {
			BanditLanding1
		}
		local entry = Utils.Random(spawnpoints)
		local start = Utils.Random(droppoints)
		local exit = Utils.Random(spawnpoints)

		spawned = Reinforcements.ReinforceWithTransport(
			bandits, "spdbt",
			{"e1", Utils.Random({"e1", "e2", "e3"})},
			{entry.Location, start.Location},
			{start.Location, exit.Location}
		)
	end
	Utils.Do(
		spawned[2],
		function(bandit)
			table.insert(band, bandit)
		end
	)

	if #band > 20 then
		SetupRaidActors(band)
		band = {}
	end
	

	Trigger.AfterDelay(
		DateTime.Seconds(Utils.RandomInteger(15, 25)),
		SpawnBandits
	)
end

SpawnMonolithRaid = function()
	local monolith = Player.GetPlayer("Monolith")

	local spawnpoints = {
		EntryNE, EntryNNE1, EntrySE3
	}
	local droppoints = {
		Landing01, Landing02, Landing03, Landing04, Landing05, Landing06,
		Landing07, Landing08, Landing09, Landing10, Landing11, Landing12,
		Landing13, Landing14, Landing15, Landing16, Landing17, Landing18,
		Landing20, Landing21, Landing22, Landing23, Landing24, Landing25,
		Landing26, Landing27, Landing28, Landing29, Landing30, Landing31,
		Landing32, Landing33, Landing34, Landing35, Landing36, Landing37,
		Landing38, Landing39, Landing40, Landing41, Landing42, Landing43,
		Landing44, Landing45, Landing46, Landing47, Landing48, Landing49,
		Landing50, Landing51, Landing52, Landing53, Landing54,
	}
	local entry = Utils.Random(spawnpoints)
	local start = Utils.Random(droppoints)
	local exit = Utils.Random(spawnpoints)

	Utils.Do(
		Player.GetPlayers(function(p) return p.IsLocalPlayer end),
		function(p)
			Radar.Ping(p, Map.CenterOfCell(entry.Location), HSLColor.White, 200)
		end
	)

	spawned = Reinforcements.ReinforceWithTransport(
		monolith, "dthtrk",
		{"sniper", "e1", "e1", "e1", "e2", "e2", "e3", "e3", "e4"},
		{entry.Location, start.Location},
		{start.Location, exit.Location}
	)
	SetupRaidActors(spawned[2])

	Trigger.AfterDelay(
		DateTime.Seconds(Utils.RandomInteger(50, 100)),
		SpawnMonolithRaid
	)
end

SpawnCreeps = function()
	local creeps = Player.GetPlayer("Creeps")

	local spawnpoints = {
		CreepSpawn01, CreepSpawn02, CreepSpawn03,
		CreepSpawn04, CreepSpawn05, CreepSpawn06
	}
	local huntpoints = {
		Landing01, Landing02, Landing03, Landing04, Landing05, Landing06,
		Landing07, Landing08, Landing09, Landing10, Landing11, Landing12,
		Landing13, Landing14, Landing15, Landing16, Landing17, Landing18,
		Landing20, Landing21, Landing22, Landing23, Landing24, Landing25,
		Landing26, Landing27, Landing28, Landing29, Landing30, Landing31,
		Landing32, Landing33, Landing34, Landing35, Landing36, Landing37,
		Landing38, Landing39, Landing40, Landing41, Landing42, Landing43,
		Landing44, Landing45, Landing46, Landing47, Landing48, Landing49,
		Landing50, Landing51, Landing52, Landing53, Landing54,
	}
	local entry = Utils.Random(spawnpoints)
	local start = Utils.Random(huntpoints)

	if Utils.RandomInteger(0, 2) == 0
	then
		local pop = creeps.GetActorsByType("dog")
		if #pop < 150 then
			Utils.Do(
				Reinforcements.Reinforce(
					creeps,
					{"dog", "dog", "dog", "dog", "dog"},
					{entry.Location, start.Location}
				),
				function(z) Trigger.OnIdle(z, z.Hunt) end
			)
		end
	else
		local pop = creeps.GetActorsByType("bldskr")
		if #pop < 30 then
			Utils.Do(
				Reinforcements.Reinforce(
					creeps,
					{"bldskr", "bldskr"},
					{entry.Location, start.Location}
				),
				function(z) Trigger.OnIdle(z, z.Hunt) end
			)
		end
	end

	Trigger.AfterDelay(
		DateTime.Seconds(Utils.RandomInteger(20, 40)),
		SpawnCreeps
	)
end

WorldLoaded = function()
	Trigger.AfterDelay(DateTime.Seconds(110), SpawnMonolithRaid)
	Trigger.AfterDelay(DateTime.Seconds(120), SpawnMilitaryRaid)
	Trigger.AfterDelay(DateTime.Seconds(35), SpawnCreeps)
	Trigger.AfterDelay(DateTime.Seconds(15), SpawnLoners)
	Trigger.AfterDelay(DateTime.Seconds(10), SpawnBandits)
end
