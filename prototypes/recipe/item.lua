--item.lua

-- Separated items into tiers to keep progression similar
-- tierOne = early game items such as raw materials, 1 item intermediates
-- tierTwo = red/green science items
-- tierThree = oil products/blue science
-- tierFour = purple/yellow science
-- Fluid in own category, barrels same
-- 4,5,6,notused,etc. idk what's up with that

local tierOne = {'iron-ore','iron-plate', 'iron-stick', 'wood', 'copper-ore', 'copper-plate', 'copper-cable','iron-gear-wheel', 'pipe', 'coal', 'iron-chest', 'stone','stone-brick', 'stone-furnace','wooden-chest',}

local tierTwo = {'lab', 'landfill', 'assembling-machine-1', 'big-electric-pole', 'boiler', 'burner-inserter','burner-mining-drill', 'constant-combinator', 'decider-combinator', 'electric-mining-drill', 'electronic-circuit', 'empty-barrel', 'engine-unit', 'fast-inserter','fast-transport-belt','fast-underground-belt', 'filter-inserter', 'gate', 'green-wire', 'inserter', 'long-handed-inserter','medium-electric-pole', 'offshore-pump', 'pipe-to-ground', 'power-switch','programmable-speaker','pump', 'radar','rail-chain-signal','rail-signal','small-electric-pole','red-wire', 'small-lamp','splitter', 'steam-engine', 'steel-chest','steel-furnace', 'steel-plate','stone-wall','transport-belt','underground-belt', 'firearm-magazine','piercing-rounds-magazine', 'boiler', 'automation-science-pack', 'logistic-science-pack', 'military-science-pack','arithmetic-combinator','train-stop','rail'} --circuits

local tierThree = {'accumulator', 'advanced-circuit', 'assembling-machine-2', 'battery', 'chemical-plant','concrete', 'electric-engine-unit', 'fast-splitter', 'oil-refinery', 'plastic-bar', 'pumpjack','rocket-fuel', 'solar-panel','storage-tank','sulfur', 'chemical-science-pack'} --oil products

local tierFluid = { 'crude-oil', 'heavy-oil', 'light-oil','lubricant', 'sulfuric-acid', 'water', 'steam','petroleum-gas'}

local tierFluidBarrel = {'heavy-oil-barrel','light-oil-barrel', 'lubricant-barrel','petroleum-gas-barrel','solid-fuel','sulfuric-acid-barrel','water-barrel','crude-oil-barrel'}

local tierFour = {'electric-furnace', 'logistic-chest-active-provider','logistic-chest-buffer','logistic-chest-passive-provider','logistic-chest-requester','logistic-chest-storage', 'low-density-structure', 'processing-unit', 'roboport', 'rocket-control-unit', 'stack-filter-inserter', 'stack-inserter', 'substation', 'speed-module', 'effectivity-module', 'productivity-module', 'production-science-pack', 'utility-science-pack'} --blue circuits, advanced engines, etc.

local tierFive = {'beacon', 'centrifuge', 'construction-robot','flying-robot-frame', 'hazard-concrete', 'heat-exchanger','heat-pipe','logistic-robot', 'nuclear-fuel',  'refined-concrete', 'refined-hazard-concrete','steam-turbine', 'uranium-235', 'uranium-238', 'uranium-fuel-cell', 'uranium-ore', 'used-up-uranium-fuel-cell', 'express-loader','express-splitter','express-transport-belt','express-underground-belt', 'effectivity-module-2', 'productivity-module-2', 'speed-module-2'}

local tierSix = {'rocket-silo','nuclear-reactor', 'satellite', 'speed-module-3','productivity-module-3','effectivity-module-3'}

local tierNotUsed = {'land-mine',  'artillery-turret', 'laser-turret', 'assembling-machine-3', 
'battery-equipment', 'battery-mk2-equipment', 'belt-immunity-equipment', 'explosives','flamethrower-turret', 'fusion-reactor-equipment', 'gun-turret', 'heat-interface','personal-laser-defense-equipment', 'personal-roboport-equipment', 'personal-roboport-mk2-equipment','player-port', 'small-plane',  'solar-panel-equipment','discharge-defense-equipment','energy-shield-equipment','energy-shield-mk2-equipment','exoskeleton-equipment','rocket'}

local tierGuns = {'combat-shotgun','flamethrower','pistol','railgun','rocket-launcher','shotgun','submachine-gun'}

local tierAmmo = {'artillery-shell', 'atomic-bomb', 'cannon-shell', 'explosive-cannon-shell','explosive-rocket','explosive-uranium-cannon-shell','firearm-magazine','flamethrower-ammo', 'piercing-shotgun-shell','railgun-dart','rocket','shotgun-shell','uranium-cannon-shell','uranium-rounds-magazine', 'grenade', 'cliff-explosives', 'cluster-grenade', 'defender-capsule','destroyer-capsule',' discharge-defense-remote','distractor-capsule','poison-capsule','raw-fish','slowdown-capsule'}

local tierNotVanilla = {'loader','fast-loader','coin','computer'}


-- List of all tiers that the functions will iterate through
local tierList = {tierOne, tierTwo, tierThree, tierFour, tierFluid, tierFive, tierNotUsed, tierSix, tierAmmo, tierGuns, tierNotVanilla, tierFluidBarrel}


function tierDecider(ingredient) --determine what the ingredient tier is in, output that full tier table
    for _dummy,tier in pairs(tierList) do
        for _dummy,item in pairs(tier) do
            if ingredient == item then
                log('found '..item)
                tierD_name = tier
                return tierD_name
            end
        end
    end
end  
     
function tierRan(tierD_name) --take the tier, return a random item; randomize number
    --ran_item_number = game.create_random_generator()
    --ran_item_number(1, table_size(tier_name))
    ran_item_number = math.random(1, table_size(tierD_name))
    --ran_item_number = math.random(1, #tierD_name)
    return tierD_name[ran_item_number]
end

function tierChange(_name, ingredient_table) -- takes ingredients, changes it to another ingredient on the same 'tier', and randomizes number
    for _dummy, tierChange_ingredient in pairs(ingredient_table) do
        log('item name: '.._name)
        log('ingredient: '..serpent.block(tierChange_ingredient))
        
        if tierChange_ingredient['name'] == nil then
            tier_name = tierDecider(tierChange_ingredient[1])
            --log('ingredient tier found')
            --log('the ingredient is in '..serpent.block(tier_name))
            new_ingredient = tierRan(tier_name)
            log('the new ingredient is '..new_ingredient)
            tierChange_ingredient[1] = new_ingredient 
        elseif tierChange_ingredient['name'] ~= nil then
            tier_name = tierDecider(tierChange_ingredient['name'])
            --log('ingredient tier found')
            --log('the ingredient is in '..serpent.block(tier_name))
            new_ingredient = tierRan(tier_name)
            tierChange_ingredient['name'] = new_ingredient 
        end
        data:extend
        {
            {
            type = "recipe",
            name = _name,
            enabled = false,
            ingredients = {tierChange_ingredient},
            result = _name
            }
        }  
    end
end

first_item_name = nil -- establish first name in list so doesn't loop after it expands list

for item_name, content in pairs(data.raw.recipe) do --goes through and checks for all recipes
    log(serpent.block(content)) 
    -- check to make sure it is not the second time seeing the name
    if first_item_name == nil then
        first_item_name = content.name
    elseif first_item_name == content.name then
        return
    end
   
    if content.name ~= nil then -- checks to see if there is a normal/expensive ingredient and uses that if available. otherwise uses normal table
        if content.ingredients == nil then
            checked_table = content.normal.ingredients
        else
            checked_table = content.ingredients
        end
        if content.category == nil or content.category == 'crafting' then -- checks category to make sure it's not wonky
        --content.ingredients = tierChange(content.name, checked_table)
            tierChange(content.name, checked_table)
        end
    else
        log('we got a nil')
    end
end