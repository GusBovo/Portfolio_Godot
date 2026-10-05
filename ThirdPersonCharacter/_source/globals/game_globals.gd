extends Node

enum TweenKillMode {
	KILL, # Flag to just kill a tween
	FINISH_AND_KILL # Flag to wait until tween is finished before kill
	}

# Custom

## Checks if Tween passed is running.
func is_tween_running(tween : Tween) -> bool:
	if !tween:
		return false

	if !tween.is_running():
		return false

	return true

## Checks if any Tween in the array passed is running.
## More costly, use is_tween_running() for a single Tween.
func is_tween_group_running(...args) -> bool:
	for arg in args:
		
		if !arg:
			return false
		
		assert(arg is Tween, "Argument passed in is_tween_group_running() is not a Tween")
		
		if arg.is_running():
			return true

	return false

## Checks if there is a valid Tween and kills it.
func kill_tween(mode: TweenKillMode, tween : Tween) -> void:
	if !tween:
		return
	
	match mode:
		TweenKillMode.KILL:
			tween.kill()
		TweenKillMode.FINISH_AND_KILL:
			if !tween.is_running():
				tween.kill()

## Checks if there is a valid Tween array and kills it.
## More costly, use kill_tween() for just one Tween.
func kill_tween_group(mode: TweenKillMode, ...args : Array) -> void:
	for arg in args:
		if !arg:
			return

		assert(arg is Tween, "Argument passed to kill_tween_group() is not a Tween: " + str(arg))

		match mode:
			TweenKillMode.KILL:
				arg.kill()
			TweenKillMode.FINISH_AND_KILL:
				if !arg.is_running():
					arg.kill()
