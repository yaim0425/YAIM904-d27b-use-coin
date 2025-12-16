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

    --- Modificar los elementos
    for _, spaces in pairs(This_MOD.to_be_processed) do
        for _, space in pairs(spaces) do
            --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

            --- Crear los elementos
            This_MOD.create_item(space)
            This_MOD.create_entity(space)
            This_MOD.create_recipe(space)

            --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        end
    end

    --- Recetas de conversión
    This_MOD.get_elements_to_effect()
    This_MOD.calculate_coins()
    This_MOD.create_coins()
    This_MOD.create_recipe_to_change_coins()
    This_MOD.create_recipe_categories()

    --- Modificar los elementos
    for _, spaces in pairs(This_MOD.to_be_processed) do
        for _, space in pairs(spaces) do
            --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

            --- Crear los elementos
            This_MOD.create_recipe_to_effect(space)
            This_MOD.create_tech_to_effect(space)

            --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        end
    end

    --- Aplicar un MOD previo
    if GMOD.d01b then GMOD.d01b.start() end
    if GMOD.d18b then GMOD.d18b.start() end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.reference_values()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Contenedor de los elementos que el MOD modoficará
    This_MOD.to_be_processed = {}

    --- Maximo valor de referencia
    This_MOD.value_maximo = nil

    --- Validar si se cargó antes
    if This_MOD.setting then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Valores de la referencia en todos los MODs
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Cargar la configuración
    This_MOD.setting = GMOD.setting[This_MOD.id] or {}

    --- Indicador del mod
    This_MOD.indicator = { icon = GMOD.signal.star, scale = 0.25, shift = { 0, -5 } }
    This_MOD.indicator_bg = { icon = GMOD.signal.black, scale = 0.25, shift = { 0, -5 } }

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Valores de la referencia en todos los MODs
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Valores de referencia
    This_MOD.old_entity_name = "assembling-machine-2"
    This_MOD.new_entity_name = GMOD.name .. "-A00A-market"
    This_MOD.new_localised_name = { "", { "entity-name.market" } }

    --- Acciones
    This_MOD.actions = {
        sell = { "ingredients", "results" },
        buy = { "results", "ingredients" }
    }

    --- Receta base
    This_MOD.recipe_base = {
        type = "recipe",
        name = "",
        localised_name = {},
        localised_description = { "" },
        energy_required = 1,
        enabled = false,

        hide_from_player_crafting = true,
        hidden_in_factoriopedia = true,
        subgroup = "",
        order = "",

        ingredients = {},
        results = {}
    }

    --- Valor para objetos sin recetas
    This_MOD.value_default = 0.5

    --- Nombre de la moneda
    This_MOD.coin_name = This_MOD.prefix .. "coin"

    --- Valor minimo
    This_MOD.decimals = 4

    --- Sufijos posibles
    This_MOD.Units = "1kMGTPEZY"

    --- Elementos a ignorar
    This_MOD.ignore_items = {
        ["blueprint"] = true,
        ["blueprint-book"] = true,
        ["upgrade-planner"] = true,
        ["spidertron-remote"] = true,
        ["deconstruction-planner"] = true
    }

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
---[ Datos para el mercado ]---
---------------------------------------------------------------------------------------------------

function This_MOD.get_elements()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Función para analizar cada entidad
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local function validate_entity(item, entity)
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Validación
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        --- Validar valores de referencia
        if GMOD.entities[This_MOD.new_entity_name] then return end

        --- Validar la entity
        if not entity then return end

        --- Validar el item
        if not item then return end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Valores para el proceso
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local Space = {}
        Space.item = item
        Space.entity = entity

        Space.recipe = GMOD.recipes[Space.item.name]
        Space.recipe = Space.recipe and Space.recipe[1] or nil

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Guardar la información
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        This_MOD.to_be_processed[entity.type] = This_MOD.to_be_processed[entity.type] or {}
        This_MOD.to_be_processed[entity.type][entity.name] = Space

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Fluidos a afectar
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local function get_fluids()
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Variable a usar
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local Output = {}

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Validar el fluido
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local function validate(element)
            if element.type ~= "fluid" then return end

            local Temperatures = Output[element.name] or {}
            Output[element.name] = Temperatures

            if element.maximum_temperature then
                Temperatures[element.maximum_temperature] = true
            elseif element.temperature then
                Temperatures[element.temperature] = true
            end
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Obtener los fluidos
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        --- Todos los fluidos
        if This_MOD.setting.all then
            --- Fluidos creados con recetas
            for _, recipe in pairs(data.raw.recipe) do
                for _, elements in pairs({
                    recipe.ingredients,
                    recipe.results
                }) do
                    for _, element in pairs(elements) do
                        validate(element)
                    end
                end
            end

            --- Fluidos creados sin recetas
            for _, entity in pairs(GMOD.entities) do
                repeat
                    --- Validación
                    if not entity.output_fluid_box then break end
                    if entity.output_fluid_box.pipe_connections == 0 then break end
                    if not entity.output_fluid_box.filter then break end
                    if not entity.target_temperature then break end

                    --- Renombrar variable
                    local Name = entity.output_fluid_box.filter

                    --- Guardar la temperatura
                    local Temperatures = Output[Name] or {}
                    Output[Name] = Temperatures
                    Temperatures[entity.target_temperature] = true
                until true
            end
        end

        --- Solo los fluidos en la naturaleza
        if not This_MOD.setting.all then
            --- Fluidos tomados del suelo
            for _, tile in pairs(data.raw.tile) do
                if tile.fluid then
                    Output[tile.fluid] = {}
                end
            end

            --- Fluidos minables
            for _, resource in pairs(data.raw.resource) do
                local results = resource.minable
                results = results and results.results or {}
                for _, result in pairs(results) do
                    validate(result)
                end
            end
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Dar el formato deseado
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        for fluid_name, temperatures in pairs(Output) do
            if not GMOD.get_length(temperatures) then
                Output[fluid_name] = false
            end
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Devolver el resultado
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        return Output

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Valores a afectar
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Entidad que se va a duplicar
    validate_entity(
        GMOD.items[This_MOD.old_entity_name],
        GMOD.entities[This_MOD.old_entity_name]
    )

    --- Fluidos a afectar
    This_MOD.fluids = get_fluids()

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

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
    Item.name = This_MOD.new_entity_name

    --- Apodo
    Item.localised_name = This_MOD.new_localised_name

    --- Actualizar el order
    local Order = tonumber(Item.order) + 1
    Item.order = GMOD.pad_left_zeros(#Item.order, Order)

    --- Agregar indicador del MOD
    table.insert(Item.icons, This_MOD.indicator_bg)
    table.insert(Item.icons, This_MOD.indicator)

    --- Entidad a crear
    Item.place_result = This_MOD.new_entity_name

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---- Crear el prototipo
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    GMOD.extend(Item)

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
    Entity.name = This_MOD.new_entity_name

    --- Apodo
    Entity.localised_name = This_MOD.new_localised_name

    --- Objeto a minar
    Entity.minable.results = { {
        type = "item",
        name = This_MOD.new_entity_name,
        amount = 1
    } }

    --- Elimnar propiedades inecesarias
    Entity.fast_replaceable_group = nil
    Entity.effect_receiver = nil
    Entity.next_upgrade = nil

    --- No usa energía
    Entity.energy_source = { type = "void" }

    --- Categoria de fabricación
    Entity.crafting_categories = {}

    --- Agregar indicador del MOD
    Entity.icons = GMOD.copy(space.item.icons)
    table.insert(Entity.icons, This_MOD.indicator_bg)
    table.insert(Entity.icons, This_MOD.indicator)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Crear el prototipo
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    GMOD.extend(Entity)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.create_recipe(space)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if not space.recipe then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Duplicar el elemento
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Recipe = GMOD.copy(space.recipe)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Cambiar algunas propiedades
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Nombre
    Recipe.name = This_MOD.new_entity_name

    --- Apodo y descripción
    Recipe.localised_name = This_MOD.new_localised_name

    --- Elimnar propiedades inecesarias
    Recipe.main_product = nil

    --- Receta desbloqueada por tecnología
    Recipe.enabled = true

    --- Agregar indicador del MOD
    Recipe.icons = GMOD.copy(space.item.icons)
    table.insert(Recipe.icons, This_MOD.indicator_bg)
    table.insert(Recipe.icons, This_MOD.indicator)

    --- Ingredientes
    Recipe.ingredients = {}

    --- Resultados
    Recipe.results = { {
        type = "item",
        name = This_MOD.new_entity_name,
        amount = 1
    } }

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---- Crear el prototipo
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    GMOD.extend(Recipe)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
---[ Clase para numeros enormes ]---
---------------------------------------------------------------------------------------------------

local Math = {}

---------------------------------------------------------------------------------------------------
---[ Operaciones de la clase  ]---
---------------------------------------------------------------------------------------------------

function Math:new(num)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Contenedor de la clase
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local New_math = {}

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Copiar las funciones de la clase
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for key, value in pairs(Math) do New_math[key] = value end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Inicializar las variables de la clase
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    New_math:clear()
    New_math:set(num or 0)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Devolver la clase
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    return New_math

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function Math:clear()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if not self.value then self.value = {} end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Eliminar los valores previos
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    while #self.value > 0 do table.remove(self.value) end
    self.carry = nil

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function Math:validate()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validar el formato
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if type(self.value) ~= "table" then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validar cada valor
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Index = 1

    while Index <= #self.value do
        local Value = self.value[Index]
        if Index == 2 then
            if Value ~= "." then break end
        else
            if type(Value) ~= "number" then break end
            if Value < 0 then break end
            if Index == 1 and Value > 10 ^ This_MOD.decimals then break end
            if Index ~= 1 and Value > 1000 then break end
        end
        Index = Index + 1
    end

    if Index <= #self.value then self:clear() end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Devolver el resultado
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    return Index > #self.value

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function Math:copy()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local New_math = self:new()
    New_math:set(self)
    return New_math

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function Math:finish()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if not self:validate() then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Eliminar los ceros innecesarios
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Num = GMOD.copy(self.value)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Si el entero es mayor a 0, eliminar decimal
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if #self.value > 3 or self.value[3] > 0 then
        table.remove(Num, 1)
        table.remove(Num, 1)

        for key, value in pairs(Num) do
            if value == 0 then
                Num[key] = nil
            end
        end

        return Num
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Entero = 0 y decimal > 0 → dejar solo {"1"}
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if self.value[1] > 0 then return { 1 } end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Valor por defecto
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    return { 0 }

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------
---[ Operaciones matemáticas  ]---
---------------------------------------------------------------------------------------------------

function Math:set(num)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    self:clear()

    if type(num) == "table" then
        if not num:validate() then return end
        for _, value in pairs(num.value) do
            table.insert(self.value, value)
        end
        return GMOD.copy(self.value)
    end

    if type(num) ~= "number" then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Variables a usar
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Num_str = tostring(num)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Separar decimal
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Buscar el punto decimal
    local Dot = Num_str:find("%.")

    --- Hay un decimal
    if Dot then
        local Decimal = Num_str:sub(Dot + 1)

        if #Decimal > This_MOD.decimals then
            Decimal = Decimal:sub(1, This_MOD.decimals)
        end

        while #Decimal < This_MOD.decimals do
            Decimal = Decimal .. "0"
        end

        Num_str = Num_str:sub(1, Dot - 1)
        Dot = tonumber(Decimal)
    end

    --- Agregar el decimal a la tabla
    table.insert(self.value, Dot or 0)
    table.insert(self.value, ".")

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Separar entero
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for i = #Num_str, 1, -3 do
        local Num = Num_str:sub(math.max(1, i - 2), i)
        table.insert(self.value, tonumber(Num))
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Devolver el resultado
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    return GMOD.copy(self.value)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function Math:add(num)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if type(num) == "number" then
        local TMP = self:new()
        TMP:set(num)
        num = TMP
    end
    if type(num) ~= "table" then return end
    if not num:validate() then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Sumar cada bloque
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Carry = 0

    for i = 1, math.max(#self.value, #num.value), 1 do
        if i ~= 2 then
            local Base = i == 1 and 10 ^ This_MOD.decimals or 1000
            local A = self.value[i] or 0
            local B = num.value[i] or 0
            self.value[i] = A + B + Carry
            Carry = math.floor(self.value[i] / Base)
            self.value[i] = self.value[i] % Base
        end
    end

    if Carry > 0 then table.insert(self.value, Carry) end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Devolver el resultado
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    return GMOD.copy(self.value)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function Math:mult(num)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if type(num) ~= "number" then return end
    if not self:validate() then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Multiplicar cada bloque
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Carry = 0

    for i = 1, #self.value do
        if i ~= 2 then
            local Base = i == 1 and 10 ^ This_MOD.decimals or 1000
            self.value[i] = self.value[i] * num + Carry
            Carry = math.floor(self.value[i] / Base)
            self.value[i] = self.value[i] % Base
        end
    end

    if Carry > 0 then table.insert(self.value, Carry) end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Devolver el resultado
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    return GMOD.copy(self.value)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function Math:div(num)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if type(num) ~= "number" then return end
    if not self:validate() then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Dividir cada bloque
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    self.carry = 0

    for i = #self.value, 1, -1 do
        if i ~= 2 then
            local Base = i == 1 and 10 ^ This_MOD.decimals or 1000
            self.value[i] = self.carry * Base + self.value[i]
            self.carry = self.value[i] % num
            self.value[i] = math.floor(self.value[i] / num)
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Limpiar el resultado
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    while #self.value > 1 do
        local Last = self.value[#self.value]
        if Last == "." then break end
        if Last > 0 then break end
        table.remove(self.value, #self.value)
    end

    if self.value[#self.value] == "." then
        table.insert(self.value, 0)
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Devolver el resultado
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    return GMOD.copy(self.value), self.carry

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function Math:greater_than(num)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if type(num) == "number" then
        local TMP = self:new()
        TMP:set(num)
        num = TMP
    end
    if type(num) ~= "table" then return end
    if not num:validate() then return end
    if not self:validate() then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Comparar la longitud
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if #num.value > #self.value then return false end
    if #num.value < #self.value then return true end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Comparar cada bloque
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Return = false

    for i = 1, math.max(#self.value, #num.value), 1 do
        if i ~= 2 then
            local A = num[i] or 0
            local B = self.value[i] or 0
            if A > B then break end
            if A < B then
                Return = true
                break
            end
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Devolver el resultado
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    return Return

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
---[ Cambios del MOD ]---
---------------------------------------------------------------------------------------------------

function This_MOD.get_elements_to_effect()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Variables a usar
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    This_MOD.to_be_processed = {}

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Evaluar cada element
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local function get_elements(element)
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Validación
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        --- Elementos a ignorar
        if GMOD.has_id(element.name, "A00A") then return end
        if This_MOD.ignore_items[element.name] then return end
        if element.type ~= "fluid" and not element.subgroup then return end

        --- Validar si ya fue procesado
        local That_MOD =
            GMOD.get_id_and_name(element.name) or
            { ids = "-", name = element.name }

        local Effects = {}
        for action, _ in pairs(This_MOD.actions) do
            local Recipe_name =
                GMOD.name .. That_MOD.ids ..
                This_MOD.id .. "-" ..
                action .. "-" ..
                That_MOD.name

            table.insert(Effects, {
                type = "unlock-recipe",
                recipe = Recipe_name
            })

            if data.raw.recipe[Recipe_name] then return end
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Guardar la información
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local Space = {}
        Space.name =
            GMOD.name .. That_MOD.ids ..
            This_MOD.id .. "-" ..
            That_MOD.name

        Space.element = element
        Space.type = element.type == "fluid" and "fluid" or "item"

        Space.effects = Effects
        Space.sell = Effects[1].recipe
        Space.buy = Effects[2].recipe

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Guardar la información
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        This_MOD.to_be_processed[element.type] = This_MOD.to_be_processed[element.type] or {}
        This_MOD.to_be_processed[element.type][element.name] = Space

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Buscar los elements a afectar
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for _, recipe in pairs(data.raw.recipe) do
        repeat
            if not recipe.ingredients then break end
            if #recipe.ingredients > 0 then break end

            if not recipe.results then break end
            if #recipe.results ~= 1 then break end

            if recipe.results[1].type ~= "item" then break end

            This_MOD.ignore_items[recipe.results[1].name] = true
        until true
    end

    for _, elements in pairs({ GMOD.items, GMOD.fluids }) do
        for _, element in pairs(elements) do
            get_elements(element)
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.calculate_coins()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Variables a usar
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local List = {}    --- Lista de item/fluid base para calcular
    local Levels = {}  --- Recetas clasificadas por niveles
    local Recipes = {} --- Listado de todas las recetas a ordernar

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Elementos del nivel cero
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local function get_fluids()
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Variable de salida
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local Return = {}

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Validar el fluido
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local function validate(element)
            if element.type ~= "fluid" then return end

            local Temperatures = Return[element.name] or {}
            Return[element.name] = Temperatures

            if element.maximum_temperature then
                Temperatures[element.maximum_temperature] = true
            elseif element.temperature then
                Temperatures[element.temperature] = true
            end
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Obtener los fluidos
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        --- Fluidos tomados del suelo
        for _, tile in pairs(data.raw.tile) do
            if tile.fluid then
                Return[tile.fluid] = {}
            end
        end

        --- Fluidos minables
        for _, resource in pairs(data.raw.resource) do
            if resource.minable then
                for _, result in pairs(resource.minable.results or {}) do
                    validate(result)
                end
            end
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Dar el formato deseado
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        for name, temperatures in pairs(Return) do
            List[name] = {
                name = nil,
                level = 1,
                recipe = nil,
                results = { { name = name } },
                ingredients = nil,
                value = Math:new(0),
            }

            if GMOD.get_length(temperatures) then
                Levels[1][name] = Levels[1][name] or {}
                for temperature, _ in pairs(temperatures) do
                    local Name = name .. "|" .. temperature
                    Levels[1][Name] = { results = { { name = name, temperature = temperature } } }
                    List[Name] = {
                        name = nil,
                        level = 1,
                        recipe = nil,
                        results = { { name = name, temperature = temperature } },
                        ingredients = nil,
                        value = Math:new(0),
                    }
                    List[Name] = 1
                end
            end
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    local function get_resource()
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Objectos minables
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        for _, element in pairs(data.raw.resource) do
            if element.minable then
                for _, result in pairs(element.minable.results or {}) do
                    repeat
                        if result.type ~= "item" then break end
                        if not GMOD.items[result.name] then break end
                        Levels[1][result.name] = { results = { { name = result.name } } }
                        List[result.name] = {
                            name = nil,
                            level = 1,
                            recipe = nil,
                            results = { { name = result.name } },
                            ingredients = nil,
                            value = Math:new(0),
                        }
                    until true
                end
            end
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    local function get_fluid_producers()
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        for _, groups in pairs(data.raw) do
            for _, entity in pairs(groups) do
                repeat
                    --- Validación
                    if not entity.output_fluid_box then break end
                    if entity.output_fluid_box.pipe_connections == 0 then break end
                    if not entity.output_fluid_box.filter then break end

                    if not entity.fluid_box then break end
                    if entity.fluid_box.pipe_connections == 0 then break end
                    if not entity.fluid_box.filter then break end

                    --- Renombrar variable
                    local Output = entity.output_fluid_box.filter
                    local Input = entity.fluid_box.filter
                    local Temperature = entity.target_temperature or entity.output_fluid_box.temperature

                    if Temperature and Temperature == data.raw.fluid[Output].default_temperature then
                        Temperature = nil
                    end

                    --- Guardar la temperatura
                    Recipes[entity.name] = {
                        ignored = true,
                        ingredients = { { type = "fluid", name = Input } },
                        results = { { type = "fluid", name = Output, temperature = Temperature } }
                    }
                until true
            end
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    local function get_environment_items()
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Tipos a buscar
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local Allowed_types = {
            ["tree"] = true,
            ["simple-entity"] = true,
            ["simple-entity-with-force"] = true,
            ["simple-entity-with-owner"] = true,
            ["resource"] = true,
            ["fish"] = true,
        }

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Buscar los objetos
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        for type, _ in pairs(Allowed_types) do
            for _, prototype in pairs(data.raw[type] or {}) do
                local Minable = prototype.minable
                if Minable then
                    local Results = Minable.results
                    if Minable.result then
                        Results = { { name = Minable.result } }
                    end

                    for _, result in pairs(Results or {}) do
                        Levels[1][result.name] = { results = { { name = result.name } } }
                        List[result.name] = {
                            name = nil,
                            level = 1,
                            recipe = nil,
                            results = { { name = result.name } },
                            ingredients = nil,
                            value = Math:new(0),
                        }
                    end
                end
            end
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    local function get_items_without_recipes()
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Variables a usar
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local Items = {}

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Cargar los objetos existentes
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        for _, elements in pairs(data.raw) do
            for _, element in pairs(elements) do
                if element.stack_size then
                    Items[element.name] = true
                end
            end
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Eliminar los objetos con recetas
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        for _, recipe in pairs(data.raw.recipe) do
            --- Eliminar objetos con recetas
            for _, result in pairs(recipe.results or {}) do
                if result.type == "item" then
                    Items[result.name] = nil
                end
            end

            --- Enlistar las recetas
            if
                (recipe.ingredients and recipe.results) and
                (#recipe.ingredients > 0 or #recipe.results > 0)
            then
                Recipes[recipe.name] = recipe
            end
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Guardar el resultado
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        for name, _ in pairs(Items) do
            Levels[1][name] = { results = { { name = name } } }
            List[name] = {
                name = nil,
                level = 1,
                recipe = nil,
                results = { { name = name } },
                ingredients = nil,
                value = Math:new(0),
            }
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local function validate_ingredients(ingredients)
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        for _, ingredient in pairs(ingredients or {}) do
            local Name = ingredient.name

            if ingredient.temperature then
                Name = Name .. "|" .. ingredient.temperature
            end

            if not List[Name] then
                return
            end
        end

        return true

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    local function calculate_coins()
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Procesar las recetas
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        while GMOD.get_length(Recipes) do
            --- Recorrer las recetas
            while GMOD.get_length(Recipes) do
                local Level = {}
                table.insert(Levels, Level)

                for key, Recipe in pairs(Recipes) do
                    if validate_ingredients(Recipe.ingredients) then
                        for _, result in pairs(Recipe.results or {}) do
                            if not result.amount or result.amount > 0 then
                                local Names = { result.name }

                                local Temperature = result.maximum_temperature or result.temperature
                                if Temperature then table.insert(Names, result.name .. "|" .. Temperature) end

                                for _, Name in pairs(Names) do
                                    if not List[Name] then
                                        List[Name] = {
                                            name = Recipe.name,
                                            level = #Levels,
                                            ignored = Recipe.ignored,

                                            recipe = Recipe,
                                            results = Recipe.results,
                                            ingredients = Recipe.ingredients,

                                            value = Math:new(Recipe.energy_required or 0.5)
                                        }
                                    end
                                end
                            end

                            Recipes[key] = nil
                            if not Recipe.ignored then
                                Level[Recipe.name] = Recipe
                            end
                        end
                    end
                end

                if not GMOD.get_length(Level) then
                    table.remove(Levels, #Levels)
                    break
                end
            end

            --- Procesar las recetas sin evaluar
            local Values = {}
            for _, Recipe in pairs(Recipes) do
                Values[Recipe.name] = Values[Recipe.name] or {}
                for _, ingredient in pairs(Recipe.ingredients) do
                    local Name = ingredient.name
                    if ingredient.temperature then
                        Name = Name .. "|" .. ingredient.temperature
                    end
                    table.insert(Values[Recipe.name], (List[Name] or {}).level or 1)
                end
                Values[Recipe.name] = (function()
                    local Max = 0
                    for _, Value in pairs(Values[Recipe.name]) do
                        if Value > Max then
                            Max = Value
                        end
                    end
                    return Max
                end)()
            end

            --- Buscar el nivel más bajo
            local Min = math.huge
            for _, Value in pairs(Values) do
                if Value < Min then
                    Min = Value
                end
            end

            --- Agregar la receta al nivel
            for name, Value in pairs(Values) do
                if Value == Min then
                    for _, result in pairs(Recipes[name].results) do
                        local Recipe = Recipes[name]
                        if not result.amount or result.amount > 0 then
                            local Names = { result.name }

                            local Temperature = result.maximum_temperature or result.temperature
                            if Temperature then table.insert(Names, result.name .. "|" .. Temperature) end

                            for _, Name in pairs(Names) do
                                if not List[Name] then
                                    List[Name] = {
                                        name = Recipe.name,
                                        level = Min + 1,
                                        ignored = Recipe.ignored,

                                        recipe = Recipe,
                                        results = Recipe.results,
                                        ingredients = result.ingredients,

                                        value = Math:new(Recipe.energy_required or 0.5)
                                    }
                                end
                            end
                        end

                        if not Levels[Min + 1] then Levels[Min + 1] = {} end
                        Levels[Min + 1][Recipe.name] = Recipe
                    end
                    Recipes[name] = nil
                end
            end
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Crear el oreden para calcular el valor
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        Levels = {}
        for _, value in pairs(List) do
            Levels[value.level] = Levels[value.level] or {}
            table.insert(Levels[value.level], value)
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Calcular los valores
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        --- Calcular el valor de las recetas
        for _, Level in pairs(Levels) do
            for _, Element in pairs(Level) do
                for _, ingredient in pairs(Element.ingredients or {}) do
                    local Value = List[ingredient.name]
                    if Value then
                        Value = Value.value:copy()
                        Value:mult(ingredient.amount)
                        Element.value:add(Value)
                    end
                end
                Element.ingredients = nil
            end
        end

        --- Calcular el valor de cada item/fluid
        for key, Element in pairs(List) do
            repeat
                --- Eliminar el nuvel 1
                if Element.level == 1 then
                    List[key] = nil
                    break
                end

                --- Calcular valor por unidad
                List[key] = Element.value:copy()
                for _, Result in pairs(Element.results) do
                    if Result.name == key and Result.amount then
                        List[key]:div(Result.amount)
                    end
                end

                --- Eliminar los valores cero
                if
                    #List[key].value == 3 and
                    List[key].value[1] == 0 and
                    List[key].value[3] == 0
                then
                    List[key] = nil
                    break
                end
            until true
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Valores a afectar
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Inicializar los contenedores
    Levels = { [1] = {} }

    --- Elementos del nivel cero
    get_fluids()
    get_resource()
    get_fluid_producers()
    get_environment_items()
    get_items_without_recipes()

    calculate_coins()

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Calcular el valor de los afectados
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for _, spaces in pairs(This_MOD.to_be_processed) do
        for _, space in pairs(spaces) do
            --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

            --- Valor del elemento
            local Value = List[space.element.name]
            if Value then
                --- Convertir el valor en monedas
                space.coins = {}
                for action, value in pairs(This_MOD.actions) do
                    --- Contenedor de salida
                    space.coins[action] = {}

                    --- Convertir en el formato
                    local Coins = Value:copy()
                    if This_MOD.actions.sell == value then Coins:div(2) end
                    for i, num in pairs(Coins:finish()) do
                        if num >= 0 then
                            table.insert(space.coins[action], {
                                type = "item",
                                amount = num,
                                name = This_MOD.coin_name .. "-" .. i,
                                ignored_by_productivity = 0,
                                ignored_by_stats = num
                            })
                        end
                    end

                    --- Eliminar contenedor vacio
                    if #space.coins[action] == 0 then
                        space.coins[action] = nil
                    end
                end

                --- Eliminar contenedor vacio
                if not GMOD.get_length(space.coins) then
                    space.coins = nil
                end

                --- Guardar el maximo valor a usar
                if not This_MOD.value_maximo then
                    This_MOD.value_maximo = Math:new(0)
                end

                --- Referencia del numero más grande
                if Value:greater_than(This_MOD.value_maximo) then
                    This_MOD.value_maximo = Value
                end
            end

            --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.create_coins()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if not This_MOD.value_maximo then return end
    This_MOD.value_maximo.coins = This_MOD.value_maximo:finish()
    for i = 1, #This_MOD.value_maximo.coins, 1 do
        if not GMOD.items[This_MOD.coin_name .. "-" .. i] then
            --- Prefijo
            local Char = i > #This_MOD.Units and tostring(i) or This_MOD.Units:sub(i, i)

            --- item
            local Coin = {
                type = "item",
                name = This_MOD.coin_name .. "-" .. i,
                localised_name = { "", { "item-name.coin" } },
                subgroup = "intermediate-product",
                order = "z[" .. GMOD.pad_left_zeros(2, i) .. "]",
                stack_size = 1000
            }

            --- Icon
            Coin.icons = (function()
                --- Contenedor de salida
                local Icons = {}

                --- Imagen de la moneda
                table.insert(Icons, {
                    icon = "__base__/graphics/icons/coin.png",
                    icon_size = 64
                })

                --- Agregar el prefijo
                if i <= #This_MOD.Units then
                    table.insert(Icons, {
                        icon = GMOD.signal[string.upper(Char)],
                        shift = { 8, -8 },
                        scale = 0.25
                    })

                    --- Devolver el resultado
                    return Icons
                end

                --- Agregar los numeros
                table.insert(Icons, {
                    icon = GMOD.signal[Char:sub(1, 1)],
                    shift = { -8, -8 },
                    scale = 0.25
                })
                table.insert(Icons, {
                    icon = GMOD.signal[Char:sub(2, 2)],
                    shift = { 8, -8 },
                    scale = 0.25
                })

                --- Devolver el resultado
                return Icons
            end)()

            --- Crear prototipo
            GMOD.extend(Coin)
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.create_recipe_to_change_coins()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if not This_MOD.value_maximo then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Recetas para intercambiar las monedas
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local function recipes_to_coins(space)
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Crear una copia
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local Recipe = GMOD.copy(This_MOD.recipe_base)

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Actualizar algunas propiedades
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local That_MOD =
            GMOD.get_id_and_name(This_MOD.coin_name) or
            { ids = "-", name = This_MOD.coin_name }

        local Name =
            GMOD.name .. That_MOD.ids ..
            space.action .. "-" ..
            That_MOD.name .. "-" ..
            space.char_up

        if data.raw.recipe[Name] then return end

        Recipe.name = Name
        Recipe.localised_name = { "", { "item-name.coin" } }
        Recipe.category = This_MOD.prefix .. space.action
        Recipe.subgroup = "intermediate-product"
        Recipe.order = "z[" .. space.order .. "]"
        Recipe.enabled = true

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Ingredientes y resultados
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        Recipe[space.value[1]] = { {
            type = "item",
            amount = 1,
            name = This_MOD.coin_name .. "-" .. space.char_up,
            ignored_by_productivity = 0,
            ignored_by_stats = 1
        } }

        Recipe[space.value[2]] = { {
            type = "item",
            amount = 1000,
            name = This_MOD.coin_name .. "-" .. space.char_down,
            ignored_by_productivity = 0,
            ignored_by_stats = 1000
        } }

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Crear el prototipo
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        GMOD.extend(Recipe)

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Recorrer las monedas necesarias
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for N = 2, #This_MOD.value_maximo.coins, 1 do
        for action, value in pairs(This_MOD.actions) do
            recipes_to_coins({
                order = GMOD.pad_left_zeros(3, N) .. (value == This_MOD.actions.sell and 0 or 1),
                value = value,
                action = action,
                char_up = N,
                char_down = N - 1
            })
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.create_recipe_categories()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Category = GMOD.entities[This_MOD.new_entity_name].crafting_categories
    for action, _ in pairs(This_MOD.actions) do
        local Name = This_MOD.prefix .. action
        if GMOD.get_key(Category, Name) then return end
        GMOD.extend({ type = "recipe-category", name = Name })
        table.insert(Category, Name)
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.create_recipe_to_effect(space)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if not space.coins then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Crear la recipe
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local function create_recipe(action, value)
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Validación
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        if not space.coins[action] then return end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Crear la receta
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local Recipe = GMOD.copy(This_MOD.recipe_base)

        Recipe.name = space[action]
        Recipe.energy_required = 0.002
        Recipe.order = space.element.order
        Recipe.category = This_MOD.prefix .. action
        Recipe.localised_name = space.element.localised_name
        Recipe.icons = GMOD.copy(space.element.icons)

        if value == This_MOD.actions.sell then
            Recipe.localised_name = { "item-name.coin" }
            table.insert(Recipe.icons, {
                icon = GMOD.items[This_MOD.coin_name .. "-1"].icons[1].icon,
                scale =
                    (GMOD.d01b and GMOD.has_id(space.element.name, GMOD.d01b.id)) and
                    0.35 or 0.25,
                icon_size = 64,
                shift = { 14, 14 }
            })
        end

        Recipe.subgroup =
            This_MOD.prefix ..
            space.element.subgroup .. "-" ..
            action

        Recipe[value[1]] = { {
            type = space.type,
            amount = 1,
            name = space.element.name,
            ignored_by_productivity = 0,
            ignored_by_stats = 1
        } }

        Recipe[value[2]] = space.coins[action]

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Crear el subgrupo para el objeto
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        --- Duplicar el subgrupo
        if not GMOD.subgroups[Recipe.subgroup] then
            GMOD.duplicate_subgroup(space.element.subgroup, Recipe.subgroup)

            --- Renombrar
            local Subgroup = GMOD.subgroups[Recipe.subgroup]
            local Order = GMOD.subgroups[space.element.subgroup].order
            local Index = value == This_MOD.actions.buy and 6 or 7

            --- Actualizar el order
            Subgroup.order = Index .. Order:sub(2)
        end
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Crear el prototipo
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        GMOD.extend(Recipe)

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Crear las recipes
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for action, value in pairs(This_MOD.actions) do
        create_recipe(action, value)
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.create_tech_to_effect(space)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if not space.coins then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Cambiar algunas propiedades
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Tipo y nombre
    local Tech = {}
    Tech.type = "technology"
    Tech.name = space.name .. "-tech"

    --- Apodo y descripción
    Tech.localised_name = space.element.localised_name
    Tech.localised_description = { "" }

    --- Duplicar la imagen
    Tech.icons = GMOD.copy(data.raw.recipe[space.sell].icons)
    for _, icon in pairs(Tech.icons) do
        icon.icon_size = icon.icon_size or 64
        icon.scale = icon.scale or 0.5
    end

    --- Ocultar las recetas
    Tech.hidden = true

    --- Efecto de la tech
    Tech.effects = space.effects

    --- Tech se activa con una fabricación
    Tech.research_trigger = {
        type = "craft-" .. space.type,
        [space.type] = space.element.name,
        count = 1
    }

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Crear el prototipo
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    GMOD.extend(Tech)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
---[ Iniciar el MOD ]---
---------------------------------------------------------------------------------------------------

This_MOD.start()

---------------------------------------------------------------------------------------------------
