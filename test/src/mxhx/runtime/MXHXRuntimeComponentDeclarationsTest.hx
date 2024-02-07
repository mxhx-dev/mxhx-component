package mxhx.runtime;

import Xml.XmlType;
import fixtures.TestClass1;
import fixtures.TestComplexEnum;
import fixtures.TestPropertiesClass;
import fixtures.TestPropertyEnum;
import mxhx.runtime.MXHXRuntimeComponent.MXHXRuntimeComponentException;
import utest.Assert;
import utest.Test;

class MXHXRuntimeComponentDeclarationsTest extends Test {
	public function testDeclarationsEmpty():Void {
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations></mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
	}

	public function testDeclarationsEmptyExtraWhitespace():Void {
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
	}

	public function testDeclarationsComment1():Void {
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations><!-- comment --></mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
	}

	public function testDeclarationsComment2():Void {
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<!-- comment -->
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
	}

	public function testDeclarationsDocComment1():Void {
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations><!--- doc comment --></mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
	}

	public function testDeclarationsDocComment2():Void {
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<!--- doc comment -->
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
	}

	public function testDeclarationsText():Void {
		Assert.raises(() -> MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>text</mx:Declarations>
			</tests:TestClass1>
		'), MXHXRuntimeComponentException);
	}

	public function testStructAttributes():Void {
		var idMap:Map<String, Any> = [];
		var result:TestClass1 = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Struct id="struct" float="123.4" float_hex="0xbeef" nan="NaN"
						infinity="Infinity" negative_infinity="-Infinity" float_exponent="123.4e5"
						boolean_true="true" boolean_false="false" string="hello"/>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("struct"));
		var struct = idMap.get("struct");
		Assert.notNull(struct);
		Assert.equals(9, Reflect.fields(struct).length);
		Assert.isTrue(Reflect.hasField(struct, "float"));
		Assert.isTrue(Reflect.hasField(struct, "float_hex"));
		Assert.isTrue(Reflect.hasField(struct, "nan"));
		Assert.isTrue(Reflect.hasField(struct, "infinity"));
		Assert.isTrue(Reflect.hasField(struct, "negative_infinity"));
		Assert.isTrue(Reflect.hasField(struct, "float_exponent"));
		Assert.isTrue(Reflect.hasField(struct, "boolean_true"));
		Assert.isTrue(Reflect.hasField(struct, "boolean_false"));
		Assert.isTrue(Reflect.hasField(struct, "string"));
		Assert.equals(123.4, Reflect.field(struct, "float"));
		Assert.equals(0xbeef, Reflect.field(struct, "float_hex"));
		Assert.isTrue(Math.isNaN(Reflect.field(struct, "nan")));
		Assert.equals(Math.POSITIVE_INFINITY, Reflect.field(struct, "infinity"));
		Assert.equals(Math.NEGATIVE_INFINITY, Reflect.field(struct, "negative_infinity"));
		Assert.equals(123.4e5, Reflect.field(struct, "float_exponent"));
		Assert.isTrue(Reflect.field(struct, "boolean_true"));
		Assert.isFalse(Reflect.field(struct, "boolean_false"));
		Assert.equals("hello", Reflect.field(struct, "string"));
	}

	public function testStructAttributesExtraWhitespace():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Struct id="struct" float=" 123.4 " float_hex=" 0xbeef " nan=" NaN "
						infinity=" Infinity " negative_infinity=" -Infinity " float_exponent=" 123.4e5 "
						boolean_true=" true " boolean_false=" false " string=" hello "/>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("struct"));
		var struct = idMap.get("struct");
		Assert.notNull(struct);
		Assert.equals(9, Reflect.fields(struct).length);
		Assert.isTrue(Reflect.hasField(struct, "float"));
		Assert.isTrue(Reflect.hasField(struct, "float_hex"));
		Assert.isTrue(Reflect.hasField(struct, "nan"));
		Assert.isTrue(Reflect.hasField(struct, "infinity"));
		Assert.isTrue(Reflect.hasField(struct, "negative_infinity"));
		Assert.isTrue(Reflect.hasField(struct, "float_exponent"));
		Assert.isTrue(Reflect.hasField(struct, "boolean_true"));
		Assert.isTrue(Reflect.hasField(struct, "boolean_false"));
		Assert.isTrue(Reflect.hasField(struct, "string"));
		Assert.equals(123.4, Reflect.field(struct, "float"));
		Assert.equals(0xbeef, Reflect.field(struct, "float_hex"));
		Assert.isTrue(Math.isNaN(Reflect.field(struct, "nan")));
		Assert.equals(Math.POSITIVE_INFINITY, Reflect.field(struct, "infinity"));
		Assert.equals(Math.NEGATIVE_INFINITY, Reflect.field(struct, "negative_infinity"));
		Assert.equals(123.4e5, Reflect.field(struct, "float_exponent"));
		Assert.isTrue(Reflect.field(struct, "boolean_true"));
		Assert.isFalse(Reflect.field(struct, "boolean_false"));
		Assert.equals(" hello ", Reflect.field(struct, "string"));
	}

	public function testStructChildElements():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Struct id="struct">
						<mx:float>123.4</mx:float>
						<mx:float_hex>0xbeef</mx:float_hex>
						<mx:nan>NaN</mx:nan>
						<mx:infinity>Infinity</mx:infinity>
						<mx:negative_infinity>-Infinity</mx:negative_infinity>
						<mx:float_exponent>123.4e5</mx:float_exponent>
						<mx:boolean_true>true</mx:boolean_true>
						<mx:boolean_false>false</mx:boolean_false>
						<mx:string>hello</mx:string>
						<mx:object>
							<mx:Struct>
								<mx:integer>567</mx:integer>
							</mx:Struct>
						</mx:object>
					</mx:Struct>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("struct"));
		var struct = idMap.get("struct");
		Assert.notNull(struct);
		Assert.equals(10, Reflect.fields(struct).length);
		Assert.isTrue(Reflect.hasField(struct, "float"));
		Assert.isTrue(Reflect.hasField(struct, "float_hex"));
		Assert.isTrue(Reflect.hasField(struct, "nan"));
		Assert.isTrue(Reflect.hasField(struct, "infinity"));
		Assert.isTrue(Reflect.hasField(struct, "negative_infinity"));
		Assert.isTrue(Reflect.hasField(struct, "float_exponent"));
		Assert.isTrue(Reflect.hasField(struct, "boolean_true"));
		Assert.isTrue(Reflect.hasField(struct, "boolean_false"));
		Assert.isTrue(Reflect.hasField(struct, "string"));
		Assert.equals(123.4, Reflect.field(struct, "float"));
		Assert.equals(0xbeef, Reflect.field(struct, "float_hex"));
		Assert.isTrue(Math.isNaN(Reflect.field(struct, "nan")));
		Assert.equals(Math.POSITIVE_INFINITY, Reflect.field(struct, "infinity"));
		Assert.equals(Math.NEGATIVE_INFINITY, Reflect.field(struct, "negative_infinity"));
		Assert.equals(123.4e5, Reflect.field(struct, "float_exponent"));
		Assert.isTrue(Reflect.field(struct, "boolean_true"));
		Assert.isFalse(Reflect.field(struct, "boolean_false"));
		Assert.equals("hello", Reflect.field(struct, "string"));
		Assert.notNull(Reflect.field(struct, "object"));
		Assert.equals(567, Reflect.field(Reflect.field(struct, "object"), "integer"));
	}

	public function testStructChildElementsExtraWhitespace():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Struct id="struct">
						<mx:float>
							123.4
						</mx:float>
						<mx:float_hex>
							0xbeef
						</mx:float_hex>
						<mx:nan>
							NaN
						</mx:nan>
						<mx:infinity>
							Infinity
						</mx:infinity>
						<mx:negative_infinity>
							-Infinity
						</mx:negative_infinity>
						<mx:float_exponent>
							123.4e5
						</mx:float_exponent>
						<mx:boolean_true>
							true
						</mx:boolean_true>
						<mx:boolean_false>
							false
						</mx:boolean_false>
						<mx:string> hello </mx:string>
						<mx:object>
							<mx:Struct>
								<mx:integer>
									567
								</mx:integer>
							</mx:Struct>
						</mx:object>
					</mx:Struct>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("struct"));
		var struct = idMap.get("struct");
		Assert.notNull(struct);
		Assert.equals(10, Reflect.fields(struct).length);
		Assert.isTrue(Reflect.hasField(struct, "float"));
		Assert.isTrue(Reflect.hasField(struct, "float_hex"));
		Assert.isTrue(Reflect.hasField(struct, "nan"));
		Assert.isTrue(Reflect.hasField(struct, "infinity"));
		Assert.isTrue(Reflect.hasField(struct, "negative_infinity"));
		Assert.isTrue(Reflect.hasField(struct, "float_exponent"));
		Assert.isTrue(Reflect.hasField(struct, "boolean_true"));
		Assert.isTrue(Reflect.hasField(struct, "boolean_false"));
		Assert.isTrue(Reflect.hasField(struct, "string"));
		Assert.equals(123.4, Reflect.field(struct, "float"));
		Assert.equals(0xbeef, Reflect.field(struct, "float_hex"));
		Assert.isTrue(Math.isNaN(Reflect.field(struct, "nan")));
		Assert.equals(Math.POSITIVE_INFINITY, Reflect.field(struct, "infinity"));
		Assert.equals(Math.NEGATIVE_INFINITY, Reflect.field(struct, "negative_infinity"));
		Assert.equals(123.4e5, Reflect.field(struct, "float_exponent"));
		Assert.isTrue(Reflect.field(struct, "boolean_true"));
		Assert.isFalse(Reflect.field(struct, "boolean_false"));
		Assert.equals(" hello ", Reflect.field(struct, "string"));
		Assert.notNull(Reflect.field(struct, "object"));
		Assert.equals(567, Reflect.field(Reflect.field(struct, "object"), "integer"));
	}

	public function testStructEmpty():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Struct id="struct"></mx:Struct>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("struct"));
		var struct = idMap.get("struct");
		Assert.notNull(struct);
		Assert.equals(0, Reflect.fields(struct).length);
	}

	public function testStructEmptyExtraWhitespace():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Struct id="struct">
					</mx:Struct>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("struct"));
		var struct = idMap.get("struct");
		Assert.notNull(struct);
		Assert.equals(0, Reflect.fields(struct).length);
	}

	public function testStructOnlyComment1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Struct id="struct"><!-- comment --></mx:Struct>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("struct"));
		var struct = idMap.get("struct");
		Assert.notNull(struct);
		Assert.equals(0, Reflect.fields(struct).length);
	}

	public function testStructOnlyComment2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Struct id="struct">
						<!-- comment -->
					</mx:Struct>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("struct"));
		var struct = idMap.get("struct");
		Assert.notNull(struct);
		Assert.equals(0, Reflect.fields(struct).length);
	}

	public function testStructOnlyDocComment():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Struct id="struct">
						<!--- comment -->
					</mx:Struct>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("struct"));
		var struct = idMap.get("struct");
		Assert.notNull(struct);
		Assert.equals(0, Reflect.fields(struct).length);
	}

	public function testStrict():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertiesClass
						id="strictlyTyped"
						boolean="true"
						float="123.4"
						integer="567"
						string="hello"
						canBeNull="890.1">
						<tests:struct>
							<mx:Struct float="123.4" boolean="true" string="hello">
								<mx:object>
									<mx:Struct>
										<mx:integer>567</mx:integer>
									</mx:Struct>
								</mx:object>
							</mx:Struct>
						</tests:struct>
					</tests:TestPropertiesClass>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("strictlyTyped"));
		Assert.isOfType(result, TestClass1);
		var strictlyTyped = Std.downcast((idMap.get("strictlyTyped") : Dynamic), TestPropertiesClass);
		Assert.notNull(strictlyTyped);
		Assert.isOfType(strictlyTyped, TestPropertiesClass);
		Assert.isTrue(strictlyTyped.boolean);
		Assert.equals(123.4, strictlyTyped.float);
		Assert.equals("hello", strictlyTyped.string);
		Assert.equals(567, strictlyTyped.integer);
		Assert.equals(890.1, strictlyTyped.canBeNull);
		Assert.notNull(strictlyTyped.struct);
		Assert.equals(4, Reflect.fields(strictlyTyped.struct).length);
		Assert.isTrue(Reflect.hasField(strictlyTyped.struct, "float"));
		Assert.isTrue(Reflect.hasField(strictlyTyped.struct, "boolean"));
		Assert.isTrue(Reflect.hasField(strictlyTyped.struct, "string"));
		Assert.isTrue(Reflect.hasField(strictlyTyped.struct, "object"));
		Assert.equals(123.4, Reflect.field(strictlyTyped.struct, "float"));
		Assert.isTrue(Reflect.field(strictlyTyped.struct, "boolean"));
		Assert.equals("hello", Reflect.field(strictlyTyped.struct, "string"));
		Assert.notNull(Reflect.field(strictlyTyped.struct, "object"));
		Assert.equals(567, Reflect.field(Reflect.field(strictlyTyped.struct, "object"), "integer"));
	}

	public function testStrictExtraWhitespace():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertiesClass
						id="strictlyTyped"
						boolean=" true "
						float=" 123.4 "
						integer=" 567 "
						string=" hello "
						canBeNull=" 890.1 ">
					</tests:TestPropertiesClass>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("strictlyTyped"));
		var strictlyTyped = Std.downcast((idMap.get("strictlyTyped") : Dynamic), TestPropertiesClass);
		Assert.notNull(strictlyTyped);
		Assert.isOfType(strictlyTyped, TestPropertiesClass);
		Assert.isTrue(strictlyTyped.boolean);
		Assert.equals(123.4, strictlyTyped.float);
		Assert.equals(" hello ", strictlyTyped.string);
		Assert.equals(567, strictlyTyped.integer);
		Assert.equals(890.1, strictlyTyped.canBeNull);
	}

	// TODO: abstract enum value

	public function testEnumValue():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertyEnum id="enumValue">Value2</tests:TestPropertyEnum>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("enumValue"));
		var enumValue = idMap.get("enumValue");
		Assert.equals(TestPropertyEnum.Value2, enumValue);
	}

	public function testEnumValueExtraWhitespace():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertyEnum id="enumValue">
						Value2
					</tests:TestPropertyEnum>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("enumValue"));
		var enumValue = idMap.get("enumValue");
		Assert.equals(TestPropertyEnum.Value2, enumValue);
	}

	public function testEnumValueComment1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertyEnum id="enumValue">Value2<!-- comment --></tests:TestPropertyEnum>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("enumValue"));
		var enumValue = idMap.get("enumValue");
		Assert.equals(TestPropertyEnum.Value2, enumValue);
	}

	public function testEnumValueComment2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertyEnum id="enumValue"><!-- comment -->Value2</tests:TestPropertyEnum>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("enumValue"));
		var enumValue = idMap.get("enumValue");
		Assert.equals(TestPropertyEnum.Value2, enumValue);
	}

	public function testEnumValueComment3():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertyEnum id="enumValue">Val<!-- comment -->ue2</tests:TestPropertyEnum>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("enumValue"));
		var enumValue = idMap.get("enumValue");
		Assert.equals(TestPropertyEnum.Value2, enumValue);
	}

	public function testEnumValueCData():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertyEnum id="enumValue"><![CDATA[Value2]]></tests:TestPropertyEnum>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("enumValue"));
		var enumValue = idMap.get("enumValue");
		Assert.equals(TestPropertyEnum.Value2, enumValue);
	}

	public function testEReg():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:EReg id="ereg">~/[a-z]+/g</mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("ereg"));
		var ereg = idMap.get("ereg");
		Assert.isOfType(ereg, EReg);
		#if interp
		Assert.equals("~/[a-z]+/g", Std.string(ereg));
		#end
	}

	public function testERegExtraWhitespace():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:EReg id="ereg">
						~/[a-z]+/g
					</mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("ereg"));
		var ereg = idMap.get("ereg");
		Assert.isOfType(ereg, EReg);
		#if interp
		Assert.equals("~/[a-z]+/g", Std.string(ereg));
		#end
	}

	public function testERegComment1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:EReg id="ereg">~/[a-z]+/g<!-- comment --></mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("ereg"));
		var ereg = idMap.get("ereg");
		Assert.isOfType(ereg, EReg);
		#if interp
		Assert.equals("~/[a-z]+/g", Std.string(ereg));
		#end
	}

	public function testERegComment2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:EReg id="ereg"><!-- comment -->~/[a-z]+/g</mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("ereg"));
		var ereg = idMap.get("ereg");
		Assert.isOfType(ereg, EReg);
		#if interp
		Assert.equals("~/[a-z]+/g", Std.string(ereg));
		#end
	}

	public function testERegEmpty():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:EReg id="ereg"></mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("ereg"));
		var ereg = idMap.get("ereg");
		Assert.isOfType(ereg, EReg);
		#if interp
		Assert.equals("~//", Std.string(ereg));
		#end
	}

	public function testERegEmptyExtraWhitespace():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:EReg id="ereg">
					</mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("ereg"));
		var ereg = idMap.get("ereg");
		Assert.isOfType(ereg, EReg);
		#if interp
		Assert.equals("~//", Std.string(ereg));
		#end
	}

	public function testERegOnlyComment1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:EReg id="ereg"><!-- comment --></mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("ereg"));
		var ereg = idMap.get("ereg");
		Assert.isOfType(ereg, EReg);
		#if interp
		Assert.equals("~//", Std.string(ereg));
		#end
	}

	public function testERegOnlyComment2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:EReg id="ereg">
						<!-- comment -->
					</mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("ereg"));
		var ereg = idMap.get("ereg");
		Assert.isOfType(ereg, EReg);
		#if interp
		Assert.equals("~//", Std.string(ereg));
		#end
	}

	public function testERegOnlyDocComment1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:EReg id="ereg"><!--- doc comment --></mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("ereg"));
		var ereg = idMap.get("ereg");
		Assert.isOfType(ereg, EReg);
		#if interp
		Assert.equals("~//", Std.string(ereg));
		#end
	}

	public function testERegOnlyDocComment2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:EReg id="ereg">
						<!--- doc comment -->
					</mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("ereg"));
		var ereg = idMap.get("ereg");
		Assert.isOfType(ereg, EReg);
		#if interp
		Assert.equals("~//", Std.string(ereg));
		#end
	}

	public function testERegNoExpression():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:EReg id="ereg">~//</mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("ereg"));
		var ereg = idMap.get("ereg");
		Assert.isOfType(ereg, EReg);
		#if interp
		Assert.equals("~//", Std.string(ereg));
		#end
	}

	public function testERegCData():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:EReg id="ereg"><![CDATA[~/[a-z]+/g]]></mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("ereg"));
		var ereg = idMap.get("ereg");
		Assert.isOfType(ereg, EReg);
		#if interp
		Assert.equals("~/[a-z]+/g", Std.string(ereg));
		#end
	}

	public function testFloat():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">123.4</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("float"));
		var float = idMap.get("float");
		Assert.isOfType(float, Float);
		Assert.equals(123.4, float);
	}

	public function testFloatExtraWhitespace():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">
						123.4
					</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("float"));
		var float = idMap.get("float");
		Assert.isOfType(float, Float);
		Assert.equals(123.4, float);
	}

	public function testFloatComment1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">123.4<!-- comment --></mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("float"));
		var float = idMap.get("float");
		Assert.isOfType(float, Float);
		Assert.equals(123.4, float);
	}

	public function testFloatComment2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float"><!-- comment -->123.4</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("float"));
		var float = idMap.get("float");
		Assert.isOfType(float, Float);
		Assert.equals(123.4, float);
	}

	public function testFloatComment3():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">12<!-- comment -->3.4</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("float"));
		var float = idMap.get("float");
		Assert.isOfType(float, Float);
		Assert.equals(123.4, float);
	}

	public function testFloatEmpty():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float"></mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("float"));
		var float = idMap.get("float");
		Assert.isOfType(float, Float);
		Assert.isTrue(Math.isNaN(float));
	}

	public function testFloatEmptyExtraWhitespace():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">
					</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("float"));
		var float = idMap.get("float");
		Assert.isOfType(float, Float);
		Assert.isTrue(Math.isNaN(float));
	}

	public function testFloatOnlyComment1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float"><!-- comment --></mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("float"));
		var float = idMap.get("float");
		Assert.isOfType(float, Float);
		Assert.isTrue(Math.isNaN(float));
	}

	public function testFloatOnlyComment2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">
						<!-- comment -->
					</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("float"));
		var float = idMap.get("float");
		Assert.isOfType(float, Float);
		Assert.isTrue(Math.isNaN(float));
	}

	public function testFloatOnlyDocComment1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float"><!--- comment --></mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("float"));
		var float = idMap.get("float");
		Assert.isOfType(float, Float);
		Assert.isTrue(Math.isNaN(float));
	}

	public function testFloatOnlyDocComment2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">
						<!--- doc comment -->
					</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("float"));
		var float = idMap.get("float");
		Assert.isOfType(float, Float);
		Assert.isTrue(Math.isNaN(float));
	}

	public function testFloatNegative():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">-123.4</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("float"));
		var float = idMap.get("float");
		Assert.isOfType(float, Float);
		Assert.equals(-123.4, float);
	}

	public function testFloatInt():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">456</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("float"));
		var float = idMap.get("float");
		Assert.isOfType(float, Float);
		Assert.equals(456, float);
	}

	public function testFloatIntNegative():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">-456</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("float"));
		var float = idMap.get("float");
		Assert.isOfType(float, Float);
		Assert.equals(-456, float);
	}

	public function testFloatHexLowerCase():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">0xbeef</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("float"));
		var float = idMap.get("float");
		Assert.isOfType(float, Float);
		Assert.equals(0xbeef, float);
	}

	public function testFloatHexUpperCase():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">0xBEEF</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("float"));
		var float = idMap.get("float");
		Assert.isOfType(float, Float);
		Assert.equals(0xbeef, float);
	}

	public function testFloatHexMixedCase():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">0xbEeF</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("float"));
		var float = idMap.get("float");
		Assert.isOfType(float, Float);
		Assert.equals(0xbeef, float);
	}

	public function testFloatHexNegative():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">-0xbeef</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("float"));
		var float = idMap.get("float");
		Assert.isOfType(float, Float);
		Assert.equals(-0xbeef, float);
	}

	public function testFloatExponent():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">123.4e5</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("float"));
		var float = idMap.get("float");
		Assert.isOfType(float, Float);
		Assert.equals(123.4e5, float);
	}

	public function testFloatNegativeExponent():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">123.4e-5</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("float"));
		var float = idMap.get("float");
		Assert.isOfType(float, Float);
		Assert.equals(123.4e-5, float);
	}

	public function testFloatNaN():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">NaN</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("float"));
		var float = idMap.get("float");
		Assert.isOfType(float, Float);
		Assert.isTrue(Math.isNaN(float));
	}

	public function testFloatInfinity():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">Infinity</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("float"));
		var float = idMap.get("float");
		Assert.isOfType(float, Float);
		Assert.equals(Math.POSITIVE_INFINITY, float);
	}

	public function testFloatNegativeInfinity():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">-Infinity</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("float"));
		var float = idMap.get("float");
		Assert.isOfType(float, Float);
		Assert.equals(Math.NEGATIVE_INFINITY, float);
	}

	public function testFloatCData():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float"><![CDATA[123.4]]></mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("float"));
		var float = idMap.get("float");
		Assert.isOfType(float, Float);
		Assert.equals(123.4, float);
	}

	public function testBool():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Bool id="boolean">true</mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("boolean"));
		var boolean = idMap.get("boolean");
		Assert.isOfType(boolean, Bool);
		Assert.isTrue(boolean);
	}

	public function testBoolExtraWhitespace():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Bool id="boolean">
						true
					</mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("boolean"));
		var boolean = idMap.get("boolean");
		Assert.isOfType(boolean, Bool);
		Assert.isTrue(boolean);
	}

	public function testBoolComment1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Bool id="boolean">true<!-- comment --></mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("boolean"));
		var boolean = idMap.get("boolean");
		Assert.isOfType(boolean, Bool);
		Assert.isTrue(boolean);
	}

	public function testBoolComment2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Bool id="boolean"><!-- comment -->true</mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("boolean"));
		var boolean = idMap.get("boolean");
		Assert.isOfType(boolean, Bool);
		Assert.isTrue(boolean);
	}

	public function testBoolComment3():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Bool id="boolean">tr<!-- comment -->ue</mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("boolean"));
		var boolean = idMap.get("boolean");
		Assert.isOfType(boolean, Bool);
		Assert.isTrue(boolean);
	}

	public function testBoolEmpty():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Bool id="boolean"></mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("boolean"));
		var boolean = idMap.get("boolean");
		Assert.isOfType(boolean, Bool);
		Assert.isFalse(boolean);
	}

	public function testBoolEmptyExtraWhitespace():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Bool id="boolean">
					</mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("boolean"));
		var boolean = idMap.get("boolean");
		Assert.isOfType(boolean, Bool);
		Assert.isFalse(boolean);
	}

	public function testBoolOnlyComment1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Bool id="boolean"><!-- comment --></mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("boolean"));
		var boolean = idMap.get("boolean");
		Assert.isOfType(boolean, Bool);
		Assert.isFalse(boolean);
	}

	public function testBoolOnlyComment2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Bool id="boolean">
						<!-- comment -->
					</mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("boolean"));
		var boolean = idMap.get("boolean");
		Assert.isOfType(boolean, Bool);
		Assert.isFalse(boolean);
	}

	public function testBoolCData():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Bool id="boolean"><![CDATA[true]]></mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("boolean"));
		var boolean = idMap.get("boolean");
		Assert.isOfType(boolean, Bool);
		Assert.isTrue(boolean);
	}

	public function testClass():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Class id="type">fixtures.TestClass1</mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("type"));
		var type = idMap.get("type");
		Assert.isOfType(type, Class);
		Assert.equals(fixtures.TestClass1, type);
	}

	public function testClassExtraWhitespace():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Class id="type">
						fixtures.TestClass1
					</mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("type"));
		var type = idMap.get("type");
		Assert.isOfType(type, Class);
		Assert.equals(fixtures.TestClass1, type);
	}

	public function testClassComment1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Class id="type">fixtures.TestClass1<!-- comment --></mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("type"));
		var type = idMap.get("type");
		Assert.isOfType(type, Class);
		Assert.equals(fixtures.TestClass1, type);
	}

	public function testClassComment2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Class id="type"><!-- comment -->fixtures.TestClass1</mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("type"));
		var type = idMap.get("type");
		Assert.isOfType(type, Class);
		Assert.equals(fixtures.TestClass1, type);
	}

	public function testClassComment3():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Class id="type">fixtures.<!-- comment -->TestClass1</mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("type"));
		var type = idMap.get("type");
		Assert.isOfType(type, Class);
		Assert.equals(fixtures.TestClass1, type);
	}

	public function testClassEmpty():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Class id="type"></mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("type"));
		var type = idMap.get("type");
		Assert.isNull(type);
	}

	public function testClassEmptyExtraWhitespace():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Class id="type">
					</mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("type"));
		var type = idMap.get("type");
		Assert.isNull(type);
	}

	public function testClassOnlyComment1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Class id="type"><!-- comment --></mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("type"));
		var type = idMap.get("type");
		Assert.isNull(type);
	}

	public function testClassOnlyComment2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Class id="type">
						<!-- comment -->
					</mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("type"));
		var type = idMap.get("type");
		Assert.isNull(type);
	}

	public function testClassCData():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Class id="type"><![CDATA[fixtures.TestClass1]]></mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("type"));
		var type = idMap.get("type");
		Assert.isOfType(type, Class);
		Assert.equals(fixtures.TestClass1, type);
	}

	public function testInt():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer">123</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("integer"));
		var integer = idMap.get("integer");
		Assert.isOfType(integer, Int);
		Assert.equals(123, integer);
	}

	public function testIntExtraWhitespace():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer">
						123
					</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("integer"));
		var integer = idMap.get("integer");
		Assert.isOfType(integer, Int);
		Assert.equals(123, integer);
	}

	public function testIntComment1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer">123<!-- comment --></mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("integer"));
		var integer = idMap.get("integer");
		Assert.isOfType(integer, Int);
		Assert.equals(123, integer);
	}

	public function testIntComment2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer"><!-- comment -->123</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("integer"));
		var integer = idMap.get("integer");
		Assert.isOfType(integer, Int);
		Assert.equals(123, integer);
	}

	public function testIntComment3():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer">12<!-- comment -->3</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("integer"));
		var integer = idMap.get("integer");
		Assert.isOfType(integer, Int);
		Assert.equals(123, integer);
	}

	public function testIntEmpty():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer"></mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("integer"));
		var integer = idMap.get("integer");
		Assert.isOfType(integer, Int);
		Assert.equals(0, integer);
	}

	public function testIntEmptyExtraWhitespace():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer">
					</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("integer"));
		var integer = idMap.get("integer");
		Assert.isOfType(integer, Int);
		Assert.equals(0, integer);
	}

	public function testIntOnlyComment1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer"><!-- comment --></mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("integer"));
		var integer = idMap.get("integer");
		Assert.isOfType(integer, Int);
		Assert.equals(0, integer);
	}

	public function testIntOnlyComment2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer">
						<!-- comment -->
					</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("integer"));
		var integer = idMap.get("integer");
		Assert.isOfType(integer, Int);
		Assert.equals(0, integer);
	}

	public function testIntNegative():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer">-123</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("integer"));
		var integer = idMap.get("integer");
		Assert.isOfType(integer, Int);
		Assert.equals(-123, integer);
	}

	public function testIntHexLowerCase():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer">0xbeef</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("integer"));
		var integer = idMap.get("integer");
		Assert.isOfType(integer, Int);
		Assert.equals(0xbeef, integer);
	}

	public function testIntHexUpperCase():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer">0xBEEF</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("integer"));
		var integer = idMap.get("integer");
		Assert.isOfType(integer, Int);
		Assert.equals(0xbeef, integer);
	}

	public function testIntHexMixedCase():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer">0xbEeF</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("integer"));
		var integer = idMap.get("integer");
		Assert.isOfType(integer, Int);
		Assert.equals(0xbeef, integer);
	}

	public function testIntHexNegative():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer">-0xbeef</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("integer"));
		var integer = idMap.get("integer");
		Assert.isOfType(integer, Int);
		Assert.equals(-0xbeef, integer);
	}

	public function testIntCData():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer"><![CDATA[123]]></mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("integer"));
		var integer = idMap.get("integer");
		Assert.isOfType(integer, Int);
		Assert.equals(123, integer);
	}

	public function testString():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string">hello</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("string"));
		var string = idMap.get("string");
		Assert.isOfType(string, String);
		Assert.equals("hello", string);
	}

	public function testStringComment1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string">hello<!-- comment --></mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("string"));
		var string = idMap.get("string");
		Assert.isOfType(string, String);
		Assert.equals("hello", string);
	}

	public function testStringComment2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string"><!-- comment -->hello</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("string"));
		var string = idMap.get("string");
		Assert.isOfType(string, String);
		Assert.equals("hello", string);
	}

	public function testStringComment3():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string">hello<!-- comment -->world</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("string"));
		var string = idMap.get("string");
		Assert.isOfType(string, String);
		Assert.equals("helloworld", string);
	}

	public function testStringEmpty1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string"></mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("string"));
		var string = idMap.get("string");
		// child of field element: empty string, child of declarations: null
		Assert.isNull(string);
	}

	public function testStringEmpty2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string"/>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("string"));
		var string = idMap.get("string");
		// child of field element: empty string, child of declarations: null
		Assert.isNull(string);
	}

	public function testStringEmptyExtraWhitespace():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string">
					</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("string"));
		var string = idMap.get("string");
		// child of field element: empty string, child of declarations: null
		Assert.isNull(string);
	}

	public function testStringCDataEmpty():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string"><![CDATA[]]></mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("string"));
		var string = idMap.get("string");
		// child of field element: empty string, child of declarations: null
		// normally cdata is unmodified, but the one exception is child of
		// declarations and empty
		Assert.isNull(string);
	}

	public function testStringCDataEmptyExtraWhitespace():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string"><![CDATA[ ]]></mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("string"));
		var string = idMap.get("string");
		Assert.isOfType(string, String);
		Assert.equals(" ", string);
	}

	public function testStringCDataEmptyExtraWhitespace2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string"><![CDATA[   ]]></mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("string"));
		var string = idMap.get("string");
		Assert.isOfType(string, String);
		Assert.equals("   ", string);
	}

	public function testStringCDataEmptyExtraWhitespace3():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string">
						<![CDATA[   ]]>
					</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("string"));
		var string = idMap.get("string");
		Assert.isOfType(string, String);
		Assert.equals("   ", string);
	}

	public function testStringCDataEmptyExtraWhitespace4():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string">
						<![CDATA[   ]]>
						<![CDATA[   ]]>
					</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("string"));
		var string = idMap.get("string");
		Assert.isOfType(string, String);
		Assert.equals("      ", string);
	}

	public function testStringSource():Void {
		Assert.raises(() -> MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string" source="source.txt"/>
				</mx:Declarations>
			</tests:TestClass1>
		'), MXHXRuntimeComponentException);
	}

	public function testUInt():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:UInt id="uint">0xFFFFFFFF</mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("uint"));
		var uint = idMap.get("uint");
		#if js
		Assert.isOfType(uint, Float);
		Assert.equals(Std.parseInt("0xFFFFFFFF"), uint);
		Assert.isFalse((uint : Float) < 0);
		#else
		Assert.isOfType(uint, Int);
		Assert.equals(0xFFFFFFFF, uint);
		#end
	}

	public function testUIntHexLowerCase():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:UInt id="uint">0xffffffff</mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("uint"));
		var uint = idMap.get("uint");
		#if js
		Assert.isOfType(uint, Float);
		Assert.equals(Std.parseInt("0xFFFFFFFF"), uint);
		Assert.isFalse((uint : Float) < 0);
		#else
		Assert.isOfType(uint, Int);
		Assert.equals(0xFFFFFFFF, uint);
		#end
	}

	public function testUIntDecimal():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:UInt id="uint">1234</mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("uint"));
		var uint = idMap.get("uint");
		#if js
		Assert.isOfType(uint, Float);
		#else
		Assert.isOfType(uint, Int);
		#end
		Assert.equals(1234, uint);
	}

	public function testUIntExtraWhitespace():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:UInt id="uint">
						0xFFFFFFFF
					</mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("uint"));
		var uint = idMap.get("uint");
		#if js
		Assert.isOfType(uint, Float);
		Assert.equals(Std.parseInt("0xFFFFFFFF"), uint);
		Assert.isFalse((uint : Float) < 0);
		#else
		Assert.isOfType(uint, Int);
		Assert.equals(0xFFFFFFFF, uint);
		#end
	}

	public function testUIntComment1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:UInt id="uint">0xFFFFFFFF<!-- comment --></mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("uint"));
		var uint = idMap.get("uint");
		#if js
		Assert.isOfType(uint, Float);
		Assert.equals(Std.parseInt("0xFFFFFFFF"), uint);
		Assert.isFalse((uint : Float) < 0);
		#else
		Assert.isOfType(uint, Int);
		Assert.equals(0xFFFFFFFF, uint);
		#end
	}

	public function testUIntComment2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:UInt id="uint"><!-- comment -->0xFFFFFFFF</mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("uint"));
		var uint = idMap.get("uint");
		#if js
		Assert.isOfType(uint, Float);
		Assert.equals(Std.parseInt("0xFFFFFFFF"), uint);
		Assert.isFalse((uint : Float) < 0);
		#else
		Assert.isOfType(uint, Int);
		Assert.equals(0xFFFFFFFF, uint);
		#end
	}

	public function testUIntComment3():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:UInt id="uint">0xFFFFF<!-- comment -->FFF</mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("uint"));
		var uint = idMap.get("uint");
		#if js
		Assert.isOfType(uint, Float);
		Assert.equals(Std.parseInt("0xFFFFFFFF"), uint);
		Assert.isFalse((uint : Float) < 0);
		#else
		Assert.isOfType(uint, Int);
		Assert.equals(0xFFFFFFFF, uint);
		#end
	}

	public function testUIntEmpty():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:UInt id="uint"></mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("uint"));
		var uint = idMap.get("uint");
		#if js
		Assert.isOfType(uint, Float);
		#else
		Assert.isOfType(uint, Int);
		#end
		Assert.equals(0, uint);
	}

	public function testUIntEmptyExtraWhitespace():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:UInt id="uint">
					</mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("uint"));
		var uint = idMap.get("uint");
		#if js
		Assert.isOfType(uint, Float);
		#else
		Assert.isOfType(uint, Int);
		#end
		Assert.equals(0, uint);
	}

	public function testUIntEmptyOnlyComment1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:UInt id="uint"><!-- comment --></mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("uint"));
		var uint = idMap.get("uint");
		#if js
		Assert.isOfType(uint, Float);
		#else
		Assert.isOfType(uint, Int);
		#end
		Assert.equals(0, uint);
	}

	public function testUIntEmptyOnlyComment2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:UInt id="uint">
						<!-- comment -->
					</mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("uint"));
		var uint = idMap.get("uint");
		#if js
		Assert.isOfType(uint, Float);
		#else
		Assert.isOfType(uint, Int);
		#end
		Assert.equals(0, uint);
	}

	public function testUIntCData():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:UInt id="uint"><![CDATA[0xFFFFFFFF]]></mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("uint"));
		var uint = idMap.get("uint");
		#if js
		Assert.isOfType(uint, Float);
		Assert.equals(Std.parseInt("0xFFFFFFFF"), uint);
		Assert.isFalse((uint : Float) < 0);
		#else
		Assert.isOfType(uint, Int);
		Assert.equals(0xFFFFFFFF, uint);
		#end
	}

	public function testArray():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Array id="array">
						<mx:String>one</mx:String>
						<mx:String>two</mx:String>
						<mx:String>three</mx:String>
					</mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("array"));
		var array = Std.downcast((idMap.get("array") : Dynamic), Array);
		Assert.notNull(array);
		Assert.equals(3, array.length);
		Assert.equals("one", array[0]);
		Assert.equals("two", array[1]);
		Assert.equals("three", array[2]);
	}

	public function testArrayType():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Array id="array" type="String">
						<mx:String>one</mx:String>
						<mx:String>two</mx:String>
						<mx:String>three</mx:String>
					</mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("array"));
		var array = Std.downcast((idMap.get("array") : Dynamic), Array);
		Assert.notNull(array);
		Assert.equals(3, array.length);
		Assert.equals("one", array[0]);
		Assert.equals("two", array[1]);
		Assert.equals("three", array[2]);
	}

	public function testArrayComment1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Array id="array">
						<mx:String>one</mx:String>
						<mx:String>two</mx:String>
						<mx:String>three</mx:String>
						<!-- comment -->
					</mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("array"));
		var array = Std.downcast((idMap.get("array") : Dynamic), Array);
		Assert.notNull(array);
		Assert.equals(3, array.length);
		Assert.equals("one", array[0]);
		Assert.equals("two", array[1]);
		Assert.equals("three", array[2]);
	}

	public function testArrayComment2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Array id="array">
						<!-- comment -->
						<mx:String>one</mx:String>
						<mx:String>two</mx:String>
						<mx:String>three</mx:String>
					</mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("array"));
		var array = Std.downcast((idMap.get("array") : Dynamic), Array);
		Assert.notNull(array);
		Assert.equals(3, array.length);
		Assert.equals("one", array[0]);
		Assert.equals("two", array[1]);
		Assert.equals("three", array[2]);
	}

	public function testArrayComment3():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Array id="array">
						<mx:String>one</mx:String>
						<mx:String>two</mx:String>
						<!-- comment -->
						<mx:String>three</mx:String>
					</mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("array"));
		var array = Std.downcast((idMap.get("array") : Dynamic), Array);
		Assert.notNull(array);
		Assert.equals(3, array.length);
		Assert.equals("one", array[0]);
		Assert.equals("two", array[1]);
		Assert.equals("three", array[2]);
	}

	public function testArrayEmpty():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Array id="array"></mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("array"));
		var array = Std.downcast((idMap.get("array") : Dynamic), Array);
		Assert.notNull(array);
		Assert.equals(0, array.length);
	}

	public function testArrayEmptyExtraWhitespace():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Array id="array">
					</mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("array"));
		var array = Std.downcast((idMap.get("array") : Dynamic), Array);
		Assert.notNull(array);
		Assert.equals(0, array.length);
	}

	public function testArrayOnlyComment1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Array id="array"><!-- comment --></mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("array"));
		var array = Std.downcast((idMap.get("array") : Dynamic), Array);
		Assert.notNull(array);
		Assert.equals(0, array.length);
	}

	public function testArrayOnlyComment2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Array id="array">
						<!-- comment -->
					</mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("array"));
		var array = Std.downcast((idMap.get("array") : Dynamic), Array);
		Assert.notNull(array);
		Assert.equals(0, array.length);
	}

	public function testArrayStrictUnify():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Array id="array">
						<tests:TestPropertiesSubclass1/>
						<tests:TestPropertiesSubclass2/>
					</mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("array"));
		var array = Std.downcast((idMap.get("array") : Dynamic), Array);
		Assert.notNull(array);
		Assert.equals(2, array.length);
		Assert.isOfType(array[0], fixtures.TestPropertiesSubclass1);
		Assert.isOfType(array[1], fixtures.TestPropertiesSubclass2);
	}

	public function testArrayEmptyStrings():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Array id="array">
						<mx:String></mx:String>
						<mx:String/>
						<mx:String>
						</mx:String>
						<mx:String><![CDATA[]]></mx:String>
						<mx:String><![CDATA[ ]]></mx:String>
						<mx:String><![CDATA[   ]]></mx:String>
						<mx:String>
							<![CDATA[   ]]>
						</mx:String>
						<mx:String>
							<![CDATA[   ]]>
							<![CDATA[   ]]>
						</mx:String>
					</mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("array"));
		var array = Std.downcast((idMap.get("array") : Dynamic), Array);
		Assert.notNull(array);
		Assert.equals(8, array.length);
		// child of most elements: empty string, child of declarations: null
		Assert.equals("", array[0]);
		Assert.equals("", array[1]);
		Assert.equals("", array[2]);
		Assert.equals("", array[3]);
		Assert.equals(" ", array[4]);
		Assert.equals("   ", array[5]);
		Assert.equals("   ", array[6]);
		Assert.equals("      ", array[7]);
	}

	public function testXmlEmpty():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("xml"));
		var xml = Std.downcast((idMap.get("xml") : Dynamic), Xml);
		Assert.notNull(xml);
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstChild:Xml = xml.firstChild();
		Assert.notNull(firstChild);
		Assert.equals(XmlType.PCData, firstChild.nodeType);
		Assert.equals("", firstChild.nodeValue);
		Assert.isNull(xml.firstElement());
	}

	public function testXmlElement():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element/></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("xml"));
		var xml = Std.downcast((idMap.get("xml") : Dynamic), Xml);
		Assert.notNull(xml);
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstElement:Xml = xml.firstChild();
		Assert.notNull(firstElement);
		Assert.equals(XmlType.Element, firstElement.nodeType);
		Assert.equals("element", firstElement.nodeName);
		Assert.isFalse(firstElement.attributes().hasNext());
		Assert.isFalse(firstElement.elements().hasNext());
		Assert.isNull(firstElement.firstChild());
		Assert.isNull(firstElement.firstElement());
	}

	public function testXmlElementWithAttribute():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element attr="value"/></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("xml"));
		var xml = Std.downcast((idMap.get("xml") : Dynamic), Xml);
		Assert.notNull(xml);
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstElement:Xml = xml.firstChild();
		Assert.notNull(firstElement);
		Assert.equals(XmlType.Element, firstElement.nodeType);
		Assert.equals("element", firstElement.nodeName);
		var attributes = firstElement.attributes();
		Assert.isTrue(attributes.hasNext());
		attributes.next();
		Assert.isFalse(attributes.hasNext());
		Assert.isTrue(firstElement.exists("attr"));
		Assert.equals("value", firstElement.get("attr"));
		Assert.isFalse(firstElement.elements().hasNext());
		Assert.isNull(firstElement.firstChild());
		Assert.isNull(firstElement.firstElement());
	}

	public function testXmlElementWithMultipleAttributes():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element attr1="value1" attr2="value2"/></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("xml"));
		var xml = Std.downcast((idMap.get("xml") : Dynamic), Xml);
		Assert.notNull(xml);
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstElement:Xml = xml.firstChild();
		Assert.notNull(firstElement);
		Assert.equals(XmlType.Element, firstElement.nodeType);
		Assert.equals("element", firstElement.nodeName);
		var attributes = firstElement.attributes();
		Assert.isTrue(attributes.hasNext());
		attributes.next();
		Assert.isTrue(attributes.hasNext());
		attributes.next();
		Assert.isFalse(attributes.hasNext());
		Assert.isTrue(firstElement.exists("attr1"));
		Assert.equals("value1", firstElement.get("attr1"));
		Assert.isTrue(firstElement.exists("attr2"));
		Assert.equals("value2", firstElement.get("attr2"));
		Assert.isFalse(firstElement.elements().hasNext());
		Assert.isNull(firstElement.firstChild());
		Assert.isNull(firstElement.firstElement());
	}

	public function testXmlOpenCloseElement():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element></element></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("xml"));
		var xml = Std.downcast((idMap.get("xml") : Dynamic), Xml);
		Assert.notNull(xml);
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstElement:Xml = xml.firstChild();
		Assert.notNull(firstElement);
		Assert.equals(XmlType.Element, firstElement.nodeType);
		Assert.equals("element", firstElement.nodeName);
		Assert.isFalse(firstElement.attributes().hasNext());
		Assert.isFalse(firstElement.elements().hasNext());
		Assert.isNull(firstElement.firstChild());
		Assert.isNull(firstElement.firstElement());
	}

	public function testXmlElementChild():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element><child/></element></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("xml"));
		var xml = Std.downcast((idMap.get("xml") : Dynamic), Xml);
		Assert.notNull(xml);
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstElement:Xml = xml.firstChild();
		Assert.notNull(firstElement);
		Assert.equals(XmlType.Element, firstElement.nodeType);
		Assert.equals("element", firstElement.nodeName);
		Assert.isFalse(firstElement.attributes().hasNext());
		var elements = firstElement.elements();
		Assert.isTrue(elements.hasNext());
		elements.next();
		Assert.isFalse(elements.hasNext());
		var firstChild = firstElement.firstChild();
		Assert.notNull(firstChild);
		var firstChildElement = firstElement.firstElement();
		Assert.notNull(firstChildElement);
		Assert.equals(XmlType.Element, firstChildElement.nodeType);
		Assert.equals("child", firstChildElement.nodeName);
	}

	public function testXmlElementMultipleChildren():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element><child1/><child2></child2></element></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("xml"));
		var xml = Std.downcast((idMap.get("xml") : Dynamic), Xml);
		Assert.notNull(xml);
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstElement:Xml = xml.firstChild();
		Assert.notNull(firstElement);
		Assert.equals(XmlType.Element, firstElement.nodeType);
		Assert.equals("element", firstElement.nodeName);
		Assert.isFalse(firstElement.attributes().hasNext());
		var elements = firstElement.elements();
		Assert.isTrue(elements.hasNext());
		var firstChildElement = elements.next();
		Assert.isTrue(elements.hasNext());
		var secondChildElement = elements.next();
		Assert.isFalse(elements.hasNext());
		Assert.notNull(firstElement.firstChild());
		Assert.notNull(firstElement.firstElement());

		Assert.notNull(firstChildElement);
		Assert.equals(XmlType.Element, firstChildElement.nodeType);
		Assert.equals("child1", firstChildElement.nodeName);

		Assert.notNull(secondChildElement);
		Assert.equals(XmlType.Element, secondChildElement.nodeType);
		Assert.equals("child2", secondChildElement.nodeName);
	}

	public function testXmlChildElementComplex():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element><child1><gchild/></child1><child2/></element></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("xml"));
		var xml = Std.downcast((idMap.get("xml") : Dynamic), Xml);
		Assert.notNull(xml);
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstElement:Xml = xml.firstChild();
		Assert.notNull(firstElement);
		Assert.equals(XmlType.Element, firstElement.nodeType);
		Assert.equals("element", firstElement.nodeName);
		Assert.isFalse(firstElement.attributes().hasNext());

		var elements = firstElement.elements();
		Assert.isTrue(elements.hasNext());
		var firstChildElement = elements.next();
		Assert.isTrue(elements.hasNext());
		var secondChildElement = elements.next();
		Assert.isFalse(elements.hasNext());
		Assert.notNull(firstElement.firstChild());
		Assert.notNull(firstElement.firstElement());

		Assert.notNull(firstChildElement);
		Assert.equals(XmlType.Element, firstChildElement.nodeType);
		Assert.equals("child1", firstChildElement.nodeName);

		Assert.notNull(secondChildElement);
		Assert.equals(XmlType.Element, secondChildElement.nodeType);
		Assert.equals("child2", secondChildElement.nodeName);

		var gchild = firstChildElement.firstElement();
		Assert.notNull(gchild);
		Assert.equals(XmlType.Element, gchild.nodeType);
		Assert.equals("gchild", gchild.nodeName);
	}

	public function testXmlText():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml">this is text</mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("xml"));
		var xml = Std.downcast((idMap.get("xml") : Dynamic), Xml);
		Assert.notNull(xml);
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstChild:Xml = xml.firstChild();
		Assert.notNull(firstChild);
		Assert.equals(XmlType.PCData, firstChild.nodeType);
		Assert.equals("this is text", firstChild.nodeValue);
		Assert.isNull(xml.firstElement());
	}

	public function testXmlTextChild():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element>this is text</element></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("xml"));
		var xml = Std.downcast((idMap.get("xml") : Dynamic), Xml);
		Assert.notNull(xml);
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstElement:Xml = xml.firstChild();
		Assert.notNull(firstElement);
		Assert.equals(XmlType.Element, firstElement.nodeType);
		Assert.equals("element", firstElement.nodeName);
		Assert.isFalse(firstElement.attributes().hasNext());
		Assert.isFalse(firstElement.elements().hasNext());
		var children = firstElement.iterator();
		Assert.isTrue(children.hasNext());
		var firstChild = children.next();
		Assert.isFalse(children.hasNext());
		Assert.notNull(firstChild);
		Assert.equals(XmlType.PCData, firstChild.nodeType);
		Assert.equals("this is text", firstChild.nodeValue);
	}

	public function testXmlCData():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><![CDATA[this is cdata]]></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("xml"));
		var xml = Std.downcast((idMap.get("xml") : Dynamic), Xml);
		Assert.notNull(xml);
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstChild:Xml = xml.firstChild();
		Assert.notNull(firstChild);
		Assert.equals(XmlType.CData, firstChild.nodeType);
		Assert.equals("this is cdata", firstChild.nodeValue);
		Assert.isNull(xml.firstElement());
	}

	public function testXmlCDataChild():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element><![CDATA[this is cdata]]></element></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("xml"));
		var xml = Std.downcast((idMap.get("xml") : Dynamic), Xml);
		Assert.notNull(xml);
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstElement:Xml = xml.firstChild();
		Assert.notNull(firstElement);
		Assert.equals(XmlType.Element, firstElement.nodeType);
		Assert.equals("element", firstElement.nodeName);
		Assert.isFalse(firstElement.attributes().hasNext());
		Assert.isFalse(firstElement.elements().hasNext());
		var children = firstElement.iterator();
		Assert.isTrue(children.hasNext());
		var firstChild = children.next();
		Assert.isFalse(children.hasNext());
		Assert.notNull(firstChild);
		Assert.equals(XmlType.CData, firstChild.nodeType);
		Assert.equals("this is cdata", firstChild.nodeValue);
	}

	public function testXmlComment():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><!-- comment --></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("xml"));
		var xml = Std.downcast((idMap.get("xml") : Dynamic), Xml);
		Assert.notNull(xml);
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstChild:Xml = xml.firstChild();
		Assert.notNull(firstChild);
		Assert.equals(XmlType.Comment, firstChild.nodeType);
		Assert.equals(" comment ", firstChild.nodeValue);
		Assert.isNull(xml.firstElement());
	}

	public function testXmlCommentChild():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element><!-- comment --></element></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("xml"));
		var xml = Std.downcast((idMap.get("xml") : Dynamic), Xml);
		Assert.notNull(xml);
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstElement:Xml = xml.firstChild();
		Assert.notNull(firstElement);
		Assert.equals(XmlType.Element, firstElement.nodeType);
		Assert.equals("element", firstElement.nodeName);
		Assert.isFalse(firstElement.attributes().hasNext());
		Assert.isFalse(firstElement.elements().hasNext());
		var children = firstElement.iterator();
		Assert.isTrue(children.hasNext());
		var firstChild = children.next();
		Assert.isFalse(children.hasNext());
		Assert.notNull(firstChild);
		Assert.equals(XmlType.Comment, firstChild.nodeType);
		Assert.equals(" comment ", firstChild.nodeValue);
	}

	public function testXmlSource():Void {
		Assert.raises(() -> MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml" source="source.xml"/>
				</mx:Declarations>
			</tests:TestClass1>
		'), MXHXRuntimeComponentException);
	}

	public function testComplexEnumValueWithoutParameters():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestComplexEnum id="enumValue">
						<tests:TestComplexEnum.One/>
					</tests:TestComplexEnum>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("enumValue"));
		var enumValue = idMap.get("enumValue");
		Assert.equals(TestComplexEnum.One, enumValue);
	}

	// TODO: complex enum value with parameters
	// Haxe doesn't include RTTI data for enums!
	// public function testComplexEnumValueWithParameters():Void {
	// 	var idMap:Map<String, Any> = [];
	// 	var result = MXHXRuntimeComponent.withMarkup('
	// 		<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
	// 			<mx:Declarations>
	// 				<tests:TestComplexEnum id="enumValue">
	// 					<tests:TestComplexEnum.Two a="hello" b="123.4"/>
	// 				</tests:TestComplexEnum>
	// 			</mx:Declarations>
	// 		</tests:TestClass1>
	// 	', idMap);
	// 	Assert.notNull(result);
	// 	Assert.isOfType(result, TestClass1);
	// 	Assert.isTrue(idMap.exists("enumValue"));
	// 	var enumValue:TestComplexEnum = idMap.get("enumValue");
	// 	switch (enumValue) {
	// 		case TestComplexEnum.Two("hello", 123.4):
	// 			Assert.pass();
	// 		default:
	// 			Assert.fail("Wrong enum value: " + enumValue);
	// 	}
	// }

	public function testDateNoFields():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date"/>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		var now = Date.now();
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("date"));
		var date = Std.downcast((idMap.get("date") : Dynamic), Date);
		Assert.notNull(date);
		var difference = now.getTime() - date.getTime();
		Assert.isTrue(difference < 1000.0);
	}

	public function testDateFullYearAttribute():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date" fullYear="2008"/>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		var now = Date.now();
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("date"));
		var date = Std.downcast((idMap.get("date") : Dynamic), Date);
		Assert.notNull(date);
		Assert.equals(2008, date.getFullYear());
	}

	public function testDateMonthAttribute():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date" month="4"/>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		var now = Date.now();
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("date"));
		var date = Std.downcast((idMap.get("date") : Dynamic), Date);
		Assert.notNull(date);
		Assert.equals(4, date.getMonth());
	}

	public function testDateDateAttribute():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date" date="25"/>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		var now = Date.now();
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("date"));
		var date = Std.downcast((idMap.get("date") : Dynamic), Date);
		Assert.notNull(date);
		Assert.equals(25, date.getDate());
	}

	public function testDateHoursAttribute():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date" hours="3"/>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		var now = Date.now();
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("date"));
		var date = Std.downcast((idMap.get("date") : Dynamic), Date);
		Assert.notNull(date);
		Assert.equals(3, date.getHours());
	}

	public function testDateMinutesAttribute():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date" minutes="47"/>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		var now = Date.now();
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("date"));
		var date = Std.downcast((idMap.get("date") : Dynamic), Date);
		Assert.notNull(date);
		Assert.equals(47, date.getMinutes());
	}

	public function testDateSecondsAttribute():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date" seconds="51"/>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		var now = Date.now();
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("date"));
		var date = Std.downcast((idMap.get("date") : Dynamic), Date);
		Assert.notNull(date);
		Assert.equals(51, date.getSeconds());
	}

	public function testDateFullYearChildElement():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date">
						<mx:fullYear>2008</mx:fullYear>
					</mx:Date>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		var now = Date.now();
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("date"));
		var date = Std.downcast((idMap.get("date") : Dynamic), Date);
		Assert.notNull(date);
		Assert.equals(2008, date.getFullYear());
	}

	public function testDateMonthChildElement():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date">
						<mx:month>4</mx:month>
					</mx:Date>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		var now = Date.now();
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("date"));
		var date = Std.downcast((idMap.get("date") : Dynamic), Date);
		Assert.notNull(date);
		Assert.equals(4, date.getMonth());
	}

	public function testDateDateChildElement():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date">
						<mx:date>25</mx:date>
					</mx:Date>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		var now = Date.now();
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("date"));
		var date = Std.downcast((idMap.get("date") : Dynamic), Date);
		Assert.notNull(date);
		Assert.equals(25, date.getDate());
	}

	public function testDateHoursChildElement():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date">
						<mx:hours>3</mx:hours>
					</mx:Date>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		var now = Date.now();
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("date"));
		var date = Std.downcast((idMap.get("date") : Dynamic), Date);
		Assert.notNull(date);
		Assert.equals(3, date.getHours());
	}

	public function testDateMinutesChildElement():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date">
						<mx:minutes>47</mx:minutes>
					</mx:Date>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		var now = Date.now();
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("date"));
		var date = Std.downcast((idMap.get("date") : Dynamic), Date);
		Assert.notNull(date);
		Assert.equals(47, date.getMinutes());
	}

	public function testDateSecondsChildElement():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date">
						<mx:seconds>51</mx:seconds>
					</mx:Date>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		var now = Date.now();
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("date"));
		var date = Std.downcast((idMap.get("date") : Dynamic), Date);
		Assert.notNull(date);
		Assert.equals(51, date.getSeconds());
	}

	public function testDateMixedAttributesAndChildElements():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date" fullYear="2008" date="25" minutes="47">
						<mx:month>4</mx:month>
						<mx:hours>3</mx:hours>
						<mx:seconds>51</mx:seconds>
					</mx:Date>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		var now = Date.now();
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("date"));
		var date = Std.downcast((idMap.get("date") : Dynamic), Date);
		Assert.notNull(date);
		Assert.equals(2008, date.getFullYear());
		Assert.equals(4, date.getMonth());
		Assert.equals(25, date.getDate());
		Assert.equals(3, date.getHours());
		Assert.equals(47, date.getMinutes());
		Assert.equals(51, date.getSeconds());
	}

	public function testMultipleDeclarationsTags():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">123.4</mx:Float>
				</mx:Declarations>
				<mx:Declarations>
					<mx:String id="string">hello</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("float"));
		var float = idMap.get("float");
		Assert.isTrue(idMap.exists("string"));
		var string = idMap.get("string");
		Assert.equals(123.4, float);
		Assert.equals("hello", string);
	}

	public function testFunction():Void {
		Assert.raises(() -> MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Function id="func">testMethod</mx:Function>
				</mx:Declarations>
			</tests:TestClass1>
		'), MXHXRuntimeComponentException);
	}
}
