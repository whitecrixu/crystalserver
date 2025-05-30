local function targetFunction(creature, target)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local bosses = { "leiden" }
	local minHeal = ((player:getLevel() / 5) + (player:getMagicLevel() * 5.7) + 26)
	local maxHeal = ((player:getLevel() / 5) + (player:getMagicLevel() * 10.43) + 62)
	local damage = -((player:getLevel() / 5) + (player:getMagicLevel() * 10.43) + 62)
	if target:isMonster() and table.contains(bosses, target:getName():lower()) then
		target:addHealth(damage)
		target:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		return true
	else
		doTargetCombatHealth(creature, target, COMBAT_HEALING, minHeal, maxHeal, CONST_ME_MAGIC_BLUE, ORIGIN_SPELL, "Mass Healing")
		return true
	end
end

function onTargetCreature(creature, target)
	targetFunction(creature, target)
	return true
end

function onTargetCreatureWOD(creature, target)
	targetFunction(creature, target)
	return true
end

local function createCombat(area, combatFunc)
	local initCombat = Combat()
	initCombat:setCallback(CALLBACK_PARAM_TARGETCREATURE, combatFunc)
	initCombat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
	initCombat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)
	initCombat:setParameter(COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)
	initCombat:setArea(createCombatArea(area))
	return initCombat
end

local combat = createCombat(AREA_CIRCLE3X3, "onTargetCreature")
local combatWOD = createCombat(AREA_CIRCLE5X5, "onTargetCreatureWOD")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local player = creature:getPlayer()
	if creature and player then
		if player:getWheelSpellAdditionalArea("Mass Healing") then
			return combatWOD:execute(creature, var)
		end
	end
	return combat:execute(creature, var)
end

spell:name("Mass Healing")
spell:words("exura gran mas res")
spell:group("healing")
spell:vocation("druid;true", "elder druid;true")
spell:id(82)
spell:cooldown(2 * 1000)
spell:groupCooldown(1 * 1000)
spell:level(36)
spell:mana(150)
spell:isPremium(true)
spell:isAggressive(false)
spell:needLearn(false)
spell:castSound(SOUND_EFFECT_TYPE_SPELL_MASS_HEALING)
spell:register()
