envLayerMask = Physics.CreateLayerMask("Environment")
outLayerMask = Physics.CreateLayerMask("Outdoors")
enemyLayerMask = Physics.CreateLayerMask("EnemyTrigger")
bigCorpseLayerMask = Physics.CreateLayerMask("BigCorpse")
finalLayerMask = envLayerMask + outLayerMask + enemyLayerMask + bigCorpseLayerMask

function OnEnable()
	rb = gameObject.GetComponent("Rigidbody")
	col = gameObject.GetComponent("SphereCollider")
	part1 = transform.Find("Component-1")
	part2 = transform.Find("Component-2")
	part3 = transform.Find("Component-3")
	part1.gameObject.layer = 14
	part2.gameObject.layer = 14
	part3.gameObject.layer = 14

	deadChecker = transform.Find("DeadChecker").gameObject

	chosenEnemy = ChooseEnemy()
	proj = gameObject.AddProjComponent()
	SetProjectile()
end

function Update()
	part1.rotation = Random.rotation
	part2.rotation = Random.rotation
	part3.rotation = Random.rotation
	part1.position = transform.position
	part2.position = transform.position
	part3.position = transform.position
end

function ChooseEnemy(check)
	enemyList = {}
	tempList = GameObject.FindGameObjectsWithTag("Enemy")
	searchOrigin = Physics.Raycast(
		Player.head.position + Player.head.forward,
		Player.head.forward,
		Mathf.infinity,
		finalLayerMask
	)
	for _, enemy in ipairs(tempList) do
		direction = (enemy.transform.position - transform.position).normalized
		hitCastResult = Physics.Raycast(
			transform.position,
			direction,
			Mathf.infinity
		)
		if hitCastResult ~= nil and (hitCastResult.gameObject.layer == 12 or hitCastResult.gameObject.layer == 26 or hitCastResult.gameObject.layer == 11) then
			table.insert(enemyList, enemy)
		end
	end
	index = 0
	distance = Mathf.infinity
	if searchOrigin ~= nil then
		searchPos = searchOrigin.point
	else
		searchPos = transform.position
	end
	for i, enemy in ipairs(enemyList) do
		tempDist = Vector3.Distance(enemy.transform.position, searchPos)
		if tempDist < distance then
			distance = tempDist
			index = i
		end
	end
	return enemyList[index]
end

function SetProjectile()
	proj.damage = 15
	proj.speed = 20
	proj.turningSpeedMultiplier = 1
    proj.decorative = false
	proj.undeflectable = false
	proj.friendly = true
	proj.playerBullet = true
    proj.bulletType = "HomingGun"
    proj.weaponType = "Rat"
    proj.explosive = true
	proj.bigExplosion = true
    proj.explosionEffect = AssetDatabase.Get("MindflayerExplosion")
	if chosenEnemy ~= nil then
		proj.homingType = HomingType.Loose
		proj.targetTransform = chosenEnemy.transform
	end
end

function OnDisable()
	deadChecker.transform.parent = nil
	deadChecker.SetActive(true)
end