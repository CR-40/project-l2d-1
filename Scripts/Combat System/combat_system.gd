extends Node

func resolve(atk_ctx: AttackContext):
	print("[Combat System]=> Resolving attack...")
	var attackpt = atk_ctx.attacker.stats.attack
	var defencept = atk_ctx.target.stats.defense
	var damage = attackpt**2/(attackpt+defencept)
	atk_ctx.target.take_damage(damage)
	
	print("[Data]-> Attack points :"+str(attackpt))
	print("[Data]-> Deffence points :"+str(defencept))
	print("[Data]-> Calculated Damage: "+ str(damage))
	
