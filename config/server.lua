return {
    autoRespawn = false, -- True == auto respawn cars that are outside into your garage on script restart, false == does not put them into your garage and players have to go to the impound
    warpInVehicle = true, -- If false, player will no longer warp into vehicle upon taking the vehicle out.
    doorsLocked = true, -- If true, the doors will be locked upon taking the vehicle out.
    distanceCheck = 5.0, -- The distance that needs to bee clear to let the vehicle spawn, this prevents vehicles stacking on top of each other

    limits = {
        enable = true, -- enable vehicle limits per garage
        default = 3, -- default limit if not specified in garage config
        upgrades = { -- upgrades to increase vehicle limit per garage
            max = 10, -- maximum limit a garage can reach with upgrades
            costs = {
                base = 750, -- base cost for first upgrade
                multiplier = 1.8, -- multiplier for each subsequent upgrade
            },
        },
        customMultiplier = function(src, garage)
            return 1.0
        end
    },

    ---calculates the automatic impound fee.
    ---@param vehicleId integer
    ---@param modelName string
    ---@return integer fee
    calculateImpoundFee = function(vehicleId, modelName)
        return 175.0
    end,

    ---@class GarageBlip
    ---@field name? string -- Name of the blip. Defaults to garage label.
    ---@field sprite? number -- Sprite for the blip. Defaults to 357
    ---@field color? number -- Color for the blip. Defaults to 3.

    ---The place where the player can access the garage and spawn a car
    ---@class AccessPoint
    ---@field coords vector4 where the garage menu can be accessed from
    ---@field blip? GarageBlip
    ---@field spawn? vector4 where the vehicle will spawn. Defaults to coords
    ---@field dropPoint? vector3 where a vehicle can be stored, Defaults to spawn or coords

    ---@class GarageConfig
    ---@field label string -- Label for the garage
    ---@field type? GarageType -- Optional special type of garage. Currently only used to mark DEPOT garages.
    ---@field vehicleType VehicleType -- Vehicle type
    ---@field limit? integer custom vehicle limit for this garage. Requires limits.enable to be true.
    ---@field canUpgrade? boolean defaults to true. If false, the vehicle limit for this garage cannot be upgraded.
    ---@field groups? string | string[] | table<string, number> job/gangs that can access the garage
    ---@field shared? boolean defaults to false. Shared garages give all players with access to the garage access to all vehicles in it. If shared is off, the garage will only give access to player's vehicles which they own.
    ---@field states? VehicleState | VehicleState[] if set, only vehicles in the given states will be retrievable from the garage. Defaults to GARAGED.
    ---@field skipGarageCheck? boolean if true, returns vehicles for retrieval regardless of if that vehicle's garage matches this garage's name
    ---@field canAccess? fun(source: number): boolean checks access as an additional guard clause. Other filter fields still need to pass in addition to this function.
    ---@field accessPoints AccessPoint[]

    ---@type table<string, GarageConfig>
    garages = {
        -- Public Garages
        motelgarage = {
            label = 'Garage Motel',
            vehicleType = VehicleType.CAR,
            accessPoints = {
                {
                    blip = {
                        name = 'Garage publique',
                        sprite = 357,
                        color = 3,
                    },
                    coords = vec4(275.58, -344.74, 45.17, 70.0),
                    spawn = vec4(283.82, -352.6, 45.06, 160.31),
                    dropPoint = vec3(272.72, -334.84, 44.92),
                }
            },
        },
        -- sapcounsel = {
        --     label = 'San Andreas Garage',
        --     vehicleType = VehicleType.CAR,
        --     accessPoints = {
        --         {
        --             blip = {
        --                 name = 'Garage publique',
        --                 sprite = 357,
        --                 color = 3,
        --             },
        --             coords = vec4(-330.67, -781.12, 33.96, 40.46),
        --             spawn = vec4(-337.11, -775.34, 33.56, 132.09),
        --         }
        --     },
        -- },
        spanishave = {
            label = 'Garage Spanish Ave',
            vehicleType = VehicleType.CAR,
            accessPoints = {
                {
                    blip = {
                        name = 'Garage publique',
                        sprite = 357,
                        color = 3,
                    },
                    coords = vec4(-1159.19, -740.21, 19.89, 275.12),
                    spawn = vec4(-1134.52, -774.59, 17.96, 217.04),
                    dropPoint = vec3(-1157.93, -745.84, 19.34),
                }
            },
        },
        -- caears24 = {
        --     label = 'Caears 24 Garage',
        --     vehicleType = VehicleType.CAR,
        --     accessPoints = {
        --         {
        --             blip = {
        --                 name = 'Garage publique',
        --                 sprite = 357,
        --                 color = 3,
        --             },
        --             coords = vec4(68.08, 13.15, 69.21, 160.44),
        --             spawn = vec4(72.61, 11.72, 68.47, 157.59),
        --         },
        --     },
        -- },
        littleseoul = {
            label = 'Garage Little Seoul',
            vehicleType = VehicleType.CAR,
            accessPoints = {
                {
                    blip = {
                        name = 'Garage publique',
                        sprite = 357,
                        color = 3,
                    },
                    coords = vec4(-450.64, -793.95, 30.54, 90.96),
                    spawn = vec4(-472.21, -813.3, 30.52, 178.86),
                    dropPoint = vec3(-453.93, -806.92, 30.54),
                }
            },
        },
        lagunapi = {
            label = 'Garage Laguna',
            vehicleType = VehicleType.CAR,
            accessPoints = {
                {
                    blip = {
                        name = 'Garage publique',
                        sprite = 357,
                        color = 3,
                    },
                    coords = vec4(363.85, 297.97, 103.5, 341.39),
                    spawn = vec4(368.36, 300.86, 103.44, 344.87),
                    dropPoint = vec3(366.82, 292.59, 103.41),
                }
            },
        },
        airportp = {
            label = 'Garage Aéroport',
            vehicleType = VehicleType.CAR,
            accessPoints = {
                {
                    blip = {
                        name = 'Garage publique',
                        sprite = 357,
                        color = 3,
                    },
                    coords = vec4(-796.07, -2023.26, 9.17, 55.18),
                    spawn = vec4(-790.63, -2022.27, 8.87, 61.27),
                    dropPoint = vec3(-786.71, -2033.02, 8.87),
                }
            },
        },
        beachp = {
            label = 'Garage Plage',
            vehicleType = VehicleType.CAR,
            accessPoints = {
                {
                    blip = {
                        name = 'Garage publique',
                        sprite = 357,
                        color = 3,
                    },
                    coords = vec4(-1184.21, -1509.65, 4.65, 303.72),
                    spawn = vec4(-1182.24, -1504.42, 4.38, 214.8),
                    dropPoint = vec3(-1190.93, -1493.9, 4.38),
                }
            },
        },
        -- themotorhotel = {
        --     label = 'The Motor Hotel Garage',
        --     vehicleType = VehicleType.CAR,
        --     accessPoints = {
        --         {
        --             blip = {
        --                 name = 'Garage publique',
        --                 sprite = 357,
        --                 color = 3,
        --             },
        --             coords = vec4(1137.77, 2663.54, 37.9, 0.0),
        --             spawn = vec4(1137.56, 2674.19, 38.17, 359.95),
        --         }
        --     },
        -- },
        -- liqourGarage = {
        --     label = 'Liqour Garage',
        --     vehicleType = VehicleType.CAR,
        --     accessPoints = {
        --         {
        --             blip = {
        --                 name = 'Garage publique',
        --                 sprite = 357,
        --                 color = 3,
        --             },
        --             coords = vec4(960.68, 3609.32, 32.98, 268.97),
        --             spawn = vec4(960.48, 3605.71, 32.98, 87.09),
        --         }
        --     },
        -- },
        -- shoreGarage = {
        --     label = 'Shore Garage',
        --     vehicleType = VehicleType.CAR,
        --     accessPoints = {
        --         {
        --             blip = {
        --                 name = 'Garage publique',
        --                 sprite = 357,
        --                 color = 3,
        --             },
        --             coords = vec4(1726.9, 3710.38, 34.26, 22.54),
        --             spawn = vec4(1728.65, 3714.85, 34.18, 21.26),
        --         }
        --     },
        -- },
        -- haanGarage = {
        --     label = 'Bell Farms Garage',
        --     vehicleType = VehicleType.CAR,
        --     accessPoints = {
        --         {
        --             blip = {
        --                 name = 'Garage publique',
        --                 sprite = 357,
        --                 color = 3,
        --             },
        --             coords = vec4(78.34, 6418.74, 31.28, 0),
        --             spawn = vec4(70.71, 6425.16, 30.92, 68.5),
        --         }
        --     },
        -- },
        -- dumbogarage = {
        --     label = 'Dumbo Private Garage',
        --     vehicleType = VehicleType.CAR,
        --     accessPoints = {
        --         {
        --             blip = {
        --                 name = 'Garage publique',
        --                 sprite = 357,
        --                 color = 3,
        --             },
        --             coords = vec4(157.26, -3240.00, 7.00, 0),
        --             spawn = vec4(165.32, -3236.10, 5.93, 268.5),
        --         }
        --     },
        -- },
        pillboxgarage = {
            label = 'Garage Pillbox Hill',
            vehicleType = VehicleType.CAR,
            accessPoints = {
                {
                    blip = {
                        name = 'Garage publique',
                        sprite = 357,
                        color = 3,
                    },
                    coords = vec3(213.8, -809.19, 31.01),
                    spawn = vec4(229.33, -805.01, 30.54, 156.79),
                    dropPoint = vec3(212.71, -796.69, 30.87),
                }
            },
        },
        intairport = {
            label = 'Garage Aéroport',
            vehicleType = VehicleType.AIR,
            accessPoints = {
                {
                    blip = {
                        name = 'Hangar',
                        sprite = 360,
                        color = 3,
                    },
                    coords = vec4(-1025.34, -3017.0, 13.95, 331.99),
                    spawn = vec4(-1021.53, -2976.8, 13.95, 64.0),
                    dropPoint = vec3(-1006.53, -3014.28, 13.95),
                }
            },
        },
        higginsheli = {
            label = 'Garage Higgins Helitours',
            vehicleType = VehicleType.AIR,
            accessPoints = {
                {
                    blip = {
                        name = 'Hangar',
                        sprite = 360,
                        color = 3,
                    },
                    coords = vec4(-722.12, -1472.74, 5.0, 140.0),
                    spawn = vec4(-724.83, -1443.89, 5.0, 140.0),
                    dropPoint = vec3(-745.37, -1468.46, 5.0),
                }
            },
        },
        -- airsshores = {
        --     label = 'Sandy Shores Hangar',
        --     vehicleType = VehicleType.AIR,
        --     accessPoints = {
        --         {
        --             blip = {
        --                 name = 'Hangar',
        --                 sprite = 360,
        --                 color = 3,
        --             },
        --             coords = vec4(1757.74, 3296.13, 41.15, 142.6),
        --             spawn = vec4(1740.88, 3278.99, 41.09, 189.46),
        --         }
        --     },
        -- },
        lsymc = {
            label = 'Garage LSYMC',
            vehicleType = VehicleType.SEA,
            accessPoints = {
                {
                    blip = {
                        name = 'Hangar à bateaux',
                        sprite = 356,
                        color = 3,
                    },
                    coords = vec4(-794.64, -1510.89, 1.6, 201.55),
                    spawn = vec4(-793.58, -1501.4, 0.25, 111.5),
                }
            },
        },
        -- paleto = {
        --     label = 'Paleto Boathouse',
        --     vehicleType = VehicleType.SEA,
        --     accessPoints = {
        --         {
        --             blip = {
        --                 name = 'Boathouse',
        --                 sprite = 356,
        --                 color = 3,
        --             },
        --             coords = vec4(-277.4, 6637.01, 7.5, 40.51),
        --             spawn = vec4(-289.2, 6637.96, 1.01, 45.5),
        --         }
        --     },
        -- },
        -- millars = {
        --     label = 'Millars Boathouse',
        --     vehicleType = VehicleType.SEA,
        --     accessPoints = {
        --         {
        --             blip = {
        --                 name = 'Boathouse',
        --                 sprite = 356,
        --                 color = 3,
        --             },
        --             coords = vec4(1299.02, 4216.42, 33.91, 166.8),
        --             spawn = vec4(1296.78, 4203.76, 30.12, 169.03),
        --         }
        --     },
        -- },

        -- Job Garages
        lspd = {
            label = 'Garage Los Santos Police Department',
            vehicleType = VehicleType.CAR,
            groups = 'police',
            shared = true,
            limit = 25,
            canUpgrade = false,
            accessPoints = {
                {
                    coords = vec4(-578.13, -419.0, 31.16, 87.98),
                    spawn = vec4(-577.38, -413.79, 31.16, 267.67),
                    dropPoint = vec3(-582.71, -422.34, 31.16),
                }
            },
        },
        lsmc = {
            label = 'Garage Los Santos Medical Center',
            vehicleType = VehicleType.CAR,
            groups = 'ambulance',
            shared = true,
            limit = 25,
            canUpgrade = false,
            accessPoints = {
                {
                    coords = vec4(89.37, -427.09, 39.38, 344.14),
                    spawn = vec4(60.11, -423.32, 39.28, 342.75),
                    dropPoint = vec3(80.21, -430.85, 39.38),
                }
            },
        },
        usss = {
            label = 'Garage United States Secret Service',
            vehicleType = VehicleType.CAR,
            groups = 'usss',
            shared = true,
            limit = 25,
            canUpgrade = false,
            accessPoints = {
                {
                    coords = vec4(-577.67, -715.71, 26.73, 177.54),
                    spawn = vec4(-598.02, -713.84, 26.73, 90.48),
                    dropPoint = vec3(-580.05, -721.54, 26.73),
                }
            },
        },
        lscustoms = {
            label = 'Garage Ls Customs',
            vehicleType = VehicleType.CAR,
            groups = 'lscustoms',
            shared = true,
            limit = 10,
            canUpgrade = false,
            accessPoints = {
                {
                    coords = vec4(-354.67, -125.44, 39.44, 71.37),
                    spawn = vec4(-365.09, -148.23, 38.25, 124.03),
                    dropPoint = vec3(-357.93, -120.38, 38.7),
                }
            },
        },

        -- Impound Lots
        impoundlot = {
            label = 'Fourrière',
            type = GarageType.DEPOT,
            states = {VehicleState.OUT, VehicleState.IMPOUNDED},
            skipGarageCheck = true,
            vehicleType = VehicleType.CAR,
            canUpgrade = false,
            accessPoints = {
                {
                    blip = {
                        name = 'Fourrière voitures',
                        sprite = 68,
                        color = 3,
                    },
                    coords = vec4(400.45, -1630.87, 29.29, 228.88),
                    spawn = vec4(407.2, -1645.58, 29.31, 228.28),
                }
            },
        },
        airdepot = {
            label = 'Fourrière',
            type = GarageType.DEPOT,
            states = {VehicleState.OUT, VehicleState.IMPOUNDED},
            skipGarageCheck = true,
            vehicleType = VehicleType.AIR,
            canUpgrade = false,
            accessPoints = {
                {
                    blip = {
                        name = 'Fourrière avions',
                        sprite = 359,
                        color = 3,
                    },
                    coords = vec4(-1244.35, -3391.39, 13.94, 59.26),
                    spawn = vec4(-1269.03, -3376.7, 13.94, 330.32),
                }
            },
        },
        seadepot = {
            label = 'Fourrière',
            type = GarageType.DEPOT,
            states = {VehicleState.OUT, VehicleState.IMPOUNDED},
            skipGarageCheck = true,
            vehicleType = VehicleType.SEA,
            canUpgrade = false,
            accessPoints = {
                {
                    blip = {
                        name = 'Fourrière bateaux',
                        sprite = 356,
                        color = 3,
                    },
                    coords = vec4(-772.71, -1431.11, 1.6, 48.03),
                    spawn = vec4(-729.77, -1355.49, 1.19, 142.5),
                }
            },
        },
    },
}
