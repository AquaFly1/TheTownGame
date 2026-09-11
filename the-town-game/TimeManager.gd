extends Node

var time: Array = [0, 8, 00]
var day_lenght: int = 24
var hour_lenght: int = 60
var days: Array = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY']

func advance_time(amount: Array):
	var days_advanced = amount[0]
	var hours_advanced = amount[1]
	var minutes_advanced = amount[2]
	time[2] += minutes_advanced
	time[1] += hours_advanced
	time[0] += days_advanced
	await update_time()
	print_time()
	
func print_time():
	print("It is %s, and the time is %d:%02d" % [days[time[0]], time[1], time[2]])

func update_time():
	if time[2] >= hour_lenght:
		time[2] -= hour_lenght
		time[1] += 1
		update_time()

	if time[1] >= day_lenght:
		time[1] -= day_lenght
		time[0] += 1
		update_time()
	
	if time[0] > days.size() - 1:
		time[0] = time[0] % days.size()
		update_time()
