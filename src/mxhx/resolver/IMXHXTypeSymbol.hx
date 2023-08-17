package mxhx.resolver;

interface IMXHXTypeSymbol extends IMXHXSymbol {
	public var qname:String;
	public var module:String;
	public var pack:Array<String>;
	public var params:Array<IMXHXTypeSymbol>;
}
