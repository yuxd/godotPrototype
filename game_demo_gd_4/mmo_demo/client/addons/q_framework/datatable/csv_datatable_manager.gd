extends DatatableManager
class_name CSVDatatableManager

var thread := Thread.new()
var file = File.new()

func get_datatable(datatable_name : String) -> Dictionary:
	if _datatable_dics.has(datatable_name):
		return _datatable_dics[datatable_name]
	else:
		load_datatable(datatable_name, datatable_path)
		return _datatable_dics[datatable_name]		

func load_datatables_async(datatables : Array) -> Array:
	var datatables_in = datatables.duplicate()
	var out := []
	if can_async:
		thread.start(threaded_load.bind(datatables_in))
		out = await self.done
		thread.wait_to_finish()
	else:
		print("can not async load csv")
	return out

func threaded_load(datatables_in : Array) -> void:
	var datatables_out = []
#	var file = File.new()
	for dat_in in datatables_in:
		print_debug("开始加载 datatable: ", dat_in)
		var dic_dt = load_datatable(dat_in, datatable_path)
		_datatable_dics[dat_in] = dic_dt
	call_deferred('emit_signal', 'done', datatables_out)
	
func load_datatable(name : String, path : String) -> Dictionary:
	file.open(path + name + ".csv", File.READ)
	var data_name = file.get_csv_line(",")
	var dec_ = file.get_csv_line(",")
	var type_name = file.get_csv_line(",")
	var dic_dt = {}
	var row_data
	while not file.eof_reached():
		# TODO 这里可以加入类型检查
		row_data = file.get_csv_line(",")
		var d = {}
		for i in row_data.size():
			match type_name[i]:
				"int":
					d[data_name[i]] = row_data[i].to_int()
				"float":
					d[data_name[i]] = row_data[i].to_float()
				"int[]":
					var datas = row_data[i].split("*")
					var res : = []
					for data in datas:
						res.append(data.to_int())
					d[data_name[i]] = res
				"float[]":
					var datas = row_data[i].split("*")
					var res : = []
					for data in datas:
						res.append(data.to_float())
					d[data_name[i]] = res
				"string[]":
					var res = row_data[i].split("*")
					d[data_name[i]] = res
				_:
					d[data_name[i]] = row_data[i]
		dic_dt[d["ID"]] = d
	_datatable_dics[name] = dic_dt
	return dic_dt
