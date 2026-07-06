extends AttackAbility

func process(_ctx):
	pass

func attack(atk_type):
	var bodies = entity.hitbox.get_overlapping_bodies()
	if bodies.is_empty() : return
	
	for body in bodies:
		if body == entity : continue
		if !(body is Entity) : continue
		
		var atk_ctx := construct_attack_context(body,atk_type)
		resolve(atk_ctx)

func construct_attack_context(body,atk_type)-> AttackContext:
	var obj = AttackContext.new()
	obj.attacker = entity
	obj.target = body
	obj.attack_type = atk_type
	return obj

func execute(atk_type):
	attack(atk_type)

func resolve(atk_ctx : AttackContext):
	ability_manager.resolve_attack(atk_ctx)
