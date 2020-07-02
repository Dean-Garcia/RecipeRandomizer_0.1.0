--settings.lua
data:extend({
    {
        type = "int-setting",
        name = "randomizer-seed",
        localised_name = "Randomizer Seed",
        localised_description = "Input seed for randomizer (any number), default = 4815162342",
        setting_type = "startup",
        minimum_value = 1,
        default_value = 4815162342
    }
})

