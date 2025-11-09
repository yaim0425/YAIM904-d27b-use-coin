---------------------------------------------------------------------------------------------------
---[ data-final-fixes.lua ]---
---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
---[ Cargar dependencias ]---
---------------------------------------------------------------------------------------------------

local d12b = GMOD.d12b
local d13b = GMOD.d13b
if not d12b then return end

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

    --- Iniciar el MOD dependiente
    (d13b or d12b).start()

    --- Valores de la referencia
    This_MOD.reference_values()

    --- Obtener los elementos
    This_MOD.get_elements()

    -- --- Modificar los elementos
    -- for _, spaces in pairs(This_MOD.to_be_processed) do
    --     for _, space in pairs(spaces) do
    --         --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --         --- Crear los elementos
    --         This_MOD.create_item(space)
    --         This_MOD.create_tile(space)
    --         This_MOD.create_equipment(space)
    --         This_MOD.create_entity(space)
    --         This_MOD.update_recipe(space)
    --         This_MOD.update_tech(space)

    --         --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --     end
    --     for _, space in pairs(spaces) do
    --         --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --         --- Corregir resultado de combustion
    --         This_MOD.update___burnt_result(space)

    --         --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --     end
    -- end

    -- --- Fijar las posiciones actual
    -- GMOD.d00b.change_orders()

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.reference_values()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Contenedor de los elementos que el MOD modoficará
    This_MOD.to_be_processed = { items = {}, recipes = {} }

    --- Validar si se cargó antes
    if This_MOD.setting then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Valores de la referencia en todos los MODs
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Cargar la configuración
    This_MOD.setting = GMOD.setting[This_MOD.id] or {}

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

    local function validate_recipe(recipe)
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Validación
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        --- Validar el tipo
        if recipe.type ~= "recipe" then return end
        if not GMOD.has_id(recipe.name, d12b.id) then return end
        if not GMOD.has_id(recipe.name, d12b.category_do) then return end

        --- Validar contenido
        if #recipe.ingredients ~= 1 then return end
        if #recipe.results ~= 1 then return end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Obtiener la información
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local Spaces = This_MOD.to_be_processed
        local Item_do = GMOD.items[recipe.results[1].name]
        local Item_undo = GMOD.items[recipe.ingredients[1].name]

        Spaces.items[Item_undo.name] = Item_do

        for _, Recipe in pairs(GMOD.recipes[Item_undo]) do
            if not GMOD.has_id(Recipe.name, d12b.id) then
                Spaces.recipes[Recipe.name] = Recipe
            end
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Preparar los datos a usar
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for _, recipe in pairs(data.raw.recipe) do
        validate_recipe(recipe)
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

function This_MOD.create_recipe(space)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for _, recipe in pairs(GMOD.recipes[""]) do

    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

function This_MOD.create_item(space)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if not space.item then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Duplicar el elemento
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Item = GMOD.copy(space.item)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Cambiar algunas propiedades
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Nombre
    Item.name = space.name

    --- Apodo y descripción
    Item.localised_name = GMOD.copy(space.localised_name)
    Item.localised_description = GMOD.copy(space.localised_description)

    --- Agregar indicador del MOD
    Item.icons = GMOD.copy(space.item_do.icons)
    local Icon = GMOD.get_tables(Item.icons, "icon", d12b.indicator.icon)[1]
    Icon.icon = This_MOD.indicator.icon

    --- Actualizar subgroup y order
    Item.subgroup = space.item_do.subgroup
    Item.order = space.item_do.order

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---- Modificar los objetos
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if Item.place_result then
        Item.place_result = space.name
    end

    if Item.place_as_tile then
        Item.place_as_tile.result = space.name .. "-1"
    end

    if Item.place_as_equipment_result then
        Item.place_as_equipment_result = space.name
    end

    if This_MOD.effect_to_type[Item.type] then
        This_MOD.effect_to_type[Item.type](space, Item)
    end

    if Item.fuel_value then
        local Value, Unit = GMOD.number_unit(Item.fuel_value)
        Item.fuel_value = Value * space.amount .. Unit
        space.burnt_result = Item.burnt_result
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---- Eliminar el objeto anterior
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    GMOD.items[space.item_do.name] = nil
    data.raw.item[space.item_do.name] = nil

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---- Crear el prototipo
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    GMOD.extend(Item)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.create_tile(space)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if not space.tiles then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Duplicar el elemento
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for i, Tile in pairs(space.tiles) do
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Duplicar el suelo
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        Tile = GMOD.copy(Tile)

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Cambiar algunas propiedades
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        --- Nombre
        Tile.name = space.name .. "-" .. i

        --- Apodo y descripción
        Tile.localised_name = GMOD.copy(space.localised_name)
        Tile.localised_description = GMOD.copy(space.localised_description)

        --- Agregar indicador del MOD
        Tile.icons = GMOD.copy(GMOD.items[space.name].icons)

        --- Objeto a minar
        Tile.minable.results = { {
            type = "item",
            name = space.name,
            amount = 1
        } }

        --- Siguiente tile
        if Tile.next_direction then
            local Next = i + 1
            if Next > #space.tiles then
                Next = 1
            end
            Tile.next_direction = space.name .. "-" .. Next
        end

        --- Actualizar subgroup y order
        Tile.subgroup = space.item_do.subgroup
        Tile.order = space.item_do.order

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        ---- Modificar los objetos
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        if This_MOD.effect_to_type[Tile.type] then
            This_MOD.effect_to_type[Tile.type](space, Tile)
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        ---- Crear el prototipo
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        GMOD.extend(Tile)

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.create_equipment(space)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if not space.equipment then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Duplicar el elemento
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Equipment = GMOD.copy(space.equipment)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Cambiar algunas propiedades
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Nombre
    Equipment.name = space.name

    --- Apodo y descripción
    Equipment.localised_name = GMOD.copy(space.localised_name)
    Equipment.localised_description = GMOD.copy(space.localised_description)

    --- Agregar indicador del MOD
    Equipment.icons = GMOD.copy(space.item_do.icons)
    local Icon = GMOD.get_tables(Equipment.icons, "icon", d12b.indicator.icon)[1]
    Icon.icon = This_MOD.indicator.icon

    --- Actualizar subgroup y order
    Equipment.subgroup = space.item_do.subgroup
    Equipment.order = space.item_do.order

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---- Modificar los equipment
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if This_MOD.effect_to_type[Equipment.type] then
        This_MOD.effect_to_type[Equipment.type](space, Equipment)
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---- Crear el prototipo
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    GMOD.extend(Equipment)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.create_entity(space)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if not space.entity then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Duplicar el elemento
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Entity = GMOD.copy(space.entity)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Cambiar algunas propiedades
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Nombre
    Entity.name = space.name

    --- Apodo y descripción
    Entity.localised_name = GMOD.copy(space.localised_name)
    Entity.localised_description = GMOD.copy(space.localised_description)

    --- Elimnar propiedades inecesarias
    Entity.factoriopedia_simulation = nil

    --- Cambiar icono
    Entity.icons = GMOD.items[space.name].icons

    --- Actualizar el nuevo subgrupo
    Entity.subgroup = GMOD.items[space.name].subgroup

    --- Objeto a minar
    Entity.minable.results = { {
        type = "item",
        name = space.name,
        amount = 1
    } }

    --- Siguiente tier
    Entity.next_upgrade = (function(entity)
        --- Validación
        if not entity then return end

        --- Cargar el objeto de referencia
        local Item = GMOD.items[entity]
        if not Item then return end

        --- Nombre despues del aplicar el MOD
        local Name =
            GMOD.name .. (
                GMOD.get_id_and_name(space.name) or
                { ids = "-" }
            ).ids .. (
                d12b.setting.stack_size and
                Item.stack_size .. "x" .. d12b.setting.amount or
                space.amount
            ) .. "u-" .. (
                GMOD.get_id_and_name(entity) or
                { name = entity }
            ).name

        --- La entidad ya existe
        if GMOD.entities[Name] then return Name end

        --- La entidad existirá
        for _, Spaces in pairs(This_MOD.to_be_processed) do
            for _, Space in pairs(Spaces) do
                if Space.entity and Space.entity.name == entity then
                    return Name
                end
            end
        end
    end)(Entity.next_upgrade)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Aplicar el efecto apropiado
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    This_MOD.effect_to_type[Entity.type](space, Entity)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Crear el prototipo
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    GMOD.extend(Entity)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.update_recipe(space)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if not space.recipe_do then return end
    if not space.recipe_undo then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Cambiar algunas propiedades
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    space.recipe_do.results[1].name = space.name
    space.recipe_undo.ingredients[1].name = space.name

    GMOD.recipes[space.name] = GMOD.recipes[space.item_do.name]
    GMOD.recipes[space.item_do.name] = nil

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.update_tech(space)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if not space.tech then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Cambiar algunas propiedades
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    space.tech.research_trigger.item = space.name

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.update___burnt_result(space)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if not space.burnt_result then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Cambiar algunas propiedades
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Item = GMOD.items[space.name]
    for _, recipe in pairs(GMOD.recipes[Item.burnt_result]) do
        if GMOD.has_id(recipe.name, d12b.category_undo) then
            Item.burnt_result = recipe.ingredients[1].name
            break
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
---[ Iniciar el MOD ]---
---------------------------------------------------------------------------------------------------

This_MOD.start()

---------------------------------------------------------------------------------------------------
