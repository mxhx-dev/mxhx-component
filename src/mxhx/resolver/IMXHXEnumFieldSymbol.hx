package mxhx.resolver;

interface IMXHXEnumFieldSymbol extends IMXHXSymbol {
	public var parent:IMXHXEnumSymbol;
	public var args:Array<IMXHXArgumentSymbol>;
}
