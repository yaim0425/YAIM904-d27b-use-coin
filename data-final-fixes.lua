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
            --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

            --- Crear los elementos
            This_MOD.create_item(space)
            This_MOD.create_entity(space)
            This_MOD.create_recipe(space)

            --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        end
    end

    --- Recetas de conversión
    This_MOD.get_elements_to_effect()
    This_MOD.calculate_prices()
    This_MOD.create_coins()
    This_MOD.create_recipe_to_change_coins()
    This_MOD.add_category()

    --- Modificar los elementos
    This_MOD.create_spaces()
    for _, spaces in pairs(This_MOD.to_be_processed.spaces) do
        for _, space in pairs(spaces) do
            --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

            --- Crear los elementos
            This_MOD.create_recipe_to_elements(space)
            This_MOD.create_tech_to_element(space)

            --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
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
    This_MOD.maximo = nil

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
        enabled = not This_MOD.setting.tech,

        hide_from_player_crafting = true,
        hidden_in_factoriopedia = true,
        subgroup = "",
        order = "",

        ingredients = {},
        results = {}
    }

    --- Nombre de la moneda
    This_MOD.coin_name = This_MOD.prefix .. "coin"

    --- Valor minimo
    This_MOD.decimals = 4

    --- Sufijos posibles
    This_MOD.Units = "1kMGTPEZY"

    --- Elementos a ignorar
    This_MOD.ignore_recipes = {
        ["YAIM904-A00A-market"] = true
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
        if GMOD.entity[This_MOD.new_entity_name] then return end

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

        for key, value in pairs(Space) do
            Space[key] = GMOD.copy_with_format(value)
        end

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
    --- Valores a afectar
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Entidad que se va a duplicar
    validate_entity(
        GMOD.item[This_MOD.old_entity_name],
        GMOD.entity[This_MOD.old_entity_name]
    )

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
    Item.order = Item.order .. "-05"

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
    Entity.minable.results[1].name = This_MOD.new_entity_name

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
    Recipe.results[1].name = This_MOD.new_entity_name

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
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

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
    if #Num == 0 then return {} end

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
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if type(num) ~= "number" then return end
    if not self:validate() then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Multiplicar cada bloque
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

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

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Devolver el resultado
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    return GMOD.copy(self.value)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function Math:div(num)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if type(num) ~= "number" then return end
    if not self:validate() then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Dividir cada bloque
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    self.carry = 0

    for i = #self.value, 1, -1 do
        if i ~= 2 then
            local Base = i == 1 and 10 ^ This_MOD.decimals or 1000
            self.value[i] = self.carry * Base + self.value[i]
            self.carry = self.value[i] % num
            self.value[i] = math.floor(self.value[i] / num)
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Limpiar el resultado
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    while #self.value > 1 do
        local Last = self.value[#self.value]
        if Last == "." then break end
        if Last > 0 then break end
        table.remove(self.value, #self.value)
    end

    if self.value[#self.value] == "." then
        table.insert(self.value, 0)
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Devolver el resultado
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    return GMOD.copy(self.value), self.carry

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function Math:greater_than(num)
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
    if not self:validate() then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Comparar la longitud
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if #num.value > #self.value then return false end
    if #num.value < #self.value then return true end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Comparar cada bloque
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

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

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Devolver el resultado
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    return Return

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
---[ Cambios del MOD ]---
---------------------------------------------------------------------------------------------------

function This_MOD.get_elements_to_effect()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Funciones auxiliares
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local function get_items()
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Variable a usar
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local Output = {}

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Objectos minables
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        for _, resource in pairs(data.raw.resource) do
            local mining_time = resource.minable.mining_time
            resource = GMOD.get_format_minable(resource or {})
            for _, result in pairs(resource or {}) do
                repeat
                    if result.type ~= "item" then break end
                    local Item = GMOD.item[result.name]
                    if not Item then break end
                    local energy_required = Output[result.name]
                    if
                        not energy_required or
                        (energy_required and energy_required < mining_time)
                    then
                        Output[result.name] = mining_time
                    end
                until true
            end
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Devolver el resultado
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        return Output

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    local function get_fluids()
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Variable a usar
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local Output = {}

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Obtener los fluidos
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        --- Fluidos tomados del suelo
        for _, tile in pairs(data.raw.tile) do
            if tile.fluid then
                Output[tile.fluid] = Output[tile.fluid] or 1
            end
        end

        --- Fluidos minables
        for _, resource in pairs(data.raw.resource) do
            local mining_time = resource.minable.mining_time
            resource = GMOD.get_format_minable(resource or {})
            for _, result in pairs(resource or {}) do
                if result.type == "fluid" then
                    Output[result.name] = Output[result.name] or {}
                    if result.temperature then
                        local energy_required = Output[result.name][result.temperature]
                        if
                            not energy_required or
                            (energy_required and energy_required < mining_time)
                        then
                            Output[result.name][result.temperature] = mining_time
                        end
                    else
                        Output[result.name].mining_time = mining_time
                    end
                end
            end
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Dar el formato deseado
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        for fluid_name, temperatures in pairs(Output) do
            if
                GMOD.get_length(temperatures) == 1 and
                temperatures.mining_time
            then
                Output[fluid_name] = temperatures.mining_time
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

    local function format_result(result)
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Valores base
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local Output = {
            type = result.type,
            name = result.name,
            amount = result.amount,
            temperature = result.temperature
        }

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---



        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Validación
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        if result.amount_min then
            if result.amount_min == result.amount_max then
                Output.amount = result.amount_min
            else
                Output.amount_min = result.amount_min
                Output.amount_max = result.amount_max
            end
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---



        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Devolver resultado
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        return Output

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    local function validate_recipe(recipe)
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Validación
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        if not recipe.results then return end
        if #recipe.results == 0 then return end
        if not recipe.ingredients then return end
        if This_MOD.ignore_recipes[recipe.name] then return end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Duplicar los valores
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        recipe = GMOD.copy(recipe)

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Dar formato esperado
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        for i, result in pairs(recipe.results) do
            recipe.results[i] = format_result(result)
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Devolver el resultado
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        return {
            type = recipe.type,
            name = recipe.name,
            energy_required = recipe.energy_required or 0.5,
            ingredients = recipe.ingredients,
            results = recipe.results,
        }

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    local function get_recipes()
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Variable a usar
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local Output = {}

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Validar las recetas
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        for _, recipes in pairs(GMOD.recipes) do
            for _, recipe in pairs(recipes) do
                Output[recipe.name] = validate_recipe(recipe)
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

    local function boiler_recipe(boiler)
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Validación
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        if not boiler.fluid_box then return end
        if not boiler.fluid_box.filter then return end
        if not boiler.output_fluid_box then return end
        if not boiler.output_fluid_box.filter then return end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Renombrar
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local Recipe = This_MOD.to_be_processed.affected.recipe

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Formato deseado
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        Recipe["entity" .. " " .. boiler.name] = {
            name = "entity" .. " " .. boiler.name,
            energy_required = 1,

            ingredients = { {
                type = "fluid",
                name = boiler.fluid_box.filter,
                amount = 1,
            } },

            results = { {
                type = "fluid",
                name = boiler.output_fluid_box.filter,
                amount = 1,
                temperature = boiler.target_temperature,
            } }
        }

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Buscar los elements a afectar
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    This_MOD.to_be_processed = {}

    This_MOD.to_be_processed.affected = {
        item = get_items(),
        fluid = get_fluids(),
        recipe = get_recipes()
    }

    for _, entity in pairs(GMOD.entity) do
        boiler_recipe(entity)
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.calculate_prices()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Renombrar
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    This_MOD.to_be_processed.prices = { item = {}, fluid = {} }

    local Prices = This_MOD.to_be_processed.prices
    local Recipes = This_MOD.to_be_processed.affected.recipe

    local Recipe = GMOD.copy(Recipes)

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Funciones auxiliares
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local function get_full_name(element)
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        --- Renombrar
        local name = element.name

        --- No hay termperaturas
        if not (
                element.temperature or
                element.minimum_temperature or
                element.maximum_temperature
            ) then
            return name
        end

        --- Con temperatura
        if type(element.temperature) == "number" then
            return name .. " t " .. element.temperature
        end

        --- Con rango de termperaturas
        if element.minimum_temperature or element.maximum_temperature then
            element = GMOD.get_temperature(element)
        end

        --- Resultado
        return name .. " t " .. element.min .. " " .. element.max

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    local function validate_range(ingredient)
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Validación
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        if ingredient.type ~= "fluid" then return end
        local Full_name = get_full_name(ingredient)
        if Prices.fluid[Full_name] then return end

        --- No hay termperaturas
        if not (
                ingredient.temperature or
                ingredient.minimum_temperature or
                ingredient.maximum_temperature
            )
        then
            return
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---



        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Valores a evaluar
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local Fluid = GMOD.fluid[ingredient.name]
        if not ingredient.maximum_temperature then
            ingredient.maximum_temperature = Fluid.maximum_temperature or Fluid.default_temperature
        end
        if not ingredient.minimum_temperature then
            ingredient.minimum_temperature = Fluid.default_temperature
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---



        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Buscar el precio
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local Values = {}
        local TMP = {}
        local Temperature = GMOD.get_temperature(ingredient)
        for i = Temperature.min, Temperature.max, 1 do
            local name = ingredient.name .. "-t" .. i
            if Prices.fluid[name] then
                table.insert(Values, Prices.fluid[name])
                table.insert(TMP, name)
            end
        end

        local Actual = Math:new()
        for _, precie in pairs(Values) do
            if precie:greater_than(Actual) then
                Actual = precie:copy()
            end
        end

        --- Precio final
        local Value = #Values > 0 and Actual or false
        if Value then Prices.fluid[Full_name] = Value end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Crear los spacios
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for _, recipe in pairs(Recipe) do
        for _, elements in pairs({ recipe.results, recipe.ingredients }) do
            for _, element in pairs(elements) do
                Prices[element.type] = Prices[element.type] or {}

                if element.type == "item" then
                    Prices[element.type][element.name] = false
                end

                if element.type == "fluid" then
                    Prices[element.type][get_full_name(element)] = false
                    Prices[element.type][element.name] = false
                end
            end
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---Valores iniciales
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for name, value in pairs(This_MOD.to_be_processed.affected.item) do
        Prices.item[name] = Math:new(value)
    end

    for fluid, temperatures in pairs(This_MOD.to_be_processed.affected.fluid) do
        for temperature, value in pairs(
            type(temperatures) == "number" and
            { [false] = temperatures } or temperatures
        ) do
            local Value = Math:new(value)
            Prices.fluid[get_full_name({
                name = fluid,
                temperature = temperature
            })] = Value
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Evaluar las recets
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    repeat
        --- Contenedor
        local Price = {}
        local Valid = {}

        --- Recetas que se puedden evaluar
        for _, recipe in pairs(Recipe) do
            local Found = true
            for _, ingredient in pairs(recipe.ingredients) do
                validate_range(ingredient)
                Found = Prices[ingredient.type][get_full_name(ingredient)] and true or false
                if not Found then break end
            end

            for _, result in pairs(Found and recipe.results or {}) do
                local Full_name = get_full_name(result)
                Valid[result.type] = Valid[result.type] or {}
                Valid[result.type][Full_name] = Valid[result.type][Full_name] or {}
                table.insert(Valid[result.type][Full_name], recipe.name)
                if
                    result.type == "fluid" and
                    type(Prices.fluid[result.name]) == "boolean"
                then
                    Valid.fluid[result.name] = Valid.fluid[result.name] or {}
                    table.insert(Valid.fluid[result.name], recipe.name)
                end
            end
        end

        for _, types in pairs(Valid) do
            for _, names in pairs(types) do
                for _, name in pairs(names) do
                    if not Price[name] then
                        Price[name] = Math:new()
                        for _, ingredient in pairs(Recipe[name].ingredients) do
                            local Number = Prices[ingredient.type][get_full_name(ingredient)]:copy()
                            Number:mult(ingredient.amount)
                            Price[name]:add(Number)
                        end
                        Price[name]:add(Recipe[name].energy_required)
                    end
                end
            end
        end

        --- Precio por resultado
        for result_type, elements in pairs(Valid) do
            for result_name, names in pairs(elements) do
                for _, name in pairs(names) do
                    Recipe[name] = nil
                end

                if not Prices[result_type][result_name] then
                    local Actual = Math:new()

                    local Recipe_name = ""
                    for _, name in pairs(names) do
                        if Price[name]:greater_than(Actual) then
                            Actual = Price[name]:copy()
                            Recipe_name = name
                        end
                    end

                    local Amount = 0
                    for _, result in pairs(Recipes[Recipe_name].results) do
                        local Full_name = get_full_name(result)
                        if Full_name == result_name then
                            Amount = result.amount
                            break
                        end
                    end

                    Actual:div(Amount)
                    Prices[result_type][result_name] = Actual
                    Actual.recipe = Recipe_name
                end
            end
        end

        if not GMOD.get_length(Valid) then break end
    until false

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Elimnar los fluidos y objetos sin precios
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for _, elements in pairs(Prices) do
        local Delete = {}

        for name, element in pairs(elements) do
            if not element then
                table.insert(Delete, name)
            else
                elements[name] = {
                    price = element:finish(),
                    recipe = element.recipe,
                    segments = #element.value - 2,
                }
                if
                    #elements[name].price == 0 or (
                        #elements[name].price == 1 and (
                            elements[name].price[1] and
                            elements[name].price[1] == 0
                        )
                    )
                then
                    table.insert(Delete, name)
                end
            end
        end

        for _, name in ipairs(Delete) do
            elements[name] = nil
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------

function This_MOD.create_coins()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Precio más alto
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    This_MOD.maximo = { segments = 0 }

    for _, elements in pairs(This_MOD.to_be_processed.prices) do
        for _, element in pairs(elements) do
            if This_MOD.maximo.segments < element.segments then
                This_MOD.maximo = element
            end
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if not This_MOD.maximo.price then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Crear las monedas
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for i = 1, This_MOD.maximo.segments, 1 do
        if not GMOD.item[This_MOD.coin_name .. "-" .. i] then
            --- Prefijo
            local Char = i > #This_MOD.Units and tostring(i) or
                string.upper(This_MOD.Units:sub(i, i))

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
                        icon = GMOD.signal[Char],
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
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if not This_MOD.maximo then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Recetas para intercambiar las monedas
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

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

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Recorrer las monedas necesarias
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for segment = 2, This_MOD.maximo.segments, 1 do
        for action, value in pairs(This_MOD.actions) do
            recipes_to_coins({
                order = GMOD.pad_left_zeros(3, segment) ..
                    (value == This_MOD.actions.sell and 0 or 1),
                value = value,
                action = action,
                char_up = segment,
                char_down = segment - 1
            })
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.add_category()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Crear categoria y agrega a la maquita
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Category = GMOD.entity[This_MOD.new_entity_name].crafting_categories

    for action, _ in pairs(This_MOD.actions) do
        local Name = This_MOD.prefix .. action
        if GMOD.get_key(Category, Name) then return end
        GMOD.extend({ type = "recipe-category", name = Name })
        table.insert(Category, Name)
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------

function This_MOD.create_spaces()
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Variables a usar
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    This_MOD.to_be_processed.spaces = {}
    local Spaces = This_MOD.to_be_processed.spaces

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Evaluar cada element
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local function create_space(space)
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Procesar el nombre
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        --- Fragmentar el nombre
        local Parts = GMOD.split(space.name)
        if #Parts == 0 then return end

        --- Nombre del elemento
        space.element = GMOD[space.type][Parts[1]]
        space.element = GMOD.copy_with_format(space.element)
        if not space.element then return end

        --- Temperatura
        if #Parts == 3 and Parts[2] == "t" then
            space.temperature = tonumber(Parts[3])
        end

        --- Max y Min de la temperatura
        if #Parts == 4 and Parts[2] == "t" then
            space.minimum_temperature = tonumber(Parts[3])
            space.maximum_temperature = tonumber(Parts[4])
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Validación
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local That_MOD =
            GMOD.get_id_and_name(space.element.name) or
            { ids = "-", name = space.element.name }

        space.effects = {}
        for action, _ in pairs(This_MOD.actions) do
            local Recipe_name =
                GMOD.name .. That_MOD.ids ..
                This_MOD.id .. "-" ..
                action .. "-" ..
                That_MOD.name ..
                (#Parts > 1 and "-" .. table.concat(Parts, "-", 2) or "")

            table.insert(space.effects, {
                type = "unlock-recipe",
                recipe = Recipe_name
            })

            if data.raw.recipe[Recipe_name] then return end
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Guardar la información
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        --- Nombre según acción
        space.sell = space.effects[1].recipe
        space.buy = space.effects[2].recipe

        --- Precio en moneda
        space.coins.sell = Math:new()
        for i = 1, space.segments, 1 do
            space.coins.sell.value[i + 2] = space.coins.buy[i] or 0
        end

        space.coins.sell:div(2)
        space.coins.sell = space.coins.sell:finish()

        if space.recipe then
            space.tech =
                GMOD.name .. That_MOD.ids ..
                This_MOD.id .. "-" ..
                That_MOD.name
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Guardar la información
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        Spaces[space.type] = Spaces[space.type] or {}
        Spaces[space.type][space.name] = space

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Buscar los elements a afectar
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    for element_type, elements in pairs(This_MOD.to_be_processed.prices) do
        for element_name, value in pairs(elements) do
            create_space({
                type = element_type,
                name = element_name,
                coins = { buy = value.price },
                recipe = value.recipe,
                segments = value.segments,
            })
        end
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------

function This_MOD.create_recipe_to_elements(space)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if not space.coins then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Funciones auxiliares
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local function format_coins(coins)
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Contenedor
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local Output = {}

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Cambiar el formato
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        for key, value in pairs(coins) do
            table.insert(Output, {
                type = "item",
                amount = value,
                name = This_MOD.coin_name .. "-" .. key,
                ignored_by_productivity = 0,
                ignored_by_stats = value
            })
        end

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Devolver el resultado
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        return Output

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    local function create_recipe(action, value)
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Crear la receta
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        local Recipe = GMOD.copy(This_MOD.recipe_base)

        Recipe.name = space[action]
        Recipe.energy_required = 0.002
        Recipe.order = space.element.order
        Recipe.category = This_MOD.prefix .. action
        Recipe.localised_name = space.element.localised_name
        Recipe.icons = GMOD.copy(space.element.icons)
        Recipe.enabled = space.recipe == nil

        if value == This_MOD.actions.sell then
            Recipe.localised_name = { "item-name.coin" }
            table.insert(Recipe.icons, {
                icon = GMOD.item[This_MOD.coin_name .. "-1"].icons[1].icon,
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
            temperature = space.temperature,
            name = space.element.name,
            ignored_by_productivity = 0,
            ignored_by_stats = 1
        } }

        Recipe[value[2]] = format_coins(space.coins[action])

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Crear el subgrupo para el objeto
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        --- Duplicar el subgrupo
        if not GMOD.subgroups[Recipe.subgroup] then
            GMOD.duplicate_subgroup(space.element.subgroup, Recipe.subgroup)

            --- Renombrar
            local Subgroup = GMOD.subgroups[Recipe.subgroup]
            local Order = GMOD.subgroups[space.element.subgroup].order
            local Index = value == This_MOD.actions.buy and 6 or 7

            --- Actualizar el order
            Subgroup.order = Index .. Order
        end
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
        --- Crear el prototipo
        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

        GMOD.extend(Recipe)

        --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Crear las recipes
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---


    for action, value in pairs(This_MOD.actions) do
        create_recipe(action, value)
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

function This_MOD.create_tech_to_element(space)
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Validación
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    if not This_MOD.setting.tech then return end
    if not space.tech then return end
    if not space.coins then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    --- Cambiar algunas propiedades
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Tipo y nombre
    local Tech = {}
    Tech.type = "technology"
    Tech.name = space.tech .. "-tech"

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
