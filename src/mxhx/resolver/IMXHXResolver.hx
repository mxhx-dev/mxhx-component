package mxhx.resolver;

interface IMXHXResolver {
	public function registerManifest(uri:String, mappings:Map<String, String>):Void;
	public function resolveTag(tagData:IMXHXTagData):IMXHXSymbol;
	public function resolveAttribute(attributeData:IMXHXTagAttributeData):IMXHXSymbol;
	public function resolveTagField(tagData:IMXHXTagData, fieldName:String):IMXHXFieldSymbol;
	public function resolveQname(qname:String):IMXHXTypeSymbol;
}
