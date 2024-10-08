package mxhx.macros;

import Xml.XmlType;
import fixtures.TestClass1;
import fixtures.TestComplexEnum;
import fixtures.TestPropertyAbstractEnum;
import fixtures.TestPropertyEnum;
import utest.Assert;
import utest.Test;

class MXHXComponentDeclarationsTest extends Test {
	public function testDeclarationsEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations></mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
	}

	public function testDeclarationsEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
	}

	public function testDeclarationsComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations><!-- comment --></mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
	}

	public function testDeclarationsComment2():Void {
		var result = MXHXComponent.withMarkup('
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
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations><!--- doc comment --></mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
	}

	public function testDeclarationsDocComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<!--- doc comment -->
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
	}

	public function testStructAttributes():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Struct id="struct" float="123.4" float_hex="0xbeef" nan="NaN"
						infinity="Infinity" negative_infinity="-Infinity" float_exponent="123.4e5"
						boolean_true="true" boolean_false="false" string="hello"/>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.notNull(result.struct);
		Assert.equals(9, Reflect.fields(result.struct).length);
		Assert.isTrue(Reflect.hasField(result.struct, "float"));
		Assert.isTrue(Reflect.hasField(result.struct, "float_hex"));
		Assert.isTrue(Reflect.hasField(result.struct, "nan"));
		Assert.isTrue(Reflect.hasField(result.struct, "infinity"));
		Assert.isTrue(Reflect.hasField(result.struct, "negative_infinity"));
		Assert.isTrue(Reflect.hasField(result.struct, "float_exponent"));
		Assert.isTrue(Reflect.hasField(result.struct, "boolean_true"));
		Assert.isTrue(Reflect.hasField(result.struct, "boolean_false"));
		Assert.isTrue(Reflect.hasField(result.struct, "string"));
		Assert.equals(123.4, Reflect.field(result.struct, "float"));
		Assert.equals(0xbeef, Reflect.field(result.struct, "float_hex"));
		Assert.isTrue(Math.isNaN(Reflect.field(result.struct, "nan")));
		Assert.equals(Math.POSITIVE_INFINITY, Reflect.field(result.struct, "infinity"));
		Assert.equals(Math.NEGATIVE_INFINITY, Reflect.field(result.struct, "negative_infinity"));
		Assert.equals(123.4e5, Reflect.field(result.struct, "float_exponent"));
		Assert.isTrue(Reflect.field(result.struct, "boolean_true"));
		Assert.isFalse(Reflect.field(result.struct, "boolean_false"));
		Assert.equals("hello", Reflect.field(result.struct, "string"));
	}

	public function testStructAttributesExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Struct id="struct" float=" 123.4 " float_hex=" 0xbeef " nan=" NaN "
						infinity=" Infinity " negative_infinity=" -Infinity " float_exponent=" 123.4e5 "
						boolean_true=" true " boolean_false=" false " string=" hello "/>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.notNull(result.struct);
		Assert.equals(9, Reflect.fields(result.struct).length);
		Assert.isTrue(Reflect.hasField(result.struct, "float"));
		Assert.isTrue(Reflect.hasField(result.struct, "float_hex"));
		Assert.isTrue(Reflect.hasField(result.struct, "nan"));
		Assert.isTrue(Reflect.hasField(result.struct, "infinity"));
		Assert.isTrue(Reflect.hasField(result.struct, "negative_infinity"));
		Assert.isTrue(Reflect.hasField(result.struct, "float_exponent"));
		Assert.isTrue(Reflect.hasField(result.struct, "boolean_true"));
		Assert.isTrue(Reflect.hasField(result.struct, "boolean_false"));
		Assert.isTrue(Reflect.hasField(result.struct, "string"));
		Assert.equals(123.4, Reflect.field(result.struct, "float"));
		Assert.equals(0xbeef, Reflect.field(result.struct, "float_hex"));
		Assert.isTrue(Math.isNaN(Reflect.field(result.struct, "nan")));
		Assert.equals(Math.POSITIVE_INFINITY, Reflect.field(result.struct, "infinity"));
		Assert.equals(Math.NEGATIVE_INFINITY, Reflect.field(result.struct, "negative_infinity"));
		Assert.equals(123.4e5, Reflect.field(result.struct, "float_exponent"));
		Assert.isTrue(Reflect.field(result.struct, "boolean_true"));
		Assert.isFalse(Reflect.field(result.struct, "boolean_false"));
		Assert.equals(" hello ", Reflect.field(result.struct, "string"));
	}

	public function testStructChildElements():Void {
		var result = MXHXComponent.withMarkup('
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
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.notNull(result.struct);
		Assert.equals(10, Reflect.fields(result.struct).length);
		Assert.isTrue(Reflect.hasField(result.struct, "float"));
		Assert.isTrue(Reflect.hasField(result.struct, "float_hex"));
		Assert.isTrue(Reflect.hasField(result.struct, "nan"));
		Assert.isTrue(Reflect.hasField(result.struct, "infinity"));
		Assert.isTrue(Reflect.hasField(result.struct, "negative_infinity"));
		Assert.isTrue(Reflect.hasField(result.struct, "float_exponent"));
		Assert.isTrue(Reflect.hasField(result.struct, "boolean_true"));
		Assert.isTrue(Reflect.hasField(result.struct, "boolean_false"));
		Assert.isTrue(Reflect.hasField(result.struct, "string"));
		Assert.isTrue(Reflect.hasField(result.struct, "object"));
		Assert.equals(123.4, Reflect.field(result.struct, "float"));
		Assert.equals(0xbeef, Reflect.field(result.struct, "float_hex"));
		Assert.isTrue(Math.isNaN(Reflect.field(result.struct, "nan")));
		Assert.equals(Math.POSITIVE_INFINITY, Reflect.field(result.struct, "infinity"));
		Assert.equals(Math.NEGATIVE_INFINITY, Reflect.field(result.struct, "negative_infinity"));
		Assert.equals(123.4e5, Reflect.field(result.struct, "float_exponent"));
		Assert.isTrue(Reflect.field(result.struct, "boolean_true"));
		Assert.isFalse(Reflect.field(result.struct, "boolean_false"));
		Assert.equals("hello", Reflect.field(result.struct, "string"));
		Assert.notNull(Reflect.field(result.struct, "object"));
		Assert.equals(567, Reflect.field(Reflect.field(result.struct, "object"), "integer"));
	}

	public function testStructChildElementsExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
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
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.notNull(result.struct);
		Assert.equals(10, Reflect.fields(result.struct).length);
		Assert.isTrue(Reflect.hasField(result.struct, "float"));
		Assert.isTrue(Reflect.hasField(result.struct, "float_hex"));
		Assert.isTrue(Reflect.hasField(result.struct, "nan"));
		Assert.isTrue(Reflect.hasField(result.struct, "infinity"));
		Assert.isTrue(Reflect.hasField(result.struct, "negative_infinity"));
		Assert.isTrue(Reflect.hasField(result.struct, "float_exponent"));
		Assert.isTrue(Reflect.hasField(result.struct, "boolean_true"));
		Assert.isTrue(Reflect.hasField(result.struct, "boolean_false"));
		Assert.isTrue(Reflect.hasField(result.struct, "string"));
		Assert.isTrue(Reflect.hasField(result.struct, "object"));
		Assert.equals(123.4, Reflect.field(result.struct, "float"));
		Assert.equals(0xbeef, Reflect.field(result.struct, "float_hex"));
		Assert.isTrue(Math.isNaN(Reflect.field(result.struct, "nan")));
		Assert.equals(Math.POSITIVE_INFINITY, Reflect.field(result.struct, "infinity"));
		Assert.equals(Math.NEGATIVE_INFINITY, Reflect.field(result.struct, "negative_infinity"));
		Assert.equals(123.4e5, Reflect.field(result.struct, "float_exponent"));
		Assert.isTrue(Reflect.field(result.struct, "boolean_true"));
		Assert.isFalse(Reflect.field(result.struct, "boolean_false"));
		Assert.equals(" hello ", Reflect.field(result.struct, "string"));
		Assert.notNull(Reflect.field(result.struct, "object"));
		Assert.equals(567, Reflect.field(Reflect.field(result.struct, "object"), "integer"));
	}

	public function testStructEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Struct id="struct"></mx:Struct>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.notNull(result.struct);
		Assert.equals(0, Reflect.fields(result.struct).length);
	}

	public function testStructEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Struct id="struct">
					</mx:Struct>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.notNull(result.struct);
		Assert.equals(0, Reflect.fields(result.struct).length);
	}

	public function testStructOnlyComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Struct id="struct"><!-- comment --></mx:Struct>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.notNull(result.struct);
		Assert.equals(0, Reflect.fields(result.struct).length);
	}

	public function testStructOnlyComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Struct id="struct">
						<!-- comment -->
					</mx:Struct>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.notNull(result.struct);
		Assert.equals(0, Reflect.fields(result.struct).length);
	}

	public function testStructOnlyDocComment():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Struct id="struct">
						<!--- comment -->
					</mx:Struct>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.notNull(result.struct);
		Assert.equals(0, Reflect.fields(result.struct).length);
	}

	public function testStrict():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertiesClass
						id="strictlyTyped"
						boolean="true"
						float="123.4"
						integer="567"
						string="hello"
						canBeNull="890.1">
						<tests:dyn>
							<mx:Struct float="123.4" boolean="true" string="hello">
								<mx:object>
									<mx:Struct>
										<mx:integer>567</mx:integer>
									</mx:Struct>
								</mx:object>
							</mx:Struct>
						</tests:dyn>
					</tests:TestPropertiesClass>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.notNull(result.strictlyTyped);
		Assert.isTrue(result.strictlyTyped.boolean);
		Assert.equals(123.4, result.strictlyTyped.float);
		Assert.equals("hello", result.strictlyTyped.string);
		Assert.equals(567, result.strictlyTyped.integer);
		Assert.equals(890.1, result.strictlyTyped.canBeNull);
		Assert.notNull(result.strictlyTyped.dyn);
		Assert.equals(4, Reflect.fields(result.strictlyTyped.dyn).length);
		Assert.isTrue(Reflect.hasField(result.strictlyTyped.dyn, "float"));
		Assert.isTrue(Reflect.hasField(result.strictlyTyped.dyn, "boolean"));
		Assert.isTrue(Reflect.hasField(result.strictlyTyped.dyn, "string"));
		Assert.isTrue(Reflect.hasField(result.strictlyTyped.dyn, "object"));
		Assert.equals(123.4, Reflect.field(result.strictlyTyped.dyn, "float"));
		Assert.isTrue(Reflect.field(result.strictlyTyped.dyn, "boolean"));
		Assert.equals("hello", Reflect.field(result.strictlyTyped.dyn, "string"));
		Assert.notNull(Reflect.field(result.strictlyTyped.dyn, "object"));
		Assert.equals(567, Reflect.field(Reflect.field(result.strictlyTyped.dyn, "object"), "integer"));
	}

	public function testStrictExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
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
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.notNull(result.strictlyTyped);
		Assert.isTrue(result.strictlyTyped.boolean);
		Assert.equals(123.4, result.strictlyTyped.float);
		Assert.equals(" hello ", result.strictlyTyped.string);
		Assert.equals(567, result.strictlyTyped.integer);
		Assert.equals(890.1, result.strictlyTyped.canBeNull);
	}

	public function testAbstractEnumValue():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertyAbstractEnum id="enumValue">Value2</tests:TestPropertyAbstractEnum>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.equals(TestPropertyAbstractEnum.Value2, result.enumValue);
	}

	public function testAbstractEnumValueExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertyAbstractEnum id="enumValue">
						Value2
					</tests:TestPropertyAbstractEnum>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.equals(TestPropertyAbstractEnum.Value2, result.enumValue);
	}

	public function testAbstractEnumValueComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertyAbstractEnum id="enumValue">Value2<!-- comment --></tests:TestPropertyAbstractEnum>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.equals(TestPropertyAbstractEnum.Value2, result.enumValue);
	}

	public function testAbstractEnumValueComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertyAbstractEnum id="enumValue"><!-- comment -->Value2</tests:TestPropertyAbstractEnum>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.equals(TestPropertyAbstractEnum.Value2, result.enumValue);
	}

	public function testAbstractEnumValueComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertyAbstractEnum id="enumValue">Val<!-- comment -->ue2</tests:TestPropertyAbstractEnum>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.equals(TestPropertyAbstractEnum.Value2, result.enumValue);
	}

	public function testAbstractEnumValueCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertyAbstractEnum id="enumValue"><![CDATA[Value2]]></tests:TestPropertyAbstractEnum>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.equals(TestPropertyAbstractEnum.Value2, result.enumValue);
	}

	public function testEnumValue():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertyEnum id="enumValue">Value2</tests:TestPropertyEnum>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.equals(TestPropertyEnum.Value2, result.enumValue);
	}

	public function testEnumValueExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertyEnum id="enumValue">
						Value2
					</tests:TestPropertyEnum>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.equals(TestPropertyEnum.Value2, result.enumValue);
	}

	public function testEnumValueComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertyEnum id="enumValue">Value2<!-- comment --></tests:TestPropertyEnum>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.equals(TestPropertyEnum.Value2, result.enumValue);
	}

	public function testEnumValueComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertyEnum id="enumValue"><!-- comment -->Value2</tests:TestPropertyEnum>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.equals(TestPropertyEnum.Value2, result.enumValue);
	}

	public function testEnumValueComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertyEnum id="enumValue">Val<!-- comment -->ue2</tests:TestPropertyEnum>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.equals(TestPropertyEnum.Value2, result.enumValue);
	}

	public function testEnumValueCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertyEnum id="enumValue"><![CDATA[Value2]]></tests:TestPropertyEnum>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.equals(TestPropertyEnum.Value2, result.enumValue);
	}

	public function testEReg():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:EReg id="ereg">~/[a-z]+/g</mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.ereg, EReg);
		#if interp
		Assert.equals("~/[a-z]+/g", Std.string(result.ereg));
		#end
	}

	public function testERegExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:EReg id="ereg">
						~/[a-z]+/g
					</mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.ereg, EReg);
		#if interp
		Assert.equals("~/[a-z]+/g", Std.string(result.ereg));
		#end
	}

	public function testERegComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:EReg id="ereg">~/[a-z]+/g<!-- comment --></mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.ereg, EReg);
		#if interp
		Assert.equals("~/[a-z]+/g", Std.string(result.ereg));
		#end
	}

	public function testERegComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:EReg id="ereg"><!-- comment -->~/[a-z]+/g</mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.ereg, EReg);
		#if interp
		Assert.equals("~/[a-z]+/g", Std.string(result.ereg));
		#end
	}

	public function testERegEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:EReg id="ereg"></mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.ereg, EReg);
		#if interp
		Assert.equals("~//", Std.string(result.ereg));
		#end
	}

	public function testERegEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:EReg id="ereg">
					</mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.ereg, EReg);
		#if interp
		Assert.equals("~//", Std.string(result.ereg));
		#end
	}

	public function testERegOnlyComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:EReg id="ereg"><!-- comment --></mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.ereg, EReg);
		#if interp
		Assert.equals("~//", Std.string(result.ereg));
		#end
	}

	public function testERegOnlyComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:EReg id="ereg">
						<!-- comment -->
					</mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.ereg, EReg);
		#if interp
		Assert.equals("~//", Std.string(result.ereg));
		#end
	}

	public function testERegOnlyDocComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:EReg id="ereg"><!--- doc comment --></mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.ereg, EReg);
		#if interp
		Assert.equals("~//", Std.string(result.ereg));
		#end
	}

	public function testERegOnlyDocComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:EReg id="ereg">
						<!--- doc comment -->
					</mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.ereg, EReg);
		#if interp
		Assert.equals("~//", Std.string(result.ereg));
		#end
	}

	public function testERegNoExpression():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:EReg id="ereg">~//</mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.ereg, EReg);
		#if interp
		Assert.equals("~//", Std.string(result.ereg));
		#end
	}

	public function testERegCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:EReg id="ereg"><![CDATA[~/[a-z]+/g]]></mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.ereg, EReg);
		#if interp
		Assert.equals("~/[a-z]+/g", Std.string(result.ereg));
		#end
	}

	public function testFloat():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">123.4</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4, result.float);
	}

	public function testFloatExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">
						123.4
					</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4, result.float);
	}

	public function testFloatComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">123.4<!-- comment --></mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4, result.float);
	}

	public function testFloatComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float"><!-- comment -->123.4</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4, result.float);
	}

	public function testFloatComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">12<!-- comment -->3.4</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4, result.float);
	}

	public function testFloatEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float"></mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.float, Float);
		Assert.isTrue(Math.isNaN(result.float));
	}

	public function testFloatEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">
					</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.float, Float);
		Assert.isTrue(Math.isNaN(result.float));
	}

	public function testFloatOnlyComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float"><!-- comment --></mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.float, Float);
		Assert.isTrue(Math.isNaN(result.float));
	}

	public function testFloatOnlyComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">
						<!-- comment -->
					</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.float, Float);
		Assert.isTrue(Math.isNaN(result.float));
	}

	public function testFloatOnlyDocComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float"><!--- comment --></mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.float, Float);
		Assert.isTrue(Math.isNaN(result.float));
	}

	public function testFloatOnlyDocComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">
						<!--- doc comment -->
					</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.float, Float);
		Assert.isTrue(Math.isNaN(result.float));
	}

	public function testFloatNegative():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">-123.4</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.float, Float);
		Assert.equals(-123.4, result.float);
	}

	public function testFloatInt():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">456</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.float, Float);
		Assert.equals(456, result.float);
	}

	public function testFloatIntNegative():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">-456</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.float, Float);
		Assert.equals(-456, result.float);
	}

	public function testFloatHexLowerCase():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">0xbeef</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.float, Float);
		Assert.equals(0xbeef, result.float);
	}

	public function testFloatHexUpperCase():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">0xBEEF</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.float, Float);
		Assert.equals(0xbeef, result.float);
	}

	public function testFloatHexMixedCase():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">0xbEeF</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.float, Float);
		Assert.equals(0xbeef, result.float);
	}

	public function testFloatHexNegative():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">-0xbeef</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.float, Float);
		Assert.equals(-0xbeef, result.float);
	}

	public function testFloatExponent():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">123.4e5</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4e5, result.float);
	}

	public function testFloatNegativeExponent():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">123.4e-5</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4e-5, result.float);
	}

	public function testFloatNaN():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">NaN</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.float, Float);
		Assert.isTrue(Math.isNaN(result.float));
	}

	public function testFloatInfinity():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">Infinity</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.float, Float);
		Assert.equals(Math.POSITIVE_INFINITY, result.float);
	}

	public function testFloatNegativeInfinity():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">-Infinity</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.float, Float);
		Assert.equals(Math.NEGATIVE_INFINITY, result.float);
	}

	public function testFloatCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float"><![CDATA[123.4]]></mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4, result.float);
	}

	public function testBool():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Bool id="boolean">true</mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.boolean, Bool);
		Assert.isTrue(result.boolean);
	}

	public function testBoolExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Bool id="boolean">
						true
					</mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.boolean, Bool);
		Assert.isTrue(result.boolean);
	}

	public function testBoolComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Bool id="boolean">true<!-- comment --></mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.boolean, Bool);
		Assert.isTrue(result.boolean);
	}

	public function testBoolComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Bool id="boolean"><!-- comment -->true</mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isTrue(result.boolean);
	}

	public function testBoolComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Bool id="boolean">tr<!-- comment -->ue</mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.boolean, Bool);
		Assert.isTrue(result.boolean);
	}

	public function testBoolEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Bool id="boolean"></mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.boolean, Bool);
		Assert.isFalse(result.boolean);
	}

	public function testBoolEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Bool id="boolean">
					</mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isFalse(result.boolean);
	}

	public function testBoolOnlyComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Bool id="boolean"><!-- comment --></mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.boolean, Bool);
		Assert.isFalse(result.boolean);
	}

	public function testBoolOnlyComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Bool id="boolean">
						<!-- comment -->
					</mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.boolean, Bool);
		Assert.isFalse(result.boolean);
	}

	public function testBoolCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Bool id="boolean"><![CDATA[true]]></mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.boolean, Bool);
		Assert.isTrue(result.boolean);
	}

	public function testClass():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Class id="type">fixtures.TestClass1</mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.type, Class);
		Assert.equals(fixtures.TestClass1, result.type);
	}

	public function testClassExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Class id="type">
						fixtures.TestClass1
					</mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.type, Class);
		Assert.equals(fixtures.TestClass1, result.type);
	}

	public function testClassComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Class id="type">fixtures.TestClass1<!-- comment --></mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.type, Class);
		Assert.equals(fixtures.TestClass1, result.type);
	}

	public function testClassComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Class id="type"><!-- comment -->fixtures.TestClass1</mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.type, Class);
		Assert.equals(fixtures.TestClass1, result.type);
	}

	public function testClassComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Class id="type">fixtures.<!-- comment -->TestClass1</mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.type, Class);
		Assert.equals(fixtures.TestClass1, result.type);
	}

	public function testClassEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Class id="type"></mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isNull(result.type);
	}

	public function testClassEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Class id="type">
					</mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isNull(result.type);
	}

	public function testClassOnlyComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Class id="type"><!-- comment --></mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isNull(result.type);
	}

	public function testClassOnlyComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Class id="type">
						<!-- comment -->
					</mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isNull(result.type);
	}

	public function testClassCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Class id="type"><![CDATA[fixtures.TestClass1]]></mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.type, Class);
		Assert.equals(fixtures.TestClass1, result.type);
	}

	public function testInt():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer">123</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.integer, Int);
		Assert.equals(123, result.integer);
	}

	public function testIntExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer">
						123
					</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.integer, Int);
		Assert.equals(123, result.integer);
	}

	public function testIntComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer">123<!-- comment --></mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.integer, Int);
		Assert.equals(123, result.integer);
	}

	public function testIntComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer"><!-- comment -->123</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.integer, Int);
		Assert.equals(123, result.integer);
	}

	public function testIntComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer">12<!-- comment -->3</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.integer, Int);
		Assert.equals(123, result.integer);
	}

	public function testIntEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer"></mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.integer, Int);
		Assert.equals(0, result.integer);
	}

	public function testIntEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer">
					</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.integer, Int);
		Assert.equals(0, result.integer);
	}

	public function testIntOnlyComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer"><!-- comment --></mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.integer, Int);
		Assert.equals(0, result.integer);
	}

	public function testIntOnlyComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer">
						<!-- comment -->
					</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.integer, Int);
		Assert.equals(0, result.integer);
	}

	public function testIntNegative():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer">-123</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.integer, Int);
		Assert.equals(-123, result.integer);
	}

	public function testIntHexLowerCase():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer">0xbeef</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.integer, Int);
		Assert.equals(0xbeef, result.integer);
	}

	public function testIntHexUpperCase():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer">0xBEEF</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.integer, Int);
		Assert.equals(0xbeef, result.integer);
	}

	public function testIntHexMixedCase():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer">0xbEeF</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.integer, Int);
		Assert.equals(0xbeef, result.integer);
	}

	public function testIntHexNegative():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer">-0xbeef</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.integer, Int);
		Assert.equals(-0xbeef, result.integer);
	}

	public function testIntCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Int id="integer"><![CDATA[123]]></mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.integer, Int);
		Assert.equals(123, result.integer);
	}

	public function testString():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string">hello</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.string, String);
		Assert.equals("hello", result.string);
	}

	public function testStringComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string">hello<!-- comment --></mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.string, String);
		Assert.equals("hello", result.string);
	}

	public function testStringComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string"><!-- comment -->hello</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.string, String);
		Assert.equals("hello", result.string);
	}

	public function testStringComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string">hello<!-- comment -->world</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.string, String);
		Assert.equals("helloworld", result.string);
	}

	public function testStringEmpty1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string"></mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		// child of field element: empty string, child of declarations: null
		Assert.isNull(result.string);
	}

	public function testStringEmpty2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string"/>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		// child of field element: empty string, child of declarations: null
		Assert.isNull(result.string);
	}

	public function testStringEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string">
					</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		// child of field element: empty string, child of declarations: null
		Assert.isNull(result.string);
	}

	public function testStringCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string"><![CDATA[MXHX & Haxe are <cool/>]]></mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.string, String);
		Assert.equals("MXHX & Haxe are <cool/>", result.string);
	}

	public function testStringCDataEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string"><![CDATA[]]></mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		// child of field element: empty string, child of declarations: null
		// normally cdata is unmodified, but the one exception is child of
		// declarations and empty
		Assert.isNull(result.string);
	}

	public function testStringCDataEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string"><![CDATA[ ]]></mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.string, String);
		Assert.equals(" ", result.string);
	}

	public function testStringCDataEmptyExtraWhitespace2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string"><![CDATA[   ]]></mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.string, String);
		Assert.equals("   ", result.string);
	}

	public function testStringCDataEmptyExtraWhitespace3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string">
						<![CDATA[   ]]>
					</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.string, String);
		Assert.equals("   ", result.string);
	}

	public function testStringCDataEmptyExtraWhitespace4():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string">
						<![CDATA[   ]]>
						<![CDATA[   ]]>
					</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.string, String);
		Assert.equals("      ", result.string);
	}

	public function testStringSource():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string" source="source.txt"/>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.string, String);
		Assert.equals("hello", result.string);
	}

	public function testStringSourceEmptyContent():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string" source="source.txt"></mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.string, String);
		Assert.equals("hello", result.string);
	}

	public function testStringSourceEmptyContentExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string" source="source.txt">
					</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.string, String);
		Assert.equals("hello", result.string);
	}

	public function testUInt():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:UInt id="uint">0xFFFFFFFF</mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.uint, Int);
		Assert.equals(0xFFFFFFFF, result.uint);
	}

	public function testUIntHexLowerCase():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:UInt id="uint">0xffffffff</mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.uint, Int);
		Assert.equals(0xFFFFFFFF, result.uint);
	}

	public function testUIntDecimal():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:UInt id="uint">1234</mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.uint, Int);
		Assert.equals(1234, result.uint);
	}

	public function testUIntExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:UInt id="uint">
						0xFFFFFFFF
					</mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.uint, Int);
		Assert.equals(0xFFFFFFFF, result.uint);
	}

	public function testUIntComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:UInt id="uint">0xFFFFFFFF<!-- comment --></mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.uint, Int);
		Assert.equals(0xFFFFFFFF, result.uint);
	}

	public function testUIntComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:UInt id="uint"><!-- comment -->0xFFFFFFFF</mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.uint, Int);
		Assert.equals(0xFFFFFFFF, result.uint);
	}

	public function testUIntComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:UInt id="uint">0xFFFFF<!-- comment -->FFF</mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.uint, Int);
		Assert.equals(0xFFFFFFFF, result.uint);
	}

	public function testUIntEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:UInt id="uint"></mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.uint, Int);
		Assert.equals(0, result.uint);
	}

	public function testUIntEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:UInt id="uint">
					</mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.uint, Int);
		Assert.equals(0, result.uint);
	}

	public function testUIntEmptyOnlyComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:UInt id="uint"><!-- comment --></mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.uint, Int);
		Assert.equals(0, result.uint);
	}

	public function testUIntEmptyOnlyComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:UInt id="uint">
						<!-- comment -->
					</mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.uint, Int);
		Assert.equals(0, result.uint);
	}

	public function testUIntCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:UInt id="uint"><![CDATA[0xFFFFFFFF]]></mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.uint, Int);
		Assert.equals(0xFFFFFFFF, result.uint);
	}

	public function testArray():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Array id="array">
						<mx:String>one</mx:String>
						<mx:String>two</mx:String>
						<mx:String>three</mx:String>
					</mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(3, result.array.length);
		Assert.equals("one", result.array[0]);
		Assert.equals("two", result.array[1]);
		Assert.equals("three", result.array[2]);
	}

	public function testArrayType():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Array id="array" type="String">
						<mx:String>one</mx:String>
						<mx:String>two</mx:String>
						<mx:String>three</mx:String>
					</mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(3, result.array.length);
		Assert.equals("one", result.array[0]);
		Assert.equals("two", result.array[1]);
		Assert.equals("three", result.array[2]);
	}

	public function testArrayComment1():Void {
		var result = MXHXComponent.withMarkup('
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
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(3, result.array.length);
		Assert.equals("one", result.array[0]);
		Assert.equals("two", result.array[1]);
		Assert.equals("three", result.array[2]);
	}

	public function testArrayComment2():Void {
		var result = MXHXComponent.withMarkup('
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
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(3, result.array.length);
		Assert.equals("one", result.array[0]);
		Assert.equals("two", result.array[1]);
		Assert.equals("three", result.array[2]);
	}

	public function testArrayComment3():Void {
		var result = MXHXComponent.withMarkup('
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
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(3, result.array.length);
		Assert.equals("one", result.array[0]);
		Assert.equals("two", result.array[1]);
		Assert.equals("three", result.array[2]);
	}

	public function testArrayEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Array id="array"></mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(0, result.array.length);
	}

	public function testArrayEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Array id="array">
					</mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(0, result.array.length);
	}

	public function testArrayOnlyComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Array id="array"><!-- comment --></mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(0, result.array.length);
	}

	public function testArrayOnlyComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Array id="array">
						<!-- comment -->
					</mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(0, result.array.length);
	}

	public function testArrayStrictUnify():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Array id="array">
						<tests:TestPropertiesSubclass1/>
						<tests:TestPropertiesSubclass2/>
					</mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(2, result.array.length);
		Assert.isOfType(result.array[0], fixtures.TestPropertiesSubclass1);
		Assert.isOfType(result.array[1], fixtures.TestPropertiesSubclass2);
	}

	public function testArrayEmptyStrings():Void {
		var result = MXHXComponent.withMarkup('
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
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(8, result.array.length);
		// child of most elements: empty string, child of declarations: null
		Assert.equals("", result.array[0]);
		Assert.equals("", result.array[1]);
		Assert.equals("", result.array[2]);
		Assert.equals("", result.array[3]);
		Assert.equals(" ", result.array[4]);
		Assert.equals("   ", result.array[5]);
		Assert.equals("   ", result.array[6]);
		Assert.equals("      ", result.array[7]);
	}

	public function testXmlEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstChild:Xml = xml.firstChild();
		Assert.notNull(firstChild);
		Assert.equals(XmlType.PCData, firstChild.nodeType);
		Assert.equals("", firstChild.nodeValue);
		Assert.isNull(xml.firstElement());
	}

	public function testXmlElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element/></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
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
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element attr="value"/></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
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
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element attr1="value1" attr2="value2"/></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
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
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element></element></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
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
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element><child/></element></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
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
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element><child1/><child2></child2></element></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
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
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element><child1><gchild/></child1><child2/></element></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
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
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml">this is text</mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstChild:Xml = xml.firstChild();
		Assert.notNull(firstChild);
		Assert.equals(XmlType.PCData, firstChild.nodeType);
		Assert.equals("this is text", firstChild.nodeValue);
		Assert.isNull(xml.firstElement());
	}

	public function testXmlTextChild():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element>this is text</element></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
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
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><![CDATA[this is cdata]]></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstChild:Xml = xml.firstChild();
		Assert.notNull(firstChild);
		Assert.equals(XmlType.CData, firstChild.nodeType);
		Assert.equals("this is cdata", firstChild.nodeValue);
		Assert.isNull(xml.firstElement());
	}

	public function testXmlCDataChild():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element><![CDATA[this is cdata]]></element></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
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
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><!-- comment --></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstChild:Xml = xml.firstChild();
		Assert.notNull(firstChild);
		Assert.equals(XmlType.Comment, firstChild.nodeType);
		Assert.equals(" comment ", firstChild.nodeValue);
		Assert.isNull(xml.firstElement());
	}

	public function testXmlCommentChild():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element><!-- comment --></element></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
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
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml" source="source.xml"/>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
		Assert.equals(XmlType.Document, xml.nodeType);
		var rootElement:Xml = xml.firstChild();
		Assert.notNull(rootElement);
		Assert.equals(XmlType.Element, rootElement.nodeType);
		Assert.equals("root", rootElement.nodeName);
		Assert.isFalse(rootElement.attributes().hasNext());
		var elements = rootElement.elements();
		Assert.isTrue(elements.hasNext());
		var element = elements.next();
		Assert.equals(XmlType.Element, element.nodeType);
		var child = element.firstChild();
		Assert.notNull(child);
		Assert.equals(XmlType.PCData, child.nodeType);
		Assert.equals("One", child.nodeValue);
		Assert.isTrue(elements.hasNext());
		var element = elements.next();
		Assert.equals(XmlType.Element, element.nodeType);
		var child = element.firstChild();
		Assert.notNull(child);
		Assert.equals(XmlType.PCData, child.nodeType);
		Assert.equals("Two", child.nodeValue);
		Assert.isTrue(elements.hasNext());
		var element = elements.next();
		Assert.equals(XmlType.Element, element.nodeType);
		var child = element.firstChild();
		Assert.notNull(child);
		Assert.equals(XmlType.PCData, child.nodeType);
		Assert.equals("Three", child.nodeValue);
		Assert.isFalse(elements.hasNext());
	}

	public function testXmlSourceEmptyContent():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml" source="source.xml"></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
		Assert.equals(XmlType.Document, xml.nodeType);
		var rootElement:Xml = xml.firstChild();
		Assert.notNull(rootElement);
		Assert.equals(XmlType.Element, rootElement.nodeType);
		Assert.equals("root", rootElement.nodeName);
		Assert.isFalse(rootElement.attributes().hasNext());
		var elements = rootElement.elements();
		Assert.isTrue(elements.hasNext());
		var element = elements.next();
		Assert.equals(XmlType.Element, element.nodeType);
		var child = element.firstChild();
		Assert.notNull(child);
		Assert.equals(XmlType.PCData, child.nodeType);
		Assert.equals("One", child.nodeValue);
		Assert.isTrue(elements.hasNext());
		var element = elements.next();
		Assert.equals(XmlType.Element, element.nodeType);
		var child = element.firstChild();
		Assert.notNull(child);
		Assert.equals(XmlType.PCData, child.nodeType);
		Assert.equals("Two", child.nodeValue);
		Assert.isTrue(elements.hasNext());
		var element = elements.next();
		Assert.equals(XmlType.Element, element.nodeType);
		var child = element.firstChild();
		Assert.notNull(child);
		Assert.equals(XmlType.PCData, child.nodeType);
		Assert.equals("Three", child.nodeValue);
		Assert.isFalse(elements.hasNext());
	}

	public function testXmlSourceEmptyContentExtraWhitespacee():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Xml id="xml" source="source.xml">
					</mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
		Assert.equals(XmlType.Document, xml.nodeType);
		var rootElement:Xml = xml.firstChild();
		Assert.notNull(rootElement);
		Assert.equals(XmlType.Element, rootElement.nodeType);
		Assert.equals("root", rootElement.nodeName);
		Assert.isFalse(rootElement.attributes().hasNext());
		var elements = rootElement.elements();
		Assert.isTrue(elements.hasNext());
		var element = elements.next();
		Assert.equals(XmlType.Element, element.nodeType);
		var child = element.firstChild();
		Assert.notNull(child);
		Assert.equals(XmlType.PCData, child.nodeType);
		Assert.equals("One", child.nodeValue);
		Assert.isTrue(elements.hasNext());
		var element = elements.next();
		Assert.equals(XmlType.Element, element.nodeType);
		var child = element.firstChild();
		Assert.notNull(child);
		Assert.equals(XmlType.PCData, child.nodeType);
		Assert.equals("Two", child.nodeValue);
		Assert.isTrue(elements.hasNext());
		var element = elements.next();
		Assert.equals(XmlType.Element, element.nodeType);
		var child = element.firstChild();
		Assert.notNull(child);
		Assert.equals(XmlType.PCData, child.nodeType);
		Assert.equals("Three", child.nodeValue);
		Assert.isFalse(elements.hasNext());
	}

	public function testComplexEnumValueWithoutParameters():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestComplexEnum id="enumValue">
						<tests:TestComplexEnum.One/>
					</tests:TestComplexEnum>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.equals(TestComplexEnum.One, result.enumValue);
	}

	public function testComplexEnumValueWithParameters():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestComplexEnum id="enumValue">
						<tests:TestComplexEnum.Two a="hello" b="123.4"/>
					</tests:TestComplexEnum>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		switch (result.enumValue) {
			case TestComplexEnum.Two("hello", 123.4):
				Assert.pass();
			default:
				Assert.fail("Wrong enum value: " + result.enumValue);
		}
	}

	public function testDateNoFields():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date"/>
				</mx:Declarations>
			</tests:TestClass1>
		');
		var now = Date.now();
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.date, Date);
		var difference = now.getTime() - result.date.getTime();
		Assert.isTrue(difference < 1000.0);
	}

	public function testDateFullYearAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date" fullYear="2008"/>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.date, Date);
		Assert.equals(2008, result.date.getFullYear());
	}

	public function testDateMonthAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date" month="4"/>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.date, Date);
		Assert.equals(4, result.date.getMonth());
	}

	public function testDateDateAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date" date="25"/>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.date, Date);
		Assert.equals(25, result.date.getDate());
	}

	public function testDateHoursAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date" hours="3"/>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.date, Date);
		Assert.equals(3, result.date.getHours());
	}

	public function testDateMinutesAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date" minutes="47"/>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.date, Date);
		Assert.equals(47, result.date.getMinutes());
	}

	public function testDateSecondsAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date" seconds="51"/>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.date, Date);
		Assert.equals(51, result.date.getSeconds());
	}

	public function testDateFullYearChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date">
						<mx:fullYear>2008</mx:fullYear>
					</mx:Date>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.date, Date);
		Assert.equals(2008, result.date.getFullYear());
	}

	public function testDateMonthChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date">
						<mx:month>4</mx:month>
					</mx:Date>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.date, Date);
		Assert.equals(4, result.date.getMonth());
	}

	public function testDateDateChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date">
						<mx:date>25</mx:date>
					</mx:Date>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.date, Date);
		Assert.equals(25, result.date.getDate());
	}

	public function testDateHoursChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date">
						<mx:hours>3</mx:hours>
					</mx:Date>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.date, Date);
		Assert.equals(3, result.date.getHours());
	}

	public function testDateMinutesChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date">
						<mx:minutes>47</mx:minutes>
					</mx:Date>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.date, Date);
		Assert.equals(47, result.date.getMinutes());
	}

	public function testDateSecondsChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date">
						<mx:seconds>51</mx:seconds>
					</mx:Date>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.date, Date);
		Assert.equals(51, result.date.getSeconds());
	}

	public function testDateMixedAttributesAndChildElements():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Date id="date" fullYear="2008" date="25" minutes="47">
						<mx:month>4</mx:month>
						<mx:hours>3</mx:hours>
						<mx:seconds>51</mx:seconds>
					</mx:Date>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isOfType(result.date, Date);
		Assert.equals(2008, result.date.getFullYear());
		Assert.equals(4, result.date.getMonth());
		Assert.equals(25, result.date.getDate());
		Assert.equals(3, result.date.getHours());
		Assert.equals(47, result.date.getMinutes());
		Assert.equals(51, result.date.getSeconds());
	}

	public function testMultipleDeclarationsTags():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Float id="float">123.4</mx:Float>
				</mx:Declarations>
				<mx:Declarations>
					<mx:String id="string">hello</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.equals(123.4, result.float);
		Assert.equals("hello", result.string);
	}

	public function testFunction():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Function id="func">testMethod</mx:Function>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isTrue(Reflect.isFunction(result.func));
		Assert.isTrue(Reflect.compareMethods(result.testMethod, result.func));
	}

	public function testFunctionExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Function id="func">
						testMethod
					</mx:Function>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isTrue(Reflect.isFunction(result.func));
		Assert.isTrue(Reflect.compareMethods(result.testMethod, result.func));
	}

	public function testFunctionComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Function id="func">testMethod<!-- comment --></mx:Function>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isTrue(Reflect.isFunction(result.func));
		Assert.isTrue(Reflect.compareMethods(result.testMethod, result.func));
	}

	public function testFunctionComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Function id="func"><!-- comment -->testMethod</mx:Function>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isTrue(Reflect.isFunction(result.func));
		Assert.isTrue(Reflect.compareMethods(result.testMethod, result.func));
	}

	public function testFunctionComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Function id="func">test<!-- comment -->Method</mx:Function>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isTrue(Reflect.isFunction(result.func));
		Assert.isTrue(Reflect.compareMethods(result.testMethod, result.func));
	}

	public function testFunctionEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Function id="func"></mx:Function>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isNull(result.func);
	}

	public function testFunctionEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Function id="func">
					</mx:Function>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isNull(result.func);
	}

	public function testFunctionOnlyComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Function id="func"><!-- comment --></mx:Function>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isNull(result.func);
	}

	public function testFunctionOnlyComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Function id="func">
						<!-- comment -->
					</mx:Function>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isNull(result.func);
	}

	public function testFunctionCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Function id="func"><![CDATA[testMethod]]></mx:Function>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isTrue(Reflect.isFunction(result.func));
		Assert.isTrue(Reflect.compareMethods(result.testMethod, result.func));
	}
}
