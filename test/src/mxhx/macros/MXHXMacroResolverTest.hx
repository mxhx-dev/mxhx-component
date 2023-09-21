package mxhx.macros;

import mxhx.resolver.IMXHXClassSymbol;
import mxhx.macros.MXHXMacroResolver;
import mxhx.resolver.IMXHXTypeSymbol;
import utest.Test;
#if !macro
import utest.Assert;
#end

class MXHXMacroResolverTest extends Test {
	#if !macro
	public function testResolveAny():Void {
		var resolved = resolveQname("Any");
		Assert.equals("Any", resolved);
	}

	public function testResolveArray():Void {
		var resolved = resolveQname("Array");
		Assert.equals("Array", resolved);
	}

	public function testResolveBool():Void {
		var resolved = resolveQname("Bool");
		Assert.equals("Bool", resolved);
	}

	public function testResolveStdTypesBool():Void {
		var resolved = resolveQname("StdTypes.Bool");
		Assert.equals("Bool", resolved);
	}

	public function testResolveDynamic():Void {
		var resolved = resolveQname("Dynamic");
		Assert.equals("Dynamic", resolved);
	}

	public function testResolveEReg():Void {
		var resolved = resolveQname("EReg");
		Assert.equals("EReg", resolved);
	}

	public function testResolveFloat():Void {
		var resolved = resolveQname("Float");
		Assert.equals("Float", resolved);
	}

	public function testResolveStdTypesFloat():Void {
		var resolved = resolveQname("StdTypes.Float");
		Assert.equals("Float", resolved);
	}

	public function testResolveInt():Void {
		var resolved = resolveQname("Int");
		Assert.equals("Int", resolved);
	}

	public function testResolveStdTypesInt():Void {
		var resolved = resolveQname("StdTypes.Int");
		Assert.equals("Int", resolved);
	}

	public function testResolveString():Void {
		var resolved = resolveQname("String");
		Assert.equals("String", resolved);
	}

	public function testResolveUInt():Void {
		var resolved = resolveQname("UInt");
		Assert.equals("UInt", resolved);
	}

	public function testResolveQnameFromLocalClass():Void {
		var resolved = resolveQname("fixtures.TestPropertiesClass");
		Assert.equals("fixtures.TestPropertiesClass", resolved);
	}

	public function testResolveArrayField():Void {
		var resolved = resolveQnameFieldType("fixtures.TestPropertiesClass", "array");
		Assert.equals("Array<String>", resolved);
	}

	public function testResolveBoolField():Void {
		var resolved = resolveQnameFieldType("fixtures.TestPropertiesClass", "boolean");
		Assert.equals("Bool", resolved);
	}

	public function testResolveClassField():Void {
		var resolved = resolveQnameFieldType("fixtures.TestPropertiesClass", "type");
		// TODO: fix the % that should be used only internally
		Assert.equals("Class<Dynamic<%>>", resolved);
	}

	public function testResolveDateField():Void {
		var resolved = resolveQnameFieldType("fixtures.TestPropertiesClass", "date");
		Assert.equals("Date", resolved);
	}

	public function testResolveERegField():Void {
		var resolved = resolveQnameFieldType("fixtures.TestPropertiesClass", "ereg");
		Assert.equals("EReg", resolved);
	}

	public function testResolveFloatField():Void {
		var resolved = resolveQnameFieldType("fixtures.TestPropertiesClass", "float");
		Assert.equals("Float", resolved);
	}

	public function testResolveIntField():Void {
		var resolved = resolveQnameFieldType("fixtures.TestPropertiesClass", "integer");
		Assert.equals("Int", resolved);
	}

	public function testResolveStringField():Void {
		var resolved = resolveQnameFieldType("fixtures.TestPropertiesClass", "string");
		Assert.equals("String", resolved);
	}

	public function testResolveUIntField():Void {
		var resolved = resolveQnameFieldType("fixtures.TestPropertiesClass", "unsignedInteger");
		Assert.equals("UInt", resolved);
	}

	public function testResolveXmlField():Void {
		var resolved = resolveQnameFieldType("fixtures.TestPropertiesClass", "xml");
		Assert.equals("Xml", resolved);
	}

	public function testResolveNullField():Void {
		var resolved = resolveQnameFieldType("fixtures.TestPropertiesClass", "canBeNull");
		Assert.equals("Null<Float>", resolved);
	}

	public function testResolveStrictlyTypedField():Void {
		var resolved = resolveQnameFieldType("fixtures.TestPropertiesClass", "strictlyTyped");
		Assert.equals("fixtures.TestPropertiesClass", resolved);
	}

	public function testResolveFieldWithTypeParameter():Void {
		var resolved = resolveQnameFieldType("fixtures.ArrayCollection", "array");
		// TODO: fix the % that should be used only internally
		Assert.equals("Array<%>", resolved);
	}
	#end

	public static macro function resolveQname(qname:String):haxe.macro.Expr {
		var resolver = new MXHXMacroResolver();
		return macro $v{resolver.resolveQname(qname).qname};
	}

	public static macro function resolveQnameFieldType(qname:String, fieldName:String):haxe.macro.Expr {
		var resolver = new MXHXMacroResolver();
		var resolvedClass:IMXHXClassSymbol = cast resolver.resolveQname(qname);
		var field = Lambda.find(resolvedClass.fields, field -> field.name == fieldName);
		return macro $v{resolver.resolveQname(field.type.qname).qname};
	}
}
