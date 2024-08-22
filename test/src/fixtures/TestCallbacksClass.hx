package fixtures;

import haxe.Constraints.Function;

class TestCallbacksClass {
	public var simpleFunction:Function;
	public var mapToString:(Any) -> String;
	public var mapToAny:(Any) -> Any;
	public var mapToDynamic:(Any) -> Any;

	public function new() {}
}
