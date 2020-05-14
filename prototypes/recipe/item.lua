--item.lua

local tierOne = {'iron-ore','iron-plate', 'iron-stick', 'wood', 'copper-ore', 'copper-plate', 'copper-cable','iron-gear-wheel', 'pipe', 'coal', 'iron-chest', 'stone','stone-brick', 'stone-furnace','wooden-chest',}
local tierTwo = {'lab', 'landfill', 'assembling-machine-1', 'big-electric-pole', 'boiler', 'burner-inserter','burner-mining-drill', 'constant-combinator', 'decider-combinator', 'electric-mining-drill', 'electronic-circuit', 'empty-barrel', 'engine-unit', 'fast-inserter','fast-transport-belt','fast-underground-belt', 'filter-inserter', 'gate', 'green-wire', 'inserter', 'long-handed-inserter','medium-electric-pole', 'offshore-pump', 'pipe-to-ground', 'power-switch','programmable-speaker','pump', 'radar','rail-chain-signal','rail-signal','small-electric-pole','red-wire', 'small-lamp','splitter', 'steam-engine', 'steel-chest','steel-furnace', 'steel-plate','stone-wall','transport-belt','underground-belt', 'firearm-magazine','piercing-rounds-magazine', 'boiler', 'automation-science-pack', 'logistic-science-pack', 'military-science-pack','arithmetic-combinator','train-stop'} --circuits
local tierThree = {'accumulator', 'advanced-circuit', 'assembling-machine-2', 'battery', 'chemical-plant','concrete', 'electric-engine-unit', 'fast-splitter', 'oil-refinery', 'plastic-bar', 'pumpjack','rocket-fuel', 'solar-panel','storage-tank','sulfur', 'chemical-science-pack'} --oil products
local tierFluid = {'heavy-oil-barrel','light-oil-barrel', 'lubricant-barrel','petroleum-gas-barrel','solid-fuel','sulfuric-acid-barrel','water-barrel', 'crude-oil', 'heavy-oil', 'light-oil','lubricant', 'sulfuric-acid', 'water', 'steam','petroleum-gas', 'crude-oil-barrel'}
local tierFour = {'electric-furnace', 'logistic-chest-active-provider','logistic-chest-buffer','logistic-chest-passive-provider','logistic-chest-requester','logistic-chest-storage', 'low-density-structure', 'processing-unit', 'roboport', 'rocket-control-unit', 'stack-filter-inserter', 'stack-inserter', 'substation', 'speed-module', 'effectivity-module', 'productivity-module', 'production-science-pack', 'utility-science-pack'} --blue circuits, advanced engines, etc.
local tierFive = {'beacon', 'centrifuge', 'construction-robot','flying-robot-frame', 'hazard-concrete', 'heat-exchanger','heat-pipe','logistic-robot', 'nuclear-fuel',  'refined-concrete', 'refined-hazard-concrete','steam-turbine', 'uranium-235', 'uranium-238', 'uranium-fuel-cell', 'uranium-ore', 'used-up-uranium-fuel-cell', 'express-loader','express-splitter','express-transport-belt','express-underground-belt', 'effectivity-module-2', 'productivity-module-2', 'speed-module-2'}
local tierSix = {'rocket-silo','nuclear-reactor', 'satellite', 'speed-module-3','productivity-module-3','effectivity-module-3'}
local tierNotUsed = {'land-mine',  'artillery-turret', 'laser-turret', 'assembling-machine-3', 
'battery-equipment', 'battery-mk2-equipment', 'belt-immunity-equipment', 'explosives','flamethrower-turret', 'fusion-reactor-equipment', 'gun-turret', 'heat-interface','personal-laser-defense-equipment', 'personal-roboport-equipment', 'personal-roboport-mk2-equipment','player-port', 'small-plane',  'solar-panel-equipment','discharge-defense-equipment','energy-shield-equipment','energy-shield-mk2-equipment','exoskeleton-equipment','rocket'}
local tierGuns = {'combat-shotgun','flamethrower','pistol','railgun','rocket-launcher','shotgun','submachine-gun'}
local tierAmmo = {'artillery-shell', 'atomic-bomb', 'cannon-shell', 'explosive-cannon-shell','explosive-rocket','explosive-uranium-cannon-shell','firearm-magazine','flamethrower-ammo', 'piercing-shotgun-shell','railgun-dart','rocket','shotgun-shell','uranium-cannon-shell','uranium-rounds-magazine', 'grenade', 'cliff-explosives', 'cluster-grenade', 'defender-capsule','destroyer-capsule',' discharge-defense-remote','distractor-capsule','poison-capsule','raw-fish','slowdown-capsule'}
local tierList = {tierOne, tierTwo, tierThree, tierFour, tierFluid, tierFive, tierNotUsed, tierSix, tierAmmo, tierGuns}

--items not using { 'coin', 'computer', }

--'fast-loader', 


function tierDecider(ingredient) --determine what the ingredient tier is in
    for _dummy,tier in pairs(tierList) do
        for _dummy,item in pairs(tier) do
            if ingredient == item then
                log('found '..item)
                tier_name = tier
                return tier_name
            end
        end
    end
end  
     
function tierRan(tier_name) --take the tier, return a random item; randomize number
    --ran_item_number = game.create_random_generator()
    --ran_item_number(1, table_size(tier_name))
    ran_item_number = math.random(1, table_size(tier_name))
    return tier_name[ran_item_number]
end

function tierChange(name, ingredient_table) -- takes ingredients, changes it to another ingredient on the same 'tier', and randomizes number
    for _dummy, tierChange_ingredient in pairs(ingredient_table) do
        log('item name: '..name)
        log('ingredient: '..serpent.block(tierChange_ingredient))
        tier_name = tierDecider(tierChange_ingredient[1])
        --log('ingredient tier found')
        --log('the ingredient is in '..serpent.dump(tier_name))
        new_ingredient = tierRan(tier_name)
        log('the new ingredient is '..new_ingredient)
        tierChange_ingredient[1] = new_ingredient 
        data:extend
        {
            {
            type = "recipe",
            name = {name},
            enabled = false,
            ingredients = {tierChange_ingredient},
            result = {name}
            }
        }  
    end
end

for item_name, content in pairs(data.raw.recipe) do   
    if content.ingredients == nil then
        checked_table = content.normal.ingredients
    else
        checked_table = content.ingredients
    end
    if content.category == nil or content.category == 'crafting' then
        content.ingredients = tierChange(content.name, checked_table)
        data:extend{content}
    else
    end
end


---- current issue
--- when going to ingredient table, some recipes are written {type=x, name=x, amount=x}, majority are written {name, amount}. Attempt to use ingredent.name instead of ingredient[1].