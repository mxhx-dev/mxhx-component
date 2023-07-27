package fixtures;

@:event("change")
class TestPropertiesClass {
	public function new() {}

	public var struct:Dynamic;
	public var boolean:Bool;
	public var ereg:EReg;
	public var float:Float;
	public var integer:Int;
	public var string:String;
	public var unsignedInteger:UInt;
	public var enumValue:TestPropertyEnum;
	public var strictlyTyped:TestPropertiesClass;
	public var array:Array<String>;
	public var type:Class<Dynamic>;
	public var complexEnum:TestComplexEnum;
}
