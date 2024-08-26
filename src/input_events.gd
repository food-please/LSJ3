extends Node

@warning_ignore("unused_signal")
signal construction_data_selected(data: ConstructionData, anchor: RemoteTransform2D)

@warning_ignore("unused_signal")
signal construction_placed(construction: Construction)

@warning_ignore("unused_signal")
signal invalid_construction_placed

@warning_ignore("unused_signal")
signal erase_selected(toggled: bool)

@warning_ignore("unused_signal")
signal cell_erased(cell: Vector2i)

@warning_ignore("unused_signal")
signal unique_citizens_finished()
