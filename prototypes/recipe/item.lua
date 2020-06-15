--item.lua

-- Separated items into tiers to keep progression similar
-- tierOne = early game items such as raw materials, 1 item intermediates
-- tierTwo = red/green science items
-- tierThree = oil products/blue science
-- tierFour = purple/yellow science
-- Fluid in own category, barrels same
-- 4,5,6,notused,etc. idk what's up with that

-- main purpose: iterate through all items in game, isolate ingredients, change them.

-- pseudocode setup:
-- Iterate through items, isolate ingredient table
--     * Determine Value of item
--     * Iterate through ingredients
--         * Change Ingredients/numbers to something else in similar tier, checking against value
--                * Get ingredient and change to tier in same tier
--                       * Get ingredient name
--                       * find what tier
--                       * find new ingredient in same tier 
--                       * add ingredient item value to count
--                              * Check to see if new ingredient values are higher than OG value
--                                    * If higher
--                                         * Reduce number
--                                         * Or Remove entry
--                                    * if lower, move to next ingredient
--                * Write New ingredient to table


--__DebugAdapter.breakpoint()


crudeOilValue = 10
heavyOilValue = 3
lightOilValue = 5
lubricantValue = 4
sulfuricAcidValue = 12
waterValue = .3
steamValue = 1
petroleumGasValue = 6 
u235Value = 1000
u238Value = 15
uOreValue = 50
plasticBarValue = ((10 + (20 * petroleumGasValue))/2)
batteryValue = (sulfuricAcidValue*20) + 29
redCircuitValue = (112 + plasticBarValue)
processingUnitValue = ((2*redCircuitValue)+805+(5*sulfuricAcidValue))
moduleValue = (5*redCircuitValue) + 205
flyingRobotFrameValue = (200 + (lubricantValue*15) + (2*batteryValue) + 195)
lowDensityStructureValue = (385+(5*plasticBarValue))
explosiveValue = (10+(petroleumGasValue*15+10))/2

local notFinite = {}

local tierRawPlates = {
    {'iron-ore', 10},
    {'iron-plate', 12},
    {'iron-stick', 15},
    {'iron-gear-wheel', 25},
    {'iron-chest', 85},
    {'pipe', 15},
    {'copper-ore', 10},
    {'copper-plate', 12},
    {'copper-cable', 8},
    {'coal', 8},
    {'stone', 10},
    {'stone-brick', 25},
    {'stone-furnace', 55},
    {'wooden-chest', 25}, 
    {'wood', 10}}

local tierRedScience = {
    {'lab', 615}, 
    {'landfill', 205}, 
    {'assembling-machine-1', 355}, 
    {'big-electric-pole', 530}, 
    {'boiler', 120}, 
    {'burner-inserter', 32},
    {'burner-mining-drill', 141}, 
    {'electric-mining-drill', 320}, 
    {'electronic-circuit', 40}, 
    {'inserter', 72},  
    {'offshore-pump', 115}, 
    {'pipe-to-ground', 110},  
    {'radar', 400},
    {'small-electric-pole', 40}, 
    {'small-lamp', 81},
    {'splitter', 325}, 
    {'steam-engine', 315}, 
    {'stone-wall', 130},
    {'transport-belt', 15},
    {'underground-belt', 103}, 
    {'firearm-magazine', 53}, 
    {'boiler', 120}, 
    {'automation-science-pack', 32}, 
    {'logistic-science-pack', 92}, 
    {'gun-turret', 515},
    {'pistol', 125},
    {'shotgun', 430}, 
    {'shotgun-shell', 53},
    {'submachine-gun', 335},
    {'light-armor', 480},
    {'repair-pack', 130}}

local tierGreenScience = {
    {'heavy-armor', 4705},
    {'constant-combinator', 125},
    {'decider-combinator', 245}, 
    {'empty-barrel', 75}, 
    {'engine-unit', 120}, 
    {'fast-inserter', 181},
    {'fast-transport-belt', 95},
    {'fast-underground-belt', 406}, 
    {'filter-inserter', 346}, 
    {'gate', 355}, 
    {'green-wire', 53}, 
    {'red-wire', 53}, 
    {'long-handed-inserter', 104},
    {'medium-electric-pole', 229},
    {'power-switch', 185}, 
    {'programmable-speaker', 301}, 
    {'steel-chest', 565},
    {'steel-furnace', 675}, 
    {'steel-plate', 70}, 
    {'piercing-rounds-magazine', 188}, 
    {'arithmetic-combinator', 245}, 
    {'train-stop', 577},
    {'rail', 100},
    {'rail-chain-signal', 105},
    {'rail-signal', 105},
    {'fast-splitter', 680},
    {'pump', 210}, 
    {'grenade', 145}}

local tierOil = {
    {'accumulator', (24 + (20*sulfuricAcidValue))},
    {'car', 1550},
    {'locomotive', 4900}, 
    {'cargo-wagon', 1895},
    {'fluid-wagon', 1495},
    {'advanced-circuit', (112 + plasticBarValue)}, 
    {'assembling-machine-2', 695}, 
    {'battery', batteryValue}, 
    {'chemical-plant', 705},
    {'concrete', 190}, 
    {'electric-engine-unit', (200 + (lubricantValue*15))},  
    {'oil-refinery', 2000}, 
    {'plastic-bar', plasticBarValue}, 
    {'pumpjack', 850}, 
    {'solar-panel', 1015},
    {'storage-tank', 595},
    {'sulfur', (petroleumGasValue*15 + 10)},
    {'chemical-science-pack', ((((112 + plasticBarValue)*3)+((petroleumGasValue*15 + 10)*3)+245)/2)},
    {'laser-turret', ((batteryValue*12)+2205)}, 
    {'explosives', explosiveValue}, 
    {'flamethrower-turret', 3080}, 
    {'rocket', (petroleumGasValue*15 + 79)}, 
    {'flamethrower', 505}, 
    {'rocket-launcher', 340}, 
    {'flamethrower-ammo', (350+(crudeOilValue*100))}, 
    {'piercing-shotgun-shell', 309}, 
    {'military-science-pack', 300}, 
    {'solid-fuel', 60}} 

local tierFluid = {
    {'crude-oil', crudeOilValue},         {'heavy-oil', heavyOilValue}, 
    {'light-oil', lightOilValue},         {'lubricant', lubricantValue},
    {'sulfuric-acid', sulfuricAcidValue}, {'water', waterValue},
    {'steam', steamValue},               {'petroleum-gas', petroleumGasValue}}

local tierFluidBarrel = {
    {'heavy-oil-barrel', (heavyOilValue*50 + 80)},
    {'light-oil-barrel', lightOilValue*50+80}, 
    {'lubricant-barrel', lubricantValue*50+80},
    {'petroleum-gas-barrel', petroleumGasValue*50+80},
    {'sulfuric-acid-barrel', sulfuricAcidValue*50+80},
    {'water-barrel', waterValue*50+80},
    {'crude-oil-barrel', crudeOilValue+80}}

local tierBlueScience = {
    {'modular-armor', ((30*redCircuitValue)+3505)},
    {'night-vision-equipment', ((5*redCircuitValue)+705)},
    {'defender-capsule', 734}, 
    {'slowdown-capsule', 275},
    {'explosive-cannon-shell', ((2*explosiveValue)+(2*plasticBarValue)+145)},
    {'electric-furnace', (redCircuitValue*5 + 955)},
    {'logistic-chest-passive-provider', (redCircuitValue+120+565+5)},
    {'logistic-chest-storage', (redCircuitValue+120+565+5)},
    {'low-density-structure', lowDensityStructureValue},
    {'processing-unit', processingUnitValue},
    {'roboport', ((45*redCircuitValue)+(45*15+45*70+5))},
    {'rocket-control-unit', (processingUnitValue + moduleValue)},
    {'stack-filter-inserter', (1216 + redCircuitValue)},
    {'stack-inserter', (1011 + redCircuitValue)},
    {'substation', ((5*redCircuitValue)+765)},
    {'speed-module', moduleValue},
    {'effectivity-module', moduleValue},
    {'productivity-module', moduleValue},
    {'flying-robot-frame', flyingRobotFrameValue},
    {'battery-equipment', (5*batteryValue + 705)},
    {'belt-immunity-equipment', (5*redCircuitValue+705)},
    {'solar-panel-equipment', (1375+ 2*redCircuitValue)},
    {'energy-shield-equipment', (5*redCircuitValue+705)},
    {'combat-shotgun', 1350},
    {'cannon-shell', ((15+(petroleumGasValue*15 + 10))+(2*plasticBarValue)+145)},
    {'explosive-rocket', ((2*explosiveValue)+(petroleumGasValue*15 + 79))},
    {'cliff-explosives', (220+(10*explosiveValue))},
    {'rocket-fuel', (600+10*lightOilValue)},
    {'land-mine', ((2*explosiveValue+75)/4)},
    {'poison-capsule', (485)}} 

local tierNuclear = {
    {'power-armor', ((40*processingUnitValue)+2805+(200 + (lubricantValue*15)))},
    {'tank', ((10*redCircuitValue)+7720)},
    {'exoskeleton-equipment', ((30*(200 + (lubricantValue*15))+(10*processingUnitValue)+1405))}, 
    {'personal-laser-defense-equipment', ((5*((batteryValue*12)+2205))+(5*lowDensityStructureValue)+(20*processingUnitValue)+5)},
    {'construction-robot', (85+flyingRobotFrameValue)}, 
    {'logistic-robot', ((2*redCircuitValue)+flyingRobotFrameValue+5)},
    {'production-science-pack', (((redCircuitValue*5 + 955) + moduleValue + 3005)/3)}, 
    {'utility-science-pack', ((flyingRobotFrameValue + (3*lowDensityStructureValue)+(2*processingUnitValue))/3)}, 
    {'beacon', (20*redCircuitValue + 1585)}, 
    {'centrifuge', ((100*redCircuitValue)+24005)},  
    {'hazard-concrete', 195}, 
    {'heat-exchanger', 2050},
    {'heat-pipe', 940}, 
    {'nuclear-fuel', ((600+10*lightOilValue)+ u235Value)},  
    {'refined-concrete', 410}, 
    {'refined-hazard-concrete', 415},
    {'steam-turbine', 1650}, 
    {'uranium-235', u235Value}, 
    {'uranium-238', u238Value}, 
    {'uranium-fuel-cell', ((150+u235Value+(19*u238Value))/10)}, 
    {'uranium-ore', uOreValue},    
    {'express-splitter', ((10*redCircuitValue)+680+155+(80*lubricantValue))},
    {'express-transport-belt', (95+155+(20*lubricantValue))},
    {'express-underground-belt', (2012+40*lubricantValue)}, 
    {'effectivity-module-2', ((5*redCircuitValue)+(5*processingUnitValue)+(4*moduleValue)+5)}, 
    {'productivity-module-2', ((5*redCircuitValue)+(5*processingUnitValue)+(4*moduleValue)+5)}, 
    {'speed-module-2', ((5*redCircuitValue)+(5*processingUnitValue)+(4*moduleValue)+5)}, 
    {'assembling-machine-3',(695+4*moduleValue)},
    {'battery-mk2-equipment', ((10*batteryValue)+(5*lowDensityStructureValue)+(15*processingUnitValue)+5)},
    {'personal-roboport-equipment', ((10*redCircuitValue)+(45*batteryValue)+2005)}, 
    {'energy-shield-mk2-equipment', (((5*redCircuitValue+705)*10)+(5*lowDensityStructureValue)+(5*processingUnitValue))},      
    {'uranium-rounds-magazine', (u238Value+193)}, 
    {'cluster-grenade', ((5*explosiveValue)+1365)}, 
    {'distractor-capsule', (2936+3*redCircuitValue)},     
    {'discharge-defense-remote', ((10*((batteryValue*12)+2205))+(5*processingUnitValue)+1405)},      
    {'discharge-defense-equipment', ((10*((batteryValue*12)+2205))+(5*processingUnitValue)+1405)},
    {'explosive-uranium-cannon-shell', (((2*explosiveValue)+(2*plasticBarValue)+145)+u238Value)}}

local tierLateGame = {
    {'power-armor-mk2', ((50*((5*redCircuitValue)+(5*processingUnitValue)+(4*moduleValue)+5))+(40*(200 + (lubricantValue*15)))+(30*lowDensityStructureValue)+(60*processingUnitValue))},
    {'artillery-turret', ((20*redCircuitValue)+16200)},
    {'artillery-wagon', ((20*redCircuitValue)+10975)},
    {'artillery-targeting-remote', (processingUnitValue+405)},
    {'artillery-shell', ((4*((2*explosiveValue)+(2*plasticBarValue)+145))+(8*explosiveValue)+405)},   
    {'speed-module-3', ((5*redCircuitValue)+(5*processingUnitValue)+(5*((5*redCircuitValue)+(5*processingUnitValue)+(4*moduleValue)+5)))},
    {'productivity-module-3', ((5*redCircuitValue)+(5*processingUnitValue)+(5*((5*redCircuitValue)+(5*processingUnitValue)+(4*moduleValue)+5)))},
    {'effectivity-module-3', ((5*redCircuitValue)+(5*processingUnitValue)+(5*((5*redCircuitValue)+(5*processingUnitValue)+(4*moduleValue)+5)))},
    {'fusion-reactor-equipment', ((50*lowDensityStructureValue)+(200*processingUnitValue))}, 
    {'personal-roboport-mk2-equipment', ((20*lowDensityStructureValue)+(5*((10*redCircuitValue)+(45*batteryValue)+2005))+(100*processingUnitValue))},       
    {'uranium-cannon-shell', (((15+(petroleumGasValue*15 + 10))+(2*plasticBarValue)+145)+u238Value)}, 
    {'logistic-chest-active-provider', (redCircuitValue+120+565+5)},
    {'logistic-chest-buffer', (redCircuitValue+120+565+5)},
    {'logistic-chest-requester', (redCircuitValue+120+565+5)},
    {'destroyer-capsule', ((4*(2936+3*redCircuitValue))+moduleValue)}
}

local tierEndGame = {
    {'rocket-silo', (190000+(200*(200 + (lubricantValue*15)))+1500+(200*processingUnitValue)+70000)},
    {'nuclear-reactor', ((500*redCircuitValue)+(500*190)+(500*12)+(500*70))}, 
    {'satellite', ((100*(24 + (20*sulfuricAcidValue)))+(100*lowDensityStructureValue)+(100*processingUnitValue)+(2000)+(50*(600+10*lightOilValue))+(100*1015))},
    {'atomic-bomb', ((10*explosiveValue)+(10*(processingUnitValue + moduleValue))+(30*u235Value))}}

local tierNotUsed = {{'loader', 820},{'fast-loader', 00},{'coin', 00},{'computer', 00},{'heat-interface', 00}, {'player-port', 00},{'small-plane', 00}, {'railgun', 00}, {'railgun-dart', 00}, {'raw-fish', 00}, {'used-up-uranium-fuel-cell', 00}, {'express-loader', 00}, {'electric-energy-interface', 00}}

-- List of all tiers that the functions will iterate through
local tierList = {tierNotFinite, tierRawPlates, tierRedScience, tierGreenScience, tierOil, tierFluid, tierFluidBarrel, tierBlueScience, tierNuclear, tierLateGame, tierEndGame, tierNotUsed}

function tierDecider(ingredient) --determine what the ingredient tier is in, output that full tier table
    for _dummy,tier in pairs(tierList) do
        for _dummy,item in pairs(tier) do
            if ingredient == item[1] then
                --log('found '..item[1])
                tierD_name = tier
                return tierD_name
            end
        end
    end
end  
     
function tierRan(tierD_name, value) --take the tier, return a random item; randomize number
    --ran_item_number = game.create_random_generator()
    --ran_item_number(1, table_size(tier_name))

    ran_item_number = math.random(1, table_size(tierD_name))
    --ran_item_number = math.random(1, #tierD_name)
    
    local new_ran_ingredient = tierD_name[ran_item_number][1]
    local new_ran_ingredient_value = tierD_name[ran_item_number][2]
    local new_ran_ingredient_amount = math.floor((value*1.1)/new_ran_ingredient_value) 
    local count = 0

    while new_ran_ingredient_amount == 0 do
        ran_item_number = math.random(1, table_size(tierD_name))
        new_ran_ingredient = tierD_name[ran_item_number][1]
        new_ran_ingredient_value = tierD_name[ran_item_number][2]
        new_ran_ingredient_amount = math.floor((value*1.1)/new_ran_ingredient_value)
        count = count + 1
        if count > 25 then
            log("*****************************************************************************")
            log("*****************************************************************************") 
            log("*****************************************************************************")             
            return nil, nil, nil
            --error()
        end
    end

    --log('the total value is: '..tostring(ingredient_total_value)..' which was '..tostring(new_ran_ingredient_value)..' x '..tostring(amount))
    local n = 0 -- for while loop
        
    while n == 0 do -- setup while loop to check duplicate ingredients
        n = 1
        -- goes through ingredient table and rerandoms number/item if duplicate
        for _dummy, ran_ingredient in pairs(full_ingredient_table) do 
            -- consider changing while loop
            while ran_ingredient[1] == new_ran_ingredient or new_ran_ingredient == 'wood' or current_item_name == new_ran_ingredient do
                --log('the ingredient already exists on the table')
                ran_item_number = math.random(1, table_size(tierD_name))
                new_ran_ingredient = tierD_name[ran_item_number][1]
                new_ran_ingredient_value = tierD_name[ran_item_number][2]
                n = 0
            end            
        end
    end
    return new_ran_ingredient, new_ran_ingredient_value, new_ran_ingredient_amount
end


function retrieveValue(_name) -- retrieve the value of the original item recipe
    for _dummy,tier in pairs(tierList) do
        for _dummy,item in pairs(tier) do
            if _name == item[1] then
                log('OG Value is '..item[2])
                return item[2]                
            end
        end    
    end
    log('Did not find '.._name..' in list')
end

function tierChange(_name, ingredient_table) -- takes ingredients, changes it to another ingredient on the same 'tier', and randomizes number
    full_ingredient_table = {}
    tableSize = table_size(ingredient_table)
    original_item_value = retrieveValue(_name) -- initialize variable for OG value
    target_value = original_item_value / tableSize
    new_item_value = 0
            
    for _dummy, tierChange_ingredient in pairs(ingredient_table) do
        --log('item name: '.._name)
        --log('ingredient: '..serpent.block(tierChange_ingredient))
        if tierChange_ingredient['name'] == nil then
            tier_name = tierDecider(tierChange_ingredient[1])
            if tier_name == 'tierNotUsed' then
                log('we got a problem here, boss')
                return
            end
            quantity_original_ingredient = tierChange_ingredient[2]
            --log('ingredient, amount is '..tierChange_ingredient[1]..', '..(quantity_original_ingredient))
            new_ingredient, new_ingredient_value, new_ingredient_amount = tierRan(tier_name, target_value)
            if new_ingredient ~= nil and new_ingredient_value ~= nil and new_ingredient_amount ~= nil then
                new_item_value = new_item_value + new_ingredient_amount*new_ingredient_value
                --log('the new ingredient is '..new_ingredient)
                --log('the value of those ingredients are '..tostring(new_item_value))
                tierChange_ingredient[1] = new_ingredient
                tierChange_ingredient[2] = new_ingredient_amount 
                table.insert(full_ingredient_table, tierChange_ingredient)
            end
        elseif tierChange_ingredient['name'] ~= nil then
            tier_name = tierDecider(tierChange_ingredient['name'])
            if tier_name == 'tierNotUsed' then
                log('we got a problem here, boss')
                return
            end
            quantity_original_ingredient = tierChange_ingredient['amount']
            new_ingredient, new_ingredient_value, new_ingredient_amount = tierRan(tier_name, target_value)
            if new_ingredient ~= nil and new_ingredient_value ~= nil and new_ingredient_amount ~= nil then
                new_item_value = new_item_value + new_ingredient_amount*new_ingredient_value            
                --log('the new ingredient is '..new_ingredient)
                --log('the value of those ingredients are '..tostring(new_item_value))
                tierChange_ingredient['name'] = new_ingredient
                tierChange_ingredient['amount'] = new_ingredient_amount            
                table.insert(full_ingredient_table, tierChange_ingredient)
            end
        end        
    end
    --log(serpent.block(full_ingredient_table))
    --log('OG value '..tostring(original_item_value))
    --log('new value '..tostring(new_item_value))
    
    return full_ingredient_table   
end

first_item_name = nil -- establish first name in list so doesn't loop after it expands list

for item_name, content in pairs(data.raw.recipe) do --goes through and checks for all recipes
    --log(serpent.block(content))
    log('item name: '..content.name)
    changed = false
    current_item_name = content.name
   
    -- check to make sure it is not the second time seeing the name
    if first_item_name == nil then
        first_item_name = content.name
    elseif first_item_name == content.name then
        return
    end
   
    -- check to make sure it is not in tierNotUsed so we can skip it
    for _, item in pairs(tierNotUsed) do
        if item[1] == current_item_name then
            goto ending
            --**********want to move on to next loop iteration instead, GOTO?!!??!?!?!??!?!
        end
    end

    if content.name ~= nil then -- checks to see if there is a normal/expensive ingredient and uses that if available. otherwise uses normal table
        if content.ingredients == nil then
            checked_table = content.normal.ingredients
            ingredient_table_check = false
        else
            checked_table = content.ingredients
            ingredient_table_check = true
        end
        if content.category == nil or content.category == 'crafting' then -- checks category to make sure it's not wonky
        --content.ingredients = tierChange(content.name, checked_table)
            full_ingredient_table = tierChange(content.name, checked_table)
            if ingredient_table_check == true then
                content.ingredients = full_ingredient_table
                changed = true
                --data:extend{content.ingredients}
            else 
                content.normal.ingredients = full_ingredient_table
                --data:extend{content.normal.ingredients}
                changed = true
            end
        end
    else
        log('we got a nil')
    end
    log('Recipe changed? '..tostring(changed))
    data:extend{content}
    ::ending::
end 

--current issue = "tiers not balanced. raw material need can get a little crazy"
--current project = "if name is in notUsedTier, skip completely. use goto? use if block?"
--on the docket = "fluids, rebalance tiers, re-evaluate items with iron gear wheels (from 15 to 25), add logic ot prevent items needing itself to be made like radar/splitter sitch