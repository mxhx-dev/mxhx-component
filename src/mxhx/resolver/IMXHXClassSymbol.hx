package mxhx.resolver;

interface IMXHXClassSymbol extends IMXHXTypeSymbol {
	public var superClass:IMXHXClassSymbol;
	public var fields:Array<IMXHXFieldSymbol>;
	public var events:Array<IMXHXEventSymbol>;
	public var defaultProperty:String;
}
