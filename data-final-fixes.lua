---------------------------------------------------------------------------------------------------
---[ data-final-fixes.lua ]---
---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
---[ Información del MOD ]---
---------------------------------------------------------------------------------------------------

local This_MOD = GMOD.get_id_and_name()
if not This_MOD then return end
GMOD[This_MOD.id] = This_MOD

---------------------------------------------------------------------------------------------------

function This_MOD.start()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Valores de la referencia
    This_MOD.reference_values()

    --- Obtener los elementos
    This_MOD.get_elements()

    -- --- Modificar los elementos
    -- for _, spaces in pairs(This_MOD.to_be_processed) do
    --     for _, space in pairs(spaces) do
    --         --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --         -- --- Crear los elementos
    --         This_MOD.create_item(space)
    --         This_MOD.create_recipe(space)
    --         This_MOD.create_tech(space)

    --         --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --     end
    -- end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.reference_values()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Contenedor de los elementos que el MOD modoficará
    This_MOD.to_be_processed = {}

    --- Validar si se cargó antes
    if This_MOD.setting then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Valores de la referencia en todos los MODs
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Cargar la configuración
    This_MOD.setting = GMOD.setting[This_MOD.id] or {}

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Valores de la referencia en todos los MODs
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Valor para objetos sin recetas
    This_MOD.value_default = 0

    --- Nombre de la moneda
    This_MOD.coin_name = This_MOD.prefix .. "coin"

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
---[ Cambios del MOD ]---
---------------------------------------------------------------------------------------------------

function This_MOD.get_elements()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Función para analizar cada entidad
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local function validate_item(item)
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Validación
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        --- Validar si ya fue procesado
        local That_MOD =
            GMOD.get_id_and_name(item.name) or
            { ids = "-", name = item.name }

        --- Validar si ya fue procesado
        local Name =
            GMOD.name .. That_MOD.ids ..
            This_MOD.id .. "-" .. That_MOD.name

        if data.raw.recipe[Name] then return end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Guardar la información
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local Space = {}

        Space.name = Name

        Space.item = item
        Space.recipe = GMOD.recipes[item.name]

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Guardar la información
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        This_MOD.to_be_processed[item.type] = This_MOD.to_be_processed[item.type] or {}
        This_MOD.to_be_processed[item.type][item.name] = Space

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Preparar los datos a usar
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for _, item in pairs(GMOD.items) do
        validate_item(item)
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------

function This_MOD.create_item(space)
    local function create_coin()
        if GMOD.items[This_MOD.coin_name] then return end

        GMOD.extend({
            type = "item",
            name = This_MOD.coin_name,
            localised_name = { "localised_name.coin" },
            icons = { {
                icon = "__base__/graphics/icons/coin.png",
                icon_size = 64
            } },
            subgroup = "intermediate-product",
            order = "z[coin]",
            stack_size = 100000
        })
    end

    create_coin()
end

function This_MOD.create_recipe(space)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Actializar la propiedad indicada
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local function update_propiety(element, propiety)
        if not element[propiety] then return end
        element[propiety] = d12b.setting.amount * element[propiety]
        if element[propiety] > 65000 then
            element[propiety] = 65000
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Duplicar la receta
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for name, recipe in pairs(space.recipes) do
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Duplicar la receta
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local Recipe = GMOD.copy(recipe)

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Cambiar algunas propiedades
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        --- Actializar el nombre
        Recipe.name = name

        --- Actializar main_product
        if Recipe.main_product and space.items[Recipe.main_product] then
            Recipe.main_product = space.items[Recipe.main_product].name
        end

        --- Actializar los ingredientes y los resultados
        for _, elements in pairs({ Recipe.ingredients, Recipe.results }) do
            for _, element in pairs(elements) do
                local Item = space.items[element.name]
                local Type = element.type

                if Type == "fluid" or (Type == "item" and not Item) then
                    update_propiety(element, "amount")
                    update_propiety(element, "amount_min")
                    update_propiety(element, "amount_max")
                elseif Type == "item" and Item then
                    element.name = Item.name
                end
            end
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Actializar el subgroup
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        repeat
            --- Validación
            if not Recipe.subgroup then break end
            if not Recipe.results then break end
            if #Recipe.results == 0 then break end
            if Recipe.results[1].type ~= "item" then break end
            local Item = GMOD.items[Recipe.results[1].name]
            if not Item then break end

            --- Igualar subgrupo
            Recipe.subgroup = Item.subgroup

            --- Igualar la imagen
            Recipe.icons = Item.icons
        until true

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Crear el prototipo
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        GMOD.extend(Recipe)

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.m()
    local coin_name = "coin"

    -- Asegura que el objeto "coin" exista
    data:extend({
        {
            type = "item",
            name = coin_name,
            icons = { {
                icon = "__base__/graphics/icons/coin.png",
                icon_size = 64
            } },
            subgroup = "intermediate-product",
            order = "z[coin]",
            stack_size = 100000
        }
    })

    -- ==========================================
    -- 🔁 Cálculo recursivo de valores de objetos
    -- ==========================================
    local values = {}
    local cache = {}

    --- Obtener valor de un ítem (recursivo)
    --- @param name string
    --- @return number
    local function get_value(name)
        -- Valor ya calculado
        if values[name] then return values[name] end
        -- Evitar bucles
        if cache[name] then return 1 end
        cache[name] = true

        -- Buscar recetas que produzcan este objeto
        local matching_recipes = {}
        for _, recipe in pairs(data.raw.recipe) do
            for _, res in pairs(recipe.results or {}) do
                if res.name == name then
                    table.insert(matching_recipes, recipe)
                    break
                end
            end
        end

        -- Sin receta → valor base 1
        if #matching_recipes == 0 then
            cache[name] = nil
            values[name] = 1
            return 1
        end

        -- Calcular valor mínimo entre todas las recetas posibles
        local min_value = math.huge
        for _, recipe in pairs(matching_recipes) do
            local energy = recipe.energy_required or 0.5
            local ingredients = recipe.ingredients or {}
            local total = energy

            -- Calcular costo de los ingredientes
            for _, ing in pairs(ingredients) do
                local ing_name = ing.name or ing[1]
                local ing_amount = ing.amount or ing[2] or 1
                total = total + get_value(ing_name) * ing_amount
            end

            -- Determinar cantidad de resultados
            local results = recipe.results
            local total_results = 0
            if results then
                for _, res in pairs(results) do
                    total_results = total_results + (res.amount or 1)
                end
            elseif recipe.result then
                total_results = recipe.result_count or 1
            end

            if total_results > 0 then
                total = total / total_results
            end

            if total < min_value then
                min_value = total
            end
        end

        cache[name] = nil
        values[name] = min_value
        return min_value
    end

    -- ================================
    -- 💰 Generar recetas de conversión
    -- ================================
    local coin_recipes = {}
    for _, item in pairs(data.raw.item) do
        local val = get_value(item.name)
        table.insert(coin_recipes, {
            type = "recipe",
            name = "convert-" .. item.name .. "-to-" .. coin_name,
            category = "crafting",
            energy_required = 0.5,
            enabled = true,
            ingredients = { { item.name, 1 } },
            results = { { coin_name, math.max(1, math.floor(val)) } },
            localised_name = { "", { "recipe-name.convert-to-coin" }, " (", item.localised_name or item.name, ")" }
        })
    end

    data:extend(coin_recipes)

    log("💰 Coin conversion recipes generated: " .. tostring(#coin_recipes))
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
---[ Iniciar el MOD ]---
---------------------------------------------------------------------------------------------------

This_MOD.start()

---------------------------------------------------------------------------------------------------
