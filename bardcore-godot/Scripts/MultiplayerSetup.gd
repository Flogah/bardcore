extends Node

func setupMultiplayer(playerCount:int):
	var actionList:Array[StringName]
	var actionEventList:Array[InputEvent]
	var currentAction:StringName
	var currentEvent:InputEvent
	actionList = InputMap.get_actions()
	
	#For each player
		#For each action
			#For each InputEvent
	
	for player in range(playerCount):
		for act in range(actionList.size()):
			if(actionList[act].begins_with("ui_")):
				continue
			currentAction = actionList[act]+str(player)
			InputMap.add_action(currentAction)
			actionEventList = InputMap.action_get_events(actionList[act])
			for event in range(actionEventList.size()):
				currentEvent = actionEventList[event].duplicate(true)
				currentEvent.set_device(player)
				print(currentEvent.device)
				InputMap.action_add_event(currentAction,currentEvent)
